import AppKit
import SwiftUI

/// The cleanup engine picker on the Dashboard: two local Llama sizes through Ollama and Groq in
/// the cloud. Handles the Ollama install nudge, model downloads with progress, and key entry.
struct LocalAISetupCard: View {
    @ObservedObject private var service = LocalAIService.shared
    @ObservedObject private var settings = SettingsStore.shared
    @Environment(\.theme) private var theme
    @State private var groqKey = ""
    @State private var showsGroqKeyField = false

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            self.header
            if self.service.phase == .serverMissing {
                self.ollamaBanner
            }
            ForEach(LocalAICleanupEngine.allCases) { engine in
                Divider().opacity(0.4)
                self.engineRow(engine)
            }
            if let error = self.service.lastError {
                Label(error, systemImage: "exclamationmark.triangle")
                    .font(self.theme.typography.caption)
                    .foregroundStyle(self.theme.palette.warning)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(self.theme.palette.cardBackground, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(self.theme.palette.cardBorder.opacity(0.45), lineWidth: 1))
        .task { self.service.beginMonitoring() }
        .onDisappear { self.service.endMonitoring() }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("AI cleanup engines")
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top, spacing: 12) {
            FluidIconTile(icon: "cpu", tint: self.theme.palette.accent)
            VStack(alignment: .leading, spacing: 3) {
                Text("AI cleanup")
                    .font(self.theme.typography.bodySmallStrong)
                Text(self.statusText)
                    .font(self.theme.typography.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
    }

    private var statusText: String {
        if let engine = self.service.activeEngine {
            return "On: \(engine.title). Every dictation of four words or more is cleaned up by \(engine.isLocal ? "Llama on this Mac" : "Groq") before it is typed."
        }
        if let route = self.service.activeRouteDescription {
            return "On, using \(route) from AI Providers. Pick an engine below to switch."
        }
        return "Off. Pick an engine to remove filler words, apply corrections and fix punctuation as you dictate."
    }

    private var ollamaBanner: some View {
        HStack(alignment: .center, spacing: 10) {
            Text("The local engines need Ollama, a free app that runs the model on your Mac. Install it and open it once; this card updates by itself.")
                .font(self.theme.typography.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
            Button("Get Ollama") { self.open(LocalAIDefaults.downloadPage) }
                .fluidGlassAction()
                .fixedSize()
        }
    }

    // MARK: - Engine rows

    private func engineRow(_ engine: LocalAICleanupEngine) -> some View {
        let isActive = self.service.activeEngine == engine
        return VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 3) {
                    HStack(spacing: 6) {
                        Text(engine.title)
                            .font(self.theme.typography.bodySmallStrong)
                        if isActive {
                            Text("Active")
                                .font(self.theme.typography.captionStrong)
                                .foregroundStyle(self.theme.palette.accent)
                        } else if engine.isLocal, self.service.isInstalled(engine) {
                            Text("Installed")
                                .font(self.theme.typography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    Text(engine.detail)
                        .font(self.theme.typography.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                self.action(for: engine, isActive: isActive)
                    .fixedSize()
            }
            if engine.isLocal, self.service.pullingModel == engine.model {
                VStack(alignment: .leading, spacing: 4) {
                    ProgressView(value: self.service.pullFraction ?? 0, total: 1)
                        .progressViewStyle(.linear)
                        .opacity(self.service.pullFraction == nil ? 0.4 : 1)
                    Text(self.service.pullStatus ?? "Preparing download…")
                        .font(self.theme.typography.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
            }
            if engine == .groqCloud, self.showsGroqKeyField, !isActive {
                self.groqKeyEntry
            }
        }
    }

    @ViewBuilder private func action(for engine: LocalAICleanupEngine, isActive: Bool) -> some View {
        if engine.isLocal {
            if self.service.pullingModel == engine.model {
                Button("Cancel") { self.service.cancelPull() }
                    .fluidGlassAction(quiet: true)
            } else if isActive {
                Button("Active") {}
                    .fluidGlassAction(quiet: true)
                    .disabled(true)
            } else if self.service.phase == .serverMissing {
                Button("Needs Ollama") {}
                    .fluidGlassAction(quiet: true)
                    .disabled(true)
            } else if self.service.isInstalled(engine) {
                Button("Use") { self.service.activate(engine) }
                    .fluidGlassAction(prominent: true)
                    .disabled(self.service.pullingModel != nil)
            } else {
                Button("Download & use") { self.service.activate(engine) }
                    .fluidGlassAction(prominent: true)
                    .disabled(self.service.pullingModel != nil || self.service.phase == .checking)
                    .help("Downloads \(engine.downloadSizeText ?? "the model") once, then turns it on.")
            }
        } else if isActive {
            Button("Active") {}
                .fluidGlassAction(quiet: true)
                .disabled(true)
        } else if let storedKey = self.service.storedGroqKey, !self.showsGroqKeyField {
            // A key is already on file (from AI Providers or an earlier setup): one click switches.
            Button {
                Task { await self.service.activateGroq(apiKey: storedKey) }
            } label: {
                HStack(spacing: 6) {
                    if self.service.isVerifyingGroq { ProgressView().controlSize(.small) }
                    Text(self.service.isVerifyingGroq ? "Checking…" : "Use")
                }
            }
            .fluidGlassAction(prominent: true)
            .disabled(self.service.isVerifyingGroq)
            Button("New key") { self.showsGroqKeyField = true }
                .fluidGlassAction(quiet: true)
        } else {
            Button(self.showsGroqKeyField ? "Hide" : "Set up") { self.showsGroqKeyField.toggle() }
                .fluidGlassAction(prominent: !self.showsGroqKeyField, quiet: self.showsGroqKeyField)
        }
    }

    private var groqKeyEntry: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Create a free key at console.groq.com, paste it here, and cleanup moves to Groq. Your local engine stays as the fallback when you are offline.")
                .font(self.theme.typography.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 8) {
                SecureField("Paste your Groq API key", text: self.$groqKey)
                    .textFieldStyle(.roundedBorder)
                    .frame(maxWidth: 360)
                    .disabled(self.service.isVerifyingGroq)
                Button("Get a free key") { self.open(LocalAIDefaults.groqKeysPage) }
                    .fluidGlassAction(quiet: true)
                Button {
                    let key = self.groqKey
                    Task {
                        await self.service.activateGroq(apiKey: key)
                        if self.service.lastError == nil {
                            self.groqKey = ""
                            self.showsGroqKeyField = false
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        if self.service.isVerifyingGroq { ProgressView().controlSize(.small) }
                        Text(self.service.isVerifyingGroq ? "Checking…" : "Save & use")
                    }
                }
                .fluidGlassAction(prominent: true)
                .disabled(self.groqKey.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || self.service.isVerifyingGroq)
            }
        }
    }

    private func open(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        NSWorkspace.shared.open(url)
    }
}
