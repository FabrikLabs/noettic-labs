import Combine
import Foundation

/// Constants for the local cleanup engine. Nonisolated so background work can read them.
enum LocalAIDefaults {
    static let providerID = "ollama"
    static let recommendedModel = "llama3.2:3b"
    static let recommendedModelDisplayName = "Llama 3.2 (3B)"
    static let recommendedModelSizeText = "about 2 GB"
    static let host = "http://localhost:11434"
    static let downloadPage = "https://ollama.com/download/mac"
    static let keepAlive = "12h"
    static let keepWarmInterval: Duration = .seconds(240)
}

enum LocalAIPhase: Equatable {
    case checking
    case serverMissing
    case modelMissing
    case pulling
    case ready
    case failed(String)
}

enum LocalAIError: LocalizedError {
    case pullRejected
    case pullFailed(String)
    case pullIncomplete

    var errorDescription: String? {
        switch self {
        case .pullRejected:
            return "Ollama refused the download request. Make sure the Ollama app is running, then try again."
        case let .pullFailed(message):
            return "Ollama could not download the model: \(message)"
        case .pullIncomplete:
            return "The download stopped before it finished. Check your connection and try again."
        }
    }
}

/// Ollama on this Mac as the dictation cleanup engine: finds it, downloads the recommended model,
/// configures it as the verified provider in one step, and keeps the model resident so cleanup
/// never waits on a cold load.
@MainActor
final class LocalAIService: ObservableObject {
    static let shared = LocalAIService()

    @Published private(set) var phase: LocalAIPhase = .checking
    @Published private(set) var pullFraction: Double?
    @Published private(set) var pullStatus: String?
    @Published private(set) var installedModels: [String] = []

    private let settings: SettingsStore
    private var refreshTask: Task<Void, Never>?
    private var pullTask: Task<Void, Never>?
    private var pollTask: Task<Void, Never>?
    private var keepWarmTask: Task<Void, Never>?
    private var monitors = 0

    init(settings: SettingsStore = .shared) {
        self.settings = settings
    }

    // MARK: - State

    /// True when dictation cleanup already routes through a verified Ollama setup.
    var isConfiguredAsDictationProvider: Bool {
        let route = DictationProviderRoute.resolveDictationDefault(settings: self.settings)
        guard route.providerID == LocalAIDefaults.providerID, !route.model.isEmpty else { return false }
        return DictationAIPostProcessingGate.isConfigured()
    }

    /// Offer setup until some cleanup provider works, whichever one the user picked.
    var shouldOfferSetup: Bool {
        !DictationAIPostProcessingGate.isConfigured()
    }

    var modelInstalled: Bool {
        OllamaProtocol.isInstalled(LocalAIDefaults.recommendedModel, in: self.installedModels)
    }

    // MARK: - Detection

    func refresh() {
        guard self.pullTask == nil else { return }
        self.refreshTask?.cancel()
        self.refreshTask = Task { [weak self] in
            guard let self else { return }
            let result = await Self.fetchInstalledModels()
            guard !Task.isCancelled else { return }
            switch result {
            case let .success(models):
                self.installedModels = models
                self.phase = OllamaProtocol.isInstalled(LocalAIDefaults.recommendedModel, in: models) ? .ready : .modelMissing
            case .failure:
                self.installedModels = []
                self.phase = .serverMissing
            }
            self.refreshTask = nil
        }
    }

