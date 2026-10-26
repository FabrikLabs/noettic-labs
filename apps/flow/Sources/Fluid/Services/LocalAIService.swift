import Combine
import Foundation

/// Constants for the local cleanup engine. Nonisolated so background work can read them.
enum LocalAIDefaults {
    static let providerID = "ollama"
    static let recommendedModel = LocalAICleanupEngine.fastLocal.model
    static let host = "http://localhost:11434"
    static let downloadPage = "https://ollama.com/download/mac"
    static let groqProviderID = "groq"
    static let groqKeysPage = "https://console.groq.com/keys"
    static let keepAlive = "12h"
    static let keepWarmInterval: Duration = .seconds(240)
    static let fallbackModelDefaultsKey = "LocalAIFallbackModel"
}

enum LocalAIPhase: Equatable {
    case checking
    case serverMissing
    case ready
    case failed(String)
}

enum LocalAIError: LocalizedError {
    case pullRejected
    case pullFailed(String)
    case pullIncomplete
    case keyRejected
    case keyUnreachable(String)

    var errorDescription: String? {
        switch self {
        case .pullRejected:
            return "Ollama refused the download request. Make sure the Ollama app is running, then try again."
        case let .pullFailed(message):
            return "Ollama could not download the model: \(message)"
        case .pullIncomplete:
            return "The download stopped before it finished. Check your connection and try again."
        case .keyRejected:
            return "Groq did not accept that API key. Copy it again from console.groq.com."
        case let .keyUnreachable(message):
            return "Could not reach Groq to check the key: \(message)"
        }
    }
}

/// Dictation cleanup engines: Ollama on this Mac (detected, downloaded and configured from one
/// card) or Groq in the cloud with a local fallback. Also keeps the local model resident and its
/// prompt cached so cleanup never waits on a cold start.
@MainActor
final class LocalAIService: ObservableObject {
    static let shared = LocalAIService()

    @Published private(set) var phase: LocalAIPhase = .checking
    @Published private(set) var installedModels: [String] = []
    @Published private(set) var pullingModel: String?
    @Published private(set) var pullFraction: Double?
    @Published private(set) var pullStatus: String?
    @Published private(set) var isVerifyingGroq = false
    @Published private(set) var lastError: String?

    private let settings: SettingsStore
    private var refreshTask: Task<Void, Never>?
    private var pullTask: Task<Void, Never>?
    private var pollTask: Task<Void, Never>?
    private var keepWarmTask: Task<Void, Never>?
    private var monitors = 0
    private var lastSystemPrompt: String?

    init(settings: SettingsStore = .shared) {
        self.settings = settings
    }

    // MARK: - State

    /// The engine dictation currently routes through, or nil for none or another provider.
    var activeEngine: LocalAICleanupEngine? {
        guard DictationAIPostProcessingGate.isConfigured() else { return nil }
        let route = DictationProviderRoute.resolveDictationDefault(settings: self.settings)
        return LocalAICleanupEngine.match(providerID: route.providerID, model: route.model)
    }

    /// Offer setup until some cleanup provider works, whichever one the user picked.
    var shouldOfferSetup: Bool {
        !DictationAIPostProcessingGate.isConfigured()
    }

    /// "Groq · openai/gpt-oss-120b" style description of whatever dictation routes to now.
    var activeRouteDescription: String? {
        guard DictationAIPostProcessingGate.isConfigured() else { return nil }
        let route = DictationProviderRoute.resolveDictationDefault(settings: self.settings)
        guard !route.providerID.isEmpty else { return nil }
        let provider = ModelRepository.shared.displayName(for: route.providerID)
        return route.model.isEmpty ? provider : "\(provider) · \(route.model)"
    }

    /// A Groq key already stored from AI Providers or an earlier setup, if any.
    var storedGroqKey: String? {
        let key = self.settings.providerAPIKeys[LocalAIDefaults.groqProviderID]?.trimmingCharacters(in: .whitespacesAndNewlines)
        guard let key, !key.isEmpty else { return nil }
        return key
    }

    func isInstalled(_ engine: LocalAICleanupEngine) -> Bool {
        engine.isLocal && OllamaProtocol.isInstalled(engine.model, in: self.installedModels)
    }

