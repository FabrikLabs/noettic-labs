import Foundation

@main
struct LocalAIProtocolTests {
    static func main() throws {
        var checks = 0
        func check(_ value: Bool, _ message: String) {
            precondition(value, message)
            checks += 1
        }

        // Installed model listing and tag matching.
        let tags = Data(#"{"models":[{"name":"llama3.2:3b","size":1},{"name":"qwen2.5:latest"},{"name":" "}]}"#.utf8)
        let names = try OllamaProtocol.modelNames(fromTagsResponse: tags)
        check(names == ["llama3.2:3b", "qwen2.5:latest"], "Model names are read and blanks dropped: \(names)")
        check(OllamaProtocol.isInstalled("llama3.2:3b", in: names), "Exact tag matches")
        check(OllamaProtocol.isInstalled("qwen2.5", in: names), "An untagged request matches :latest")
        check(OllamaProtocol.isInstalled("QWEN2.5:latest", in: names), "Matching ignores case")
        check(!OllamaProtocol.isInstalled("llama3.2:1b", in: names), "A different tag is a different model")
        check(try OllamaProtocol.modelNames(fromTagsResponse: Data("{}".utf8)).isEmpty, "No models key means nothing installed")
        do {
            _ = try OllamaProtocol.modelNames(fromTagsResponse: Data("[]".utf8))
            check(false, "A non-object response must throw")
        } catch {
            check(error is OllamaProtocol.ProtocolError, "Unexpected response error: \(error)")
        }

        // Pull progress stream.
        let pulling = OllamaProtocol.pullEvent(fromLine: #"{"status":"pulling abc","digest":"sha256:abc","total":2000,"completed":500}"#)
        check(pulling?.fraction == 0.25 && pulling?.isFinished == false, "Progress fraction from completed/total: \(String(describing: pulling))")
        check(OllamaProtocol.progressText(for: pulling ?? OllamaProtocol.PullEvent(status: "", completed: nil, total: nil, error: nil)).contains(" of "), "Readable byte progress")
        let manifest = OllamaProtocol.pullEvent(fromLine: #"{"status":"pulling manifest"}"#)
        check(manifest?.fraction == nil && manifest?.status == "pulling manifest", "Events without sizes have no fraction")
        check(OllamaProtocol.pullEvent(fromLine: #"{"status":"success"}"#)?.isFinished == true, "Success ends the pull")
        check(OllamaProtocol.pullEvent(fromLine: #"{"error":"pull model manifest: file does not exist"}"#)?.error == "pull model manifest: file does not exist", "Errors surface")
        check(OllamaProtocol.pullEvent(fromLine: "   ") == nil && OllamaProtocol.pullEvent(fromLine: "not json") == nil, "Blank and malformed lines are ignored")
        check(OllamaProtocol.pullEvent(fromLine: #"{"status":"x","completed":"7","total":"10"}"#)?.fraction == 0.7, "String counts are tolerated")

        // Request bodies.
        let pull = try JSONSerialization.jsonObject(with: OllamaProtocol.pullRequestBody(model: "llama3.2:3b")) as? [String: Any]
        check(pull?["model"] as? String == "llama3.2:3b" && pull?["stream"] as? Bool == true, "Pull body: \(String(describing: pull))")
        let warm = try JSONSerialization.jsonObject(with: OllamaProtocol.keepAliveRequestBody(model: "m", keepAlive: "12h")) as? [String: Any]
        check(warm?["keep_alive"] as? String == "12h" && warm?["stream"] as? Bool == false && warm?["prompt"] == nil, "Keep-alive body loads without generating: \(String(describing: warm))")

        // Latency policy.
        check(!DictationLatencyPolicy.warrantsAIPass("Yes"), "One word skips cleanup")
        check(!DictationLatencyPolicy.warrantsAIPass("Sounds good, thanks"), "Three words skip cleanup")
        check(DictationLatencyPolicy.warrantsAIPass("Let us know when you're on your way"), "A sentence gets cleanup")
        check(DictationLatencyPolicy.warrantsAIPass("um so basically\nyeah"), "Words split across lines count")
        check(DictationLatencyPolicy.timeout(forInputCharacters: 0) == 12, "Floor of 12 seconds")
        check(DictationLatencyPolicy.timeout(forInputCharacters: 300) == 12, "Short dictations keep the floor")
        check(DictationLatencyPolicy.timeout(forInputCharacters: 1000) == 40, "Timeout scales with length: \(DictationLatencyPolicy.timeout(forInputCharacters: 1000))")
        check(DictationLatencyPolicy.timeout(forInputCharacters: 100_000) == 60, "Capped at a minute")

        print("Local AI protocol: \(checks) checks passed")
    }
}
