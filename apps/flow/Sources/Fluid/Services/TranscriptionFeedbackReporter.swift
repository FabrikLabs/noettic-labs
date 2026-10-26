import AppKit
import Foundation

/// Shares a dictation example as a prefilled GitHub issue. Nothing leaves the Mac until the
/// user submits the issue in the browser, where the full text is visible first.
enum TranscriptionFeedbackReporter {
    struct Payload: Encodable {
        let rawText: String
        let processedText: String
        let processingModel: String
        let comments: String
    }

    enum ReporterError: LocalizedError {
        case invalidURL
        case browser

        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "Could not build the report link."
            case .browser:
                return "Could not open your browser. File the example at \(TranscriptionFeedbackReporter.newIssueURL)."
            }
        }
    }

    static let newIssueURL = "https://github.com/FabrikLabs/noettic-labs/issues/new"

    static func issueBody(for payload: Payload) -> String {
        var sections: [String] = []
        if !payload.comments.isEmpty { sections.append(payload.comments) }
        sections.append("**Model:** \(payload.processingModel)")
        sections.append("**Heard (raw transcript)**\n\n```\n\(payload.rawText)\n```")
        sections.append("**Output (after processing)**\n\n```\n\(payload.processedText)\n```")
        return sections.joined(separator: "\n\n")
    }

    static func issueURL(for payload: Payload) -> URL? {
        guard var components = URLComponents(string: self.newIssueURL) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "title", value: "Dictation example: \(payload.processingModel)"),
            URLQueryItem(name: "labels", value: "dictation-quality"),
            URLQueryItem(name: "body", value: self.issueBody(for: payload)),
        ]
        return components.url
    }

    static func submit(_ payload: Payload) async throws {
        guard let url = self.issueURL(for: payload) else {
            throw ReporterError.invalidURL
        }
        let opened = await MainActor.run { NSWorkspace.shared.open(url) }
        guard opened else { throw ReporterError.browser }
    }
}