    /// The local model to retry with when a cloud cleanup fails: the last local model turned on,
    /// else the best local engine already installed in Ollama (Balanced before Fast).
    var fallbackLocalModel: String? {
        let stored = UserDefaults.standard.string(forKey: LocalAIDefaults.fallbackModelDefaultsKey)?
            .trimmingCharacters(in: .whitespacesAndNewlines)
        if let stored, !stored.isEmpty { return stored }
        let preferred: [LocalAICleanupEngine] = [.balancedLocal, .fastLocal]
        return preferred.first { self.isInstalled($0) }?.model
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
                self.phase = .ready
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
                if self.phase == .serverMissing { self.refresh() }
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

    // MARK: - Local engines

    /// Downloads the engine's model if needed, then makes it the dictation cleanup provider.
    func activate(_ engine: LocalAICleanupEngine) {
        guard engine.isLocal, self.pullTask == nil else { return }
        self.lastError = nil
        if self.isInstalled(engine) {
            self.configureAsDictationProvider(model: engine.model)
            return
        }
        self.refreshTask?.cancel()
        self.refreshTask = nil
        self.pullingModel = engine.model
        self.pullFraction = nil
        self.pullStatus = "Contacting Ollama…"
        self.pullTask = Task { [weak self] in
            guard let self else { return }
            defer {
                self.pullTask = nil
                self.pullingModel = nil
                self.pullStatus = nil
                self.pullFraction = nil
            }
            do {
                try await self.streamPull(model: engine.model)
                guard !Task.isCancelled else { return }
                self.configureAsDictationProvider(model: engine.model)
                self.refresh()
            } catch is CancellationError {
                self.refresh()
            } catch {
                self.lastError = error.localizedDescription
                self.refresh()
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

    /// Makes Ollama with `model` the verified dictation cleanup provider and turns cleanup on.
    /// Mirrors what verifying a provider in AI Providers would record.
    @discardableResult
    func configureAsDictationProvider(model: String = LocalAIDefaults.recommendedModel) -> Bool {
        let baseURL = ModelRepository.shared.defaultBaseURL(for: LocalAIDefaults.providerID)
        guard self.registerVerifiedProvider(providerID: LocalAIDefaults.providerID, model: model, baseURL: baseURL, apiKey: "") else {
            return false
        }
        UserDefaults.standard.set(model, forKey: LocalAIDefaults.fallbackModelDefaultsKey)
        DebugLogger.shared.info("Local AI configured: provider=\(LocalAIDefaults.providerID) model=\(model)", source: "LocalAIService")
        self.startKeepWarm()
        let prompt = self.lastSystemPrompt
        Task.detached(priority: .utility) { await Self.warm(model: model, systemPrompt: prompt) }
        return true
    }

    // MARK: - Groq

    /// Checks the key against Groq, stores it in the Keychain and routes dictation cleanup to Groq.
    /// The last local model stays recorded as the offline fallback.
    func activateGroq(apiKey: String) async {
        let key = apiKey.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !key.isEmpty, !self.isVerifyingGroq else { return }
        self.isVerifyingGroq = true
        self.lastError = nil
        defer { self.isVerifyingGroq = false }

        let engine = LocalAICleanupEngine.groqCloud
        let baseURL = ModelRepository.shared.defaultBaseURL(for: engine.providerID)
        do {
            try await Self.verifyBearerKey(key, baseURL: baseURL)
        } catch {
            self.lastError = error.localizedDescription
            return
        }

        var keys = self.settings.providerAPIKeys
        keys[engine.providerID] = key
        self.settings.providerAPIKeys = keys
        guard self.registerVerifiedProvider(providerID: engine.providerID, model: engine.model, baseURL: baseURL, apiKey: key) else {
            self.lastError = "Could not save the Groq setup."
            return
        }
        DebugLogger.shared.info("Cloud cleanup configured: provider=\(engine.providerID) model=\(engine.model)", source: "LocalAIService")
    }

    private nonisolated static func verifyBearerKey(_ key: String, baseURL: String) async throws {
        let trimmedBase = baseURL.hasSuffix("/") ? String(baseURL.dropLast()) : baseURL
        guard let url = URL(string: "\(trimmedBase)/models") else { throw URLError(.badURL) }
        var request = URLRequest(url: url, timeoutInterval: 15)
        request.httpMethod = "GET"
        request.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        let reply: (data: Data, response: URLResponse)
        do {
            reply = try await URLSession.shared.data(for: request)
        } catch {
            throw LocalAIError.keyUnreachable(error.localizedDescription)
        }
        guard let http = reply.response as? HTTPURLResponse else { throw LocalAIError.keyUnreachable("no response") }
        switch http.statusCode {
        case 200...299: return
        case 401, 403: throw LocalAIError.keyRejected
        default: throw LocalAIError.keyUnreachable("HTTP \(http.statusCode)")
        }
    }

    // MARK: - Shared registration

    private func registerVerifiedProvider(providerID: String, model: String, baseURL: String, apiKey: String) -> Bool {
        let providerKey = DictationAIPostProcessingGate.providerKey(for: providerID)
        guard !providerKey.isEmpty,
              let fingerprint = DictationAIPostProcessingGate.providerFingerprint(baseURL: baseURL, apiKey: apiKey)
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

        self.settings.selectedProviderID = providerID
        // The Default cleanup style may be pinned to an older provider/model pair (AI Providers
        // writes one); point it at this engine so routing follows the card.
        var configuration = self.settings.dictationPromptConfiguration(for: .default)
        configuration.providerID = providerID
        configuration.modelName = model
        self.settings.setDictationPromptConfiguration(configuration, for: .default)
        self.settings.enableAIProcessing = true
        self.settings.setDictationPromptSelection(.default)
        self.settings.onboardingAISkipped = false
        return true
    }

    // MARK: - Keeping the local model resident and primed

    /// The Ollama model dictation currently routes to, if any.
    func activeModel() -> String? {
        let route = DictationProviderRoute.resolveDictationDefault(settings: self.settings)
        guard route.providerID == LocalAIDefaults.providerID else { return nil }
        let model = route.model.trimmingCharacters(in: .whitespacesAndNewlines)
        return model.isEmpty ? nil : model
    }

    /// Ollama unloads a model five minutes after its last request. Renew well inside that window
    /// so the first dictation after a quiet spell is as fast as the tenth. This only loads the
    /// model; it never evaluates a prompt, so it cannot sit in front of a real request.
    func startKeepWarm() {
        guard self.keepWarmTask == nil else { return }
        self.keepWarmTask = Task { [weak self] in
            while !Task.isCancelled {
                if let self, let model = self.activeModel() {
                    await Self.warm(model: model, systemPrompt: nil)
                }
                try? await Task.sleep(for: LocalAIDefaults.keepWarmInterval)
            }
        }
    }

    /// Called when a dictation shortcut is pressed: makes sure the model is loaded while the user
    /// speaks. Ollama serves one request at a time per model, so nothing heavier runs here.
    func prewarmIfActive(systemPrompt: String?) {
        if let systemPrompt, !systemPrompt.isEmpty { self.lastSystemPrompt = systemPrompt }
        guard let model = self.activeModel() else { return }
        Task.detached(priority: .userInitiated) { await Self.warm(model: model, systemPrompt: nil) }
    }

    /// Called once a dictation's cleanup has finished: the model is idle, so evaluating the cleanup
    /// prompt now leaves it in Ollama's prompt cache for the next dictation.
    func primeAfterCompletion() {
        guard let model = self.activeModel(), let prompt = self.lastSystemPrompt, !prompt.isEmpty else { return }
        Task.detached(priority: .utility) { await Self.warm(model: model, systemPrompt: prompt) }
    }

    nonisolated static func warm(model: String, systemPrompt: String?) async {
        let endpoint = systemPrompt?.isEmpty == false ? "/api/chat" : "/api/generate"
        guard let url = URL(string: "\(LocalAIDefaults.host)\(endpoint)") else { return }
        var request = URLRequest(url: url, timeoutInterval: 45)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let systemPrompt, !systemPrompt.isEmpty {
            request.httpBody = OllamaProtocol.primeRequestBody(model: model, systemPrompt: systemPrompt, keepAlive: LocalAIDefaults.keepAlive)
        } else {
            request.httpBody = OllamaProtocol.keepAliveRequestBody(model: model, keepAlive: LocalAIDefaults.keepAlive)
        }
        _ = try? await URLSession.shared.data(for: request)
    }
}
