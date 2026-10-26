import AppKit
import SwiftUI
import UniformTypeIdentifiers

/// A persistent note to dictate into when the words have no destination yet. The editor opts in
/// to in-app dictation, so the normal shortcut types straight into it while it has focus.
struct ScratchpadView: View {
    @Environment(\.theme) private var theme
    @ObservedObject private var store = ScratchpadStore.shared
    @FocusState private var editorFocused: Bool
    @State private var confirmClear = false
    @State private var copiedAt: Date?

    var body: some View {
        VStack(alignment: .leading, spacing: self.theme.metrics.spacing.lg) {
            self.header
            self.editor
            self.footer
        }
        .fluidPageContent(width: .reading, alignment: .center)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(self.theme.palette.contentBackground)
        .onAppear { self.editorFocused = true }
        .onDisappear { self.store.saveNow() }
        .alert("Clear the scratchpad?", isPresented: self.$confirmClear) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) { self.store.clear() }
        } message: {
            Text("This removes everything in the note. Copy it first if you still need it.")
        }
    }

    // MARK: - Header

    private var header: some View {
        VStack(alignment: .leading, spacing: self.theme.metrics.spacing.sm) {
            Text("Scratchpad")
                .font(self.theme.typography.title)
                .foregroundStyle(self.theme.palette.primaryText)
            Text("Click into the note, hold your dictation shortcut and speak. Everything autosaves on this Mac.")
                .font(self.theme.typography.body)
                .foregroundStyle(self.theme.palette.secondaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Editor

    private var editor: some View {
        let shape = RoundedRectangle(cornerRadius: self.theme.metrics.corners.md, style: .continuous)
        return ZStack(alignment: .topLeading) {
            TextEditor(text: self.$store.text)
                .font(self.theme.typography.body)
                .scrollContentBackground(.hidden)
                .focused(self.$editorFocused)
                .background(DictationTextTarget())
                .padding(self.theme.metrics.spacing.md)
                .accessibilityLabel("Scratchpad note")
            if self.store.text.isEmpty {
                Text("Nothing here yet. Dictate a thought, a draft, or a list.")
                    .font(self.theme.typography.body)
                    .foregroundStyle(self.theme.palette.tertiaryText)
                    .padding(.horizontal, self.theme.metrics.spacing.md + 5)
                    .padding(.vertical, self.theme.metrics.spacing.md + 8)
                    .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 320, maxHeight: .infinity)
        .background(shape.fill(self.theme.palette.cardBackground))
        .overlay(shape.strokeBorder(self.editorFocused ? self.theme.palette.secondaryText.opacity(0.5) : self.theme.palette.separator, lineWidth: 1))
    }

    // MARK: - Footer

    private var footer: some View {
        ViewThatFits(in: .horizontal) {
            HStack(spacing: self.theme.metrics.spacing.md) {
                self.status
                Spacer(minLength: self.theme.metrics.spacing.md)
                self.actions
            }
            VStack(alignment: .leading, spacing: self.theme.metrics.spacing.md) {
                self.status
                self.actions
            }
        }
    }

    private var status: some View {
        HStack(spacing: self.theme.metrics.spacing.sm) {
            Text("\(self.store.wordCount) words")
                .monospacedDigit()
            if let error = self.store.saveError {
                Label("Not saved: \(error)", systemImage: "exclamationmark.triangle")
                    .foregroundStyle(self.theme.palette.warning)
            } else if self.store.hasUnsavedChanges {
                Text("Saving…")
            } else if let savedAt = self.store.lastSavedAt {
                Text("Saved \(savedAt.formatted(date: .omitted, time: .shortened))")
            }
        }
        .font(self.theme.typography.caption)
        .foregroundStyle(self.theme.palette.tertiaryText)
        .lineLimit(1)
    }

    private var actions: some View {
        HStack(spacing: self.theme.metrics.spacing.sm) {
            Button(self.copiedAt == nil ? "Copy all" : "Copied") { self.copyAll() }
                .fluidGlassAction()
                .disabled(self.store.isEmpty)
            Button("Save as…") { self.saveAs() }
                .fluidGlassAction()
                .disabled(self.store.isEmpty)
            Button("Clear") { self.confirmClear = true }
                .fluidGlassAction()
                .disabled(self.store.isEmpty)
        }
    }

    // MARK: - Actions

    private func copyAll() {
        guard ClipboardService.copyToClipboard(self.store.text) else { return }
        let stamp = Date()
        self.copiedAt = stamp
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            if self.copiedAt == stamp { self.copiedAt = nil }
        }
    }

    private func saveAs() {
        self.store.saveNow()
        let panel = NSSavePanel()
        panel.allowedContentTypes = [UTType(filenameExtension: "md") ?? .plainText]
        panel.nameFieldStringValue = "Scratchpad \(Date().formatted(.iso8601.year().month().day())).md"
        panel.canCreateDirectories = true
        guard panel.runModal() == .OK, let url = panel.url else { return }
        do {
            try Data(self.store.text.utf8).write(to: url, options: .atomic)
        } catch {
            let alert = NSAlert()
            alert.messageText = "Could not save the scratchpad"
            alert.informativeText = error.localizedDescription
            alert.alertStyle = .warning
            alert.runModal()
        }
    }
}
