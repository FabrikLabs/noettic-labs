import AppKit
import SwiftUI

/// Walks the user from "no cleanup model" to "Ollama running Llama 3.2" in three clicks: get
/// Ollama, download the model, turn it on. Stays on the Dashboard until cleanup works.
struct LocalAISetupCard: View {
    var onDismiss: (() -> Void)?
    @ObservedObject private var service = LocalAIService.shared
    @Environment(\.theme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                FluidIconTile(icon: "cpu", tint: self.theme.palette.accent)
                VStack(alignment: .leading, spacing: 3) {
                    Text(self.title)
                        .font(self.theme.typography.bodySmallStrong)
                    Text(self.detail)
                        .font(self.theme.typography.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                Spacer(minLength: 8)
                self.actions
            }
            if self.service.phase == .pulling {
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
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(self.theme.palette.cardBackground, in: RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 14, style: .continuous).strokeBorder(self.theme.palette.cardBorder.opacity(0.45), lineWidth: 1))
        .task { self.service.beginMonitoring() }
        .onDisappear { self.service.endMonitoring() }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Local AI cleanup setup. \(self.title). \(self.detail)")
    }

    private var title: String {
        switch self.service.phase {
        case .checking: return "Looking for Ollama…"
        case .serverMissing: return "Turn on AI cleanup"
        case .modelMissing: return "Download the cleanup model"
        case .pulling: return "Downloading \(LocalAIDefaults.recommendedModelDisplayName)…"
        case .ready: return "Local AI is ready"
        case .failed: return "Local AI setup hit a snag"
        }
    }

    private var detail: String {
        switch self.service.phase {
        case .checking:
            return "Checking whether Ollama is running on this Mac."
        case .serverMissing:
            return "Install Ollama, a free app that runs the cleanup model on your Mac, and open it once. This card updates by itself."
        case .modelMissing:
            return "\(LocalAIDefaults.recommendedModelDisplayName), \(LocalAIDefaults.recommendedModelSizeText). Removes filler words and tidies punctuation without sending anything off your Mac."
        case .pulling:
            return "You can keep dictating meanwhile; cleanup switches on when the download finishes."
        case .ready:
            return "Use \(LocalAIDefaults.recommendedModelDisplayName) to clean up every dictation, entirely on this Mac."
        case let .failed(message):
            return message
        }
    }

    @ViewBuilder private var actions: some View {
        HStack(spacing: 8) {
            switch self.service.phase {
            case .checking:
                ProgressView().controlSize(.small)
            case .serverMissing:
                Button("Get Ollama") { self.openDownloadPage() }
                    .fluidGlassAction(prominent: true)
                Button("Check again") { self.service.refresh() }
                    .fluidGlassAction(quiet: true)
            case .modelMissing:
                Button("Download") { self.service.pullRecommendedModel() }
                    .fluidGlassAction(prominent: true)
            case .pulling:
                Button("Cancel") { self.service.cancelPull() }
                    .fluidGlassAction(quiet: true)
            case .ready:
                Button("Turn on") { self.service.configureAsDictationProvider() }
                    .fluidGlassAction(prominent: true)
            case .failed:
                Button("Try again") { self.service.refresh() }
                    .fluidGlassAction(prominent: true)
            }
            if let onDismiss, self.service.phase != .pulling {
                Button("Not now", action: onDismiss)
                    .fluidGlassAction(quiet: true)
            }
        }
        .fixedSize()
    }

    private func openDownloadPage() {
        guard let url = URL(string: LocalAIDefaults.downloadPage) else { return }
        NSWorkspace.shared.open(url)
    }
}
