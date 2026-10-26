import AppKit
import Foundation

enum FeedbackCategory: String, CaseIterable {
    case issue = "Report an issue"
    case idea = "Suggest an idea"
    case other = "Something else"

    var icon: String {
        switch self {
        case .issue: "flag"
        case .idea: "lightbulb"
        case .other: "bubble.left"
        }
    }

    var prompt: String {
        switch self {
        case .issue: "What happened?"
        case .idea: "What would you like to do?"
        case .other: "What would you like us to know?"
        }
    }

    var hint: String {
        switch self {
        case .issue: "What were you trying to do? What happened instead? A few steps help us reproduce it."
        case .idea: "Tell us what would make your day easier, and how you’d use it."
        case .other: "The small details count. Share what’s working—or what isn’t."
        }
    }

    /// GitHub label applied to the prefilled issue.
    var issueLabel: String {
        switch self {
        case .issue: "bug"
        case .idea: "enhancement"
        case .other: "question"
        }
    }
}

/// A feedback draft. Noettic Flow has no feedback server; sending opens a prefilled GitHub
/// issue in the browser so the user sees exactly what is shared before submitting it.
struct FeedbackSubmission {
    static let messageLimit = 4500
    static let newIssueURL = "https://github.com/FabrikLabs/noettic-labs/issues/new"

    let email: String
    let message: String
    let category: FeedbackCategory
    let appDetails: String?

    static var appDetails: String {
        let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "Unknown"
        let build = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "Unknown"
        return "Noettic Flow \(version) (\(build))\nmacOS: \(ProcessInfo.processInfo.operatingSystemVersionString)"
    }

    static func isValidEmail(_ value: String) -> Bool {
        let email = value.trimmingCharacters(in: .whitespacesAndNewlines)
        return email.utf16.count <= 254 && email.range(
            of: #"^(?!\.)(?!.*\.\.)([A-Z0-9_'+\-\.]*)[A-Z0-9_+\-]@([A-Z0-9][A-Z0-9\-]*\.)+[A-Z]{2,}$"#,
            options: [.caseInsensitive, .regularExpression]
        ) != nil
    }

    private var trimmedEmail: String {
        self.email.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var content: String {
        var text = "[\(self.category.rawValue)]\n\(self.message.trimmingCharacters(in: .whitespacesAndNewlines))"
        if !self.trimmedEmail.isEmpty { text += "\n\nContact: \(self.trimmedEmail.lowercased())" }
        if let appDetails { text += "\n\n--- App details ---\n\(appDetails)" }
        return text
    }

    var isValid: Bool {
        (self.trimmedEmail.isEmpty || Self.isValidEmail(self.trimmedEmail))
            && !self.message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && self.message.utf16.count <= Self.messageLimit
            && self.content.utf16.count <= 5000
    }

    /// Issue title: the category plus the first line of the message, kept short.
    var issueTitle: String {
        let firstLine = self.message
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .first ?? ""
        let summary = firstLine.count > 72 ? String(firstLine.prefix(72)).trimmingCharacters(in: .whitespaces) + "…" : firstLine
        return summary.isEmpty ? self.category.rawValue : "\(self.category.rawValue): \(summary)"
    }

    func issueURL() -> URL? {
        guard var components = URLComponents(string: Self.newIssueURL) else { return nil }
        components.queryItems = [
            URLQueryItem(name: "title", value: self.issueTitle),
            URLQueryItem(name: "labels", value: self.category.issueLabel),
            URLQueryItem(name: "body", value: self.content),
        ]
        return components.url
    }
}

struct FeedbackClient {
    /// Opens a URL in the default browser. Injected so tests never leave the process.
    var open: @MainActor (URL) -> Bool = { NSWorkspace.shared.open($0) }

    func send(_ submission: FeedbackSubmission) async throws {
        guard submission.isValid, let url = submission.issueURL() else { throw Failure.invalid }
        let opened = await MainActor.run { self.open(url) }
        guard opened else { throw Failure.browser }
    }

    enum Failure: LocalizedError {
        case invalid, browser

        var errorDescription: String? {
            switch self {
            case .invalid: "Add a message within the character limit. The email, if any, must be valid."
            case .browser: "Could not open your browser. Copy your message and file it at \(FeedbackSubmission.newIssueURL)."
            }
        }
    }
}
