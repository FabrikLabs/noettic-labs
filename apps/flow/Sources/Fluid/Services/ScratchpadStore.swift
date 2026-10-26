import Combine
import Foundation

/// The Scratchpad note: one Markdown file in Application Support that autosaves shortly after
/// each edit, so dictation lands somewhere durable even when it has no destination app yet.
///
/// This file has no app dependencies so `Tests/run_scratchpad_store_tests.sh` can compile it
/// standalone.
@MainActor
final class ScratchpadStore: ObservableObject {
    static let shared = ScratchpadStore()

    @Published var text: String {
        didSet {
            guard self.text != oldValue else { return }
            self.scheduleSave()
        }
    }

    @Published private(set) var lastSavedAt: Date?
    @Published private(set) var saveError: String?

    let fileURL: URL
    private let saveDelay: Duration
    private var saveTask: Task<Void, Never>?
    private var persistedText: String

    init(fileURL: URL? = nil, saveDelay: Duration = .milliseconds(400)) {
        let url = fileURL ?? Self.defaultFileURL()
        let loaded = Self.load(from: url)
        self.fileURL = url
        self.saveDelay = saveDelay
        self.persistedText = loaded
        self.text = loaded
    }

    static func defaultFileURL(appSupportFolder: String = "Noettic Flow") -> URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? FileManager.default.homeDirectoryForCurrentUser.appendingPathComponent("Library/Application Support", isDirectory: true)
        return base
            .appendingPathComponent(appSupportFolder, isDirectory: true)
            .appendingPathComponent("Scratchpad.md", isDirectory: false)
    }

    private static func load(from url: URL) -> String {
        guard let data = try? Data(contentsOf: url), let text = String(data: data, encoding: .utf8) else { return "" }
        return text
    }

    var isEmpty: Bool {
        self.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var wordCount: Int {
        self.text.split { $0.isWhitespace || $0.isNewline }.count
    }

    var hasUnsavedChanges: Bool {
        self.text != self.persistedText
    }

    /// Replaces the note. Dictation and typing go through the bound `text` instead.
    func replace(with newText: String) {
        self.text = newText
    }

    func append(_ addition: String) {
        let trimmed = addition.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        if self.isEmpty {
            self.text = trimmed
        } else {
            let separator = self.text.hasSuffix("\n") ? "" : "\n\n"
            self.text += separator + trimmed
        }
    }

    func clear() {
        self.text = ""
    }

    private func scheduleSave() {
        self.saveTask?.cancel()
        let delay = self.saveDelay
        self.saveTask = Task { [weak self] in
            try? await Task.sleep(for: delay)
            guard !Task.isCancelled else { return }
            self?.saveNow()
        }
    }

    /// Writes immediately. Safe to call at any time; a no-op when nothing changed.
    func saveNow() {
        self.saveTask?.cancel()
        self.saveTask = nil
        guard self.hasUnsavedChanges else { return }
        let snapshot = self.text
        do {
            let directory = self.fileURL.deletingLastPathComponent()
            try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            try Data(snapshot.utf8).write(to: self.fileURL, options: .atomic)
            self.persistedText = snapshot
            self.lastSavedAt = Date()
            self.saveError = nil
        } catch {
            self.saveError = error.localizedDescription
        }
    }
}
