import Foundation

@main
struct ScratchpadStoreTests {
    @MainActor
    static func main() async throws {
        var checks = 0
        func check(_ value: Bool, _ message: String) {
            precondition(value, message)
            checks += 1
        }

        let directory = FileManager.default.temporaryDirectory
            .appendingPathComponent("noetticflow-scratchpad-\(UUID().uuidString)", isDirectory: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let fileURL = directory.appendingPathComponent("nested/Scratchpad.md")

        // A missing file is an empty note, not an error.
        let store = ScratchpadStore(fileURL: fileURL, saveDelay: .milliseconds(20))
        check(store.text.isEmpty && store.isEmpty && store.wordCount == 0, "Missing file starts empty")
        check(!store.hasUnsavedChanges, "Nothing to save at launch")

        // Edits autosave after the delay, creating intermediate directories.
        store.text = "First thought"
        check(store.hasUnsavedChanges, "An edit is pending until the debounce fires")
        try await Task.sleep(for: .milliseconds(200))
        check(!store.hasUnsavedChanges && store.lastSavedAt != nil && store.saveError == nil, "Autosave wrote the file")
        check(String(decoding: try Data(contentsOf: fileURL), as: UTF8.self) == "First thought", "File holds the note")

        // Rapid edits coalesce into one write of the latest text.
        store.text = "First thought, "
        store.text = "First thought, second"
        store.saveNow()
        check(String(decoding: try Data(contentsOf: fileURL), as: UTF8.self) == "First thought, second", "saveNow flushes the latest text")

        // Appending separates entries and ignores blank additions.
        store.append("   ")
        check(store.text == "First thought, second", "Blank additions are ignored")
        store.append("Third\n")
        check(store.text == "First thought, second\n\nThird", "Appended text is separated by a blank line: \(store.text)")
        check(store.wordCount == 4, "Word count ignores punctuation-free whitespace: \(store.wordCount)")

        // A second store loads what the first saved; clearing persists an empty file.
        store.saveNow()
        let reloaded = ScratchpadStore(fileURL: fileURL, saveDelay: .milliseconds(20))
        check(reloaded.text == store.text, "Reload reads the saved note")
        reloaded.clear()
        reloaded.saveNow()
        check(String(decoding: try Data(contentsOf: fileURL), as: UTF8.self).isEmpty, "Clear persists an empty note")

        // Write failures surface instead of crashing.
        let blocked = ScratchpadStore(fileURL: directory.appendingPathComponent("nested/Scratchpad.md/impossible.md"), saveDelay: .milliseconds(20))
        blocked.text = "cannot land"
        blocked.saveNow()
        check(blocked.saveError != nil && blocked.hasUnsavedChanges, "A failed write reports an error and keeps the text pending")

        print("Scratchpad store: \(checks) checks passed")
    }
}
