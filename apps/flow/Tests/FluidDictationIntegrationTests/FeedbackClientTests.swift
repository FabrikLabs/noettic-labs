@testable import Noettic_Flow_Debug
import XCTest

final class FeedbackClientTests: XCTestCase {
    private var draft: FeedbackSubmission {
        FeedbackSubmission(email: " TEAM@example.com ", message: " Test message ", category: .issue, appDetails: nil)
    }

    func testContentIncludesCategoryContactAndOptionalDetails() {
        XCTAssertEqual(self.draft.content, "[Report an issue]\nTest message\n\nContact: team@example.com")
        XCTAssertFalse(self.draft.content.contains("macOS"))
        let detailed = FeedbackSubmission(email: "", message: "hello", category: .idea, appDetails: "macOS test")
        XCTAssertEqual(detailed.content, "[Suggest an idea]\nhello\n\n--- App details ---\nmacOS test")
    }

    func testValidationAllowsMissingEmailButNotBadOnes() {
        for email in ["bad", "a@b", ".a@example.com", "a..b@example.com", "a b@example.com"] {
            XCTAssertFalse(FeedbackSubmission.isValidEmail(email), email)
            XCTAssertFalse(FeedbackSubmission(email: email, message: "hello", category: .issue, appDetails: nil).isValid, email)
        }
        XCTAssertTrue(FeedbackSubmission.isValidEmail(" first.last+test@example.com "))
        XCTAssertTrue(FeedbackSubmission(email: "", message: "hello", category: .issue, appDetails: nil).isValid)
        for message in ["  \n", String(repeating: "a", count: 4501), String(repeating: "😀", count: 2251)] {
            XCTAssertFalse(FeedbackSubmission(email: "a@example.com", message: message, category: .issue, appDetails: nil).isValid)
        }
        XCTAssertTrue(FeedbackSubmission(email: "a@example.com", message: String(repeating: "a", count: 4500), category: .issue, appDetails: FeedbackSubmission.appDetails).isValid)
        XCTAssertFalse(FeedbackSubmission(email: "a@example.com", message: "hello", category: .issue, appDetails: String(repeating: "x", count: 5000)).isValid)
    }

    func testIssueURLTargetsRepositoryWithTitleLabelAndBody() throws {
        let url = try XCTUnwrap(self.draft.issueURL())
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        XCTAssertEqual(components.host, "github.com")
        XCTAssertEqual(components.path, "/FabrikLabs/noettic-labs/issues/new")
        let items = Dictionary(uniqueKeysWithValues: (components.queryItems ?? []).map { ($0.name, $0.value ?? "") })
        XCTAssertEqual(items["title"], "Report an issue: Test message")
        XCTAssertEqual(items["labels"], "bug")
        XCTAssertEqual(items["body"], self.draft.content)
    }

    func testIssueTitleTruncatesLongFirstLines() {
        let long = FeedbackSubmission(email: "", message: String(repeating: "word ", count: 40), category: .other, appDetails: nil)
        XCTAssertTrue(long.issueTitle.hasPrefix("Something else: "))
        XCTAssertTrue(long.issueTitle.hasSuffix("…"))
        XCTAssertLessThanOrEqual(long.issueTitle.count, "Something else: ".count + 73)
    }

    func testSendOpensBrowserOnceAndReportsFailures() async throws {
        var opened: [URL] = []
        var client = FeedbackClient()
        client.open = { url in
            opened.append(url)
            return true
        }
        try await client.send(self.draft)
        XCTAssertEqual(opened.count, 1)

        client.open = { _ in false }
        do {
            try await client.send(self.draft)
            XCTFail("Expected a browser failure")
        } catch {
            XCTAssertEqual(error.localizedDescription, FeedbackClient.Failure.browser.localizedDescription)
        }
    }

    func testInvalidDraftNeverOpensBrowser() async {
        var client = FeedbackClient()
        client.open = { _ in
            XCTFail("No browser expected")
            return true
        }
        do {
            try await client.send(FeedbackSubmission(email: "", message: " ", category: .issue, appDetails: nil))
            XCTFail("Expected validation failure")
        } catch {
            XCTAssertEqual(error.localizedDescription, FeedbackClient.Failure.invalid.localizedDescription)
        }
    }
}