    /// Cards call this while visible so a freshly installed Ollama is noticed without a click.
    func beginMonitoring() {
        self.monitors += 1
        self.refresh()
        guard self.pollTask == nil else { return }
        self.pollTask = Task { [weak self] in
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(5))
                guard let self, !Task.isCancelled else { return }
                if self.phase == .serverMissing || self.phase == .modelMissing { self.refresh() }
            }
        }
    }

    func endMonitoring() {
        self.monitors = max(0, self.monitors - 1)
        guard self.monitors == 0 else { return }
        self.pollTask?.cancel()
        self.pollTask = nil
    }

    private nonisolated static func fetchInstalledModels() async -> Result<[String], Error> {
        guard let url = URL(string: "\(LocalAIDefaults.host)/api/tags") else { return .failure(URLError(.badURL)) }
        var request = URLRequest(url: url, timeoutInterval: 3)
        request.httpMethod = "GET"
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
                return .failure(URLError(.badServerResponse))
            }
            return .success(try OllamaProtocol.modelNames(fromTagsResponse: data))
        } catch {
            return .failure(error)
        }
    }

    // MARK: - Download

    func pullRecommendedModel() {
        guard self.pullTask == nil else { return }
        self.refreshTask?.cancel()
        self.refreshTask = nil
        self.phase = .pulling
        self.pullFraction = nil
        self.pullStatus = "Contacting Ollama…"
        self.pullTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await self.streamPull(model: LocalAIDefaults.recommendedModel)
                guard !Task.isCancelled else { return }
                self.pullTask = nil
                self.pullStatus = nil
                self.pullFraction = nil
                self.refresh()
            } catch is CancellationError {
                self.pullTask = nil
                self.pullStatus = nil
                self.pullFraction = nil
                self.refresh()
            } catch {
                self.pullTask = nil
                self.pullStatus = nil
                self.pullFraction = nil
                self.phase = .failed(error.localizedDescription)
            }
        }
    }

    func cancelPull() {
        self.pullTask?.cancel()
    }

    private func streamPull(model: String) async throws {
        guard let url = URL(string: "\(LocalAIDefaults.host)/api/pull") else { throw URLError(.badURL) }
        var request = URLRequest(url: url, timeoutInterval: 60 * 60)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = OllamaProtocol.pullRequestBody(model: model)

        let (bytes, response) = try await URLSession.shared.bytes(for: request)
        guard let http = response as? HTTPURLResponse, (200...299).contains(http.statusCode) else {
            throw LocalAIError.pullRejected
        }
        var finished = false
        for try await line in bytes.lines {
            try Task.checkCancellation()
            guard let event = OllamaProtocol.pullEvent(fromLine: line) else { continue }
            if let error = event.error { throw LocalAIError.pullFailed(error) }
            self.pullStatus = OllamaProtocol.progressText(for: event)
            if let fraction = event.fraction { self.pullFraction = fraction }
            if event.isFinished { finished = true }
        }
        guard finished else { throw LocalAIError.pullIncomplete }
    }

    // MARK: - Configuration

    /// Makes Ollama with the recommended model the verified dictation cleanup provider and turns
    /// cleanup on. Mirrors what verifying a provider in AI Providers would record.
    @discardableResult
    func configureAsDictationProvider(model: String = LocalAIDefaults.recommendedModel) -> Bool {
        let providerKey = DictationAIPostProcessingGate.providerKey(for: LocalAIDefaults.providerID)
        let baseURL = ModelRepository.shared.defaultBaseURL(for: LocalAIDefaults.providerID)
        guard !providerKey.isEmpty,
              let fingerprint = DictationAIPostProcessingGate.providerFingerprint(baseURL: baseURL, apiKey: "")
        else { return false }

        var availableModels = self.settings.availableModelsByProvider
        var models = availableModels[providerKey] ?? []
        if !models.contains(model) { models.insert(model, at: 0) }
        availableModels[providerKey] = models
        self.settings.availableModelsByProvider = availableModels

        var selectedModels = self.settings.selectedModelByProvider
        selectedModels[providerKey] = model
        self.settings.selectedModelByProvider = selectedModels

        var fingerprints = self.settings.verifiedProviderFingerprints
        fingerprints[providerKey] = fingerprint
        self.settings.verifiedProviderFingerprints = fingerprints

        self.settings.selectedProviderID = LocalAIDefaults.providerID
        self.settings.enableAIProcessing = true
        self.settings.setDictationPromptSelection(.default)
        self.settings.onboardingAISkipped = false
        DebugLogger.shared.info("Local AI configured: provider=\(LocalAIDefaults.providerID) model=\(model)", source: "LocalAIService")

        self.startKeepWarm()
        Task.detached(priority: .utility) { await Self.warm(model: model) }
        return true
    }

    // MARK: - Keeping the model resident

    /// The Ollama model dictation currently routes to, if any.
    func activeModel() -> String? {
        let route = DictationProviderRoute.resolveDictationDefault(settings: self.settings)
        guard route.providerID == LocalAIDefaults.providerID else { return nil }
        let model = route.model.trimmingCharacters(in: .whitespacesAndNewlines)
        return model.isEmpty ? nil : model
    }

    /// Ollama unloads a model five minutes after its last request. Renew well inside that window
    /// so the first dictation after a quiet spell is as fast as the tenth.
    func startKeepWarm() {
        guard self.keepWarmTask == nil else { return }
        self.keepWarmTask = Task { [weak self] in
            while !Task.isCancelled {
                if let model = self?.activeModel() {
                    await Self.warm(model: model)
                }
                try? await Task.sleep(for: LocalAIDefaults.keepWarmInterval)
            }
        }
    }

    /// Called when a dictation shortcut is pressed; loading overlaps with the user speaking.
    func prewarmIfActive() {
        guard let model = self.activeModel() else { return }
        Task.detached(priority: .userInitiated) { await Self.warm(model: model) }
    }

    nonisolated static func warm(model: String) async {
        guard let url = URL(string: "\(LocalAIDefaults.host)/api/generate") else { return }
        var request = URLRequest(url: url, timeoutInterval: 45)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = OllamaProtocol.keepAliveRequestBody(model: model, keepAlive: LocalAIDefaults.keepAlive)
        _ = try? await URLSession.shared.data(for: request)
    }
}
