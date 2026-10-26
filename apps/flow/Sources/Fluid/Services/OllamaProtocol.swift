import Foundation

/// The few pieces of Ollama's HTTP API that Noettic Flow speaks: listing installed models,
/// pulling one with progress, and keeping a model resident. Pure functions only, so
/// `Tests/run_local_ai_tests.sh` can compile this file standalone.
enum OllamaProtocol {
    struct PullEvent: Equatable {
        let status: String
        let completed: Int64?
        let total: Int64?
        let error: String?

        var isFinished: Bool { self.status == "success" }

        var fraction: Double? {
            guard let completed, let total, total > 0 else { return nil }
            return min(1, max(0, Double(completed) / Double(total)))
        }
    }

    /// Installed model names from `GET /api/tags`.
    static func modelNames(fromTagsResponse data: Data) throws -> [String] {
        let object = try JSONSerialization.jsonObject(with: data)
        guard let dictionary = object as? [String: Any] else { throw ProtocolError.unexpectedResponse }
        let models = dictionary["models"] as? [[String: Any]] ?? []
        return models.compactMap { ($0["name"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines) }.filter { !$0.isEmpty }
    }

    /// Whether `model` is among `installed`, allowing for Ollama's implicit `:latest` tag.
    static func isInstalled(_ model: String, in installed: [String]) -> Bool {
        let wanted = self.canonicalName(model)
        return installed.contains { self.canonicalName($0) == wanted }
    }

    static func canonicalName(_ model: String) -> String {
        let trimmed = model.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return trimmed.contains(":") ? trimmed : "\(trimmed):latest"
    }

    /// One NDJSON line from `POST /api/pull`; nil for blank or unparseable lines.
    static func pullEvent(fromLine line: String) -> PullEvent? {
        let trimmed = line.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty,
              let object = try? JSONSerialization.jsonObject(with: Data(trimmed.utf8)),
              let dictionary = object as? [String: Any]
        else { return nil }
        let error = (dictionary["error"] as? String)?.trimmingCharacters(in: .whitespacesAndNewlines)
        return PullEvent(
            status: (dictionary["status"] as? String) ?? (error == nil ? "" : "error"),
            completed: self.int64(dictionary["completed"]),
            total: self.int64(dictionary["total"]),
            error: error?.isEmpty == false ? error : nil
        )
    }

    static func pullRequestBody(model: String) -> Data {
        self.json(["model": model, "stream": true])
    }

    /// Loads the model (empty prompt) and asks Ollama to keep it in memory for `keepAlive`.
    static func keepAliveRequestBody(model: String, keepAlive: String) -> Data {
        self.json(["model": model, "keep_alive": keepAlive, "stream": false])
    }

    /// A readable download status such as "pulling 1.2 GB of 2.0 GB".
    static func progressText(for event: PullEvent) -> String {
        guard let completed = event.completed, let total = event.total, total > 0 else {
            return event.status.isEmpty ? "Preparing download…" : event.status
        }
        let formatter = ByteCountFormatter()
        formatter.countStyle = .file
        return "\(formatter.string(fromByteCount: completed)) of \(formatter.string(fromByteCount: total))"
    }

    enum ProtocolError: LocalizedError {
        case unexpectedResponse

        var errorDescription: String? {
            "Ollama answered in a format Noettic Flow did not expect. Update Ollama and try again."
        }
    }

    private static func int64(_ value: Any?) -> Int64? {
        switch value {
        case let number as NSNumber: return number.int64Value
        case let text as String: return Int64(text)
        default: return nil
        }
    }

    private static func json(_ object: [String: Any]) -> Data {
        (try? JSONSerialization.data(withJSONObject: object, options: [.sortedKeys])) ?? Data()
    }
}

/// Keeps dictation feeling instant: skip the cleanup pass when it cannot add anything, and never
/// let a slow model hold the transcript hostage.
enum DictationLatencyPolicy {
    /// Fewer words than this are typed as transcribed; "Yes", "Sounds good, thanks" need no rewrite.
    static let minimumWordsForAIPass = 4

    /// Seconds allowed for cleanup before the raw transcript is typed instead. Short dictations
    /// get 12 s, which covers a cold model load; long ones scale up to a minute.
    static let minimumTimeoutSeconds: TimeInterval = 12
    static let maximumTimeoutSeconds: TimeInterval = 60
    static let charactersPerTimeoutSecond: Double = 25

    static func warrantsAIPass(_ transcript: String) -> Bool {
        let words = transcript.split { $0.isWhitespace || $0.isNewline }
        return words.count >= self.minimumWordsForAIPass
    }

    static func timeout(forInputCharacters count: Int) -> TimeInterval {
        let scaled = Double(max(0, count)) / self.charactersPerTimeoutSecond
        return min(self.maximumTimeoutSeconds, max(self.minimumTimeoutSeconds, scaled))
    }
}
