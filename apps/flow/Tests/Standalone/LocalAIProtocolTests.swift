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

        // Prompt priming body: system prompt, one token, kept resident.
        let prime = try JSONSerialization.jsonObject(with: OllamaProtocol.primeRequestBody(model: "m", systemPrompt: "Clean it.", keepAlive: "12h")) as? [String: Any]
        let primeMessages = prime?["messages"] as? [[String: String]]
        check(primeMessages?.first?["role"] == "system" && primeMessages?.first?["content"] == "Clean it.", "Prime body carries the system prompt: \(String(describing: prime))")
        check((prime?["options"] as? [String: Int])?["num_predict"] == 1 && prime?["keep_alive"] as? String == "12h", "Prime body generates one token and keeps the model loaded")

        // Engine catalogue.
        check(LocalAICleanupEngine.match(providerID: "ollama", model: "llama3.2:3b") == .balancedLocal, "3B maps to Balanced")
        check(LocalAICleanupEngine.match(providerID: "Ollama", model: "LLAMA3.2:1b") == .fastLocal, "Matching ignores case")
        check(LocalAICleanupEngine.match(providerID: "groq", model: "openai/gpt-oss-20b") == .groqCloud, "Groq maps to Fastest")
        check(LocalAICleanupEngine.match(providerID: "groq", model: "llama-3.1-8b-instant") == .groqCloud, "A Groq setup on an older preferred model is still Fastest")
        check(LocalAICleanupEngine.match(providerID: "groq", model: "whisper-large-v3") == nil, "Other Groq models are not the card engine")
        check(LocalAICleanupEngine.groqCloud.model == "openai/gpt-oss-20b", "Fastest defaults to the first preferred Groq model")

        // Groq model choice follows what the key can use.
        let groqModels = Data("""
        {"object":"list","data":[{"id":"whisper-large-v3","object":"model"},{"id":"openai/gpt-oss-120b","object":"model"},{"id":"openai/gpt-oss-20b","object":"model"}]}
        """.utf8)
        let offered = try LocalAICleanupEngine.modelIDs(fromOpenAIModelsResponse: groqModels)
        check(offered == ["whisper-large-v3", "openai/gpt-oss-120b", "openai/gpt-oss-20b"], "Parses OpenAI-style model list: \(offered)")
        check(LocalAICleanupEngine.preferredGroqModel(available: offered) == "openai/gpt-oss-20b", "Picks the fastest usable Groq model")
        check(LocalAICleanupEngine.preferredGroqModel(available: ["Llama-3.3-70b-versatile", "whisper-large-v3"]) == "llama-3.3-70b-versatile", "Falls through the preference list, ignoring case")
        check(LocalAICleanupEngine.preferredGroqModel(available: ["whisper-large-v3"]) == nil, "No usable model gives nil")
        check(LocalAICleanupEngine.preferredGroqModel(available: []) == nil, "Empty list gives nil")
        check(LocalAICleanupEngine.match(providerID: "openai", model: "gpt-4o-mini") == nil, "Other providers are not card engines")
        check(LocalAICleanupEngine.match(providerID: "ollama", model: "qwen2.5:3b") == nil, "Other local models are not card engines")
        check(LocalAICleanupEngine.allCases.filter(\.isLocal).count == 2 && !LocalAICleanupEngine.groqCloud.isLocal, "Two local engines, one cloud")

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
