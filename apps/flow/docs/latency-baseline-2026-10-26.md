# Latency baseline, 2026-10-26

Build: first Noettic Flow release build (branch `claude/eager-faraday-3mihxw`, commit
`5677206`). Hardware: MacBook Pro 13-inch, Apple M1, 16 GB, macOS 27.0.1. Voice
engine: Blazing Fast (Parakeet TDT v2). Cleanup: Ollama, `llama3.2:3b`, Balanced.

Measured from `~/Library/Logs/Fluid/Fluid.log` after three dictations in Hold mode.

## Start of recording (key down to microphone live)

| Dictation | Key down | Capture running | Gap |
| --- | --- | --- | --- |
| 1 | 01:06:16.666 | 01:06:17.579 | 0.91 s |
| 2 | 01:10:23.129 | 01:10:23.491 | 0.36 s |

The ready chime was tied to the first audio buffer, so it played at the end of
this gap. Since this baseline the chime plays on the key press itself.

## End of recording (key up to text typed)

| Dictation | Input | Transcription | AI cleanup | Typing | Total |
| --- | --- | --- | --- | --- | --- |
| 1 | 222 chars | 242 ms | 2547 ms | 6 ms | 2.83 s |
| 2 | 9 chars | 1376 ms | skipped (under 4 words) | 8 ms | 1.72 s |
| 3 | 113 chars | 145 ms | 3902 ms | 16 ms | 4.32 s |

Transcription is already fast. The cleanup model dominates: a 3B model on a base
M1 generates roughly 25 tokens per second and rewrites the whole sentence, so the
time tracks the length of what was said. Dictation 3 taking longer than the longer
dictation 1 points at the prompt not being reused between requests.

## Changes made in response

- Ready chime on key press.
- Cleanup engine choice on the Dashboard: Fast (`llama3.2:1b`), Balanced
  (`llama3.2:3b`), Fastest (Groq `llama-3.1-8b-instant`, cloud).
- The cleanup system prompt is evaluated on Ollama right after each cleanup
  finishes, while the model is idle, so the next request only has to process the
  new transcript tokens. (A first version did this on the key press; Ollama serves
  one request per model at a time, so that could delay the real request.)
- A failed cloud cleanup retries once on the last local model before falling back
  to the raw transcript.

Re-measure with the same `tail -n 80 ~/Library/Logs/Fluid/Fluid.log` after a few
dictations and compare the `DICTATION_SUMMARY` lines.

## Raw excerpt (dictation 3)

```
[01:10:23.129] [INFO] [GlobalHotkeyManager] Transcription modifier held (hold mode) - starting
[01:10:23.240] [INFO] [ASRService] 🎤 START() called - beginning recording session
[01:10:23.478] [INFO] [DirectCoreAudioLifecycle] Direct capture start end generation=1 elapsedMs=40
[01:10:23.491] [INFO] [ASRService] ✅ Audio capture running after first PCM (session=32)
[01:10:36.173] [INFO] [GlobalHotkeyManager] Transcription modifier released (hold mode) - stopping
[01:10:36.575] [INFO] [ASRService] Final ASR result | samples=203094 | textChars=119 | confidence=0.9691026
[01:10:36.587] [INFO] [ContentView] Using LLMClient for transcription (streaming=true)
[01:10:40.480] [INFO] [ContentView] Dictation AI post-processing finished in 3902ms provider=ollama model=llama3.2:3b inputChars=113 fallback=false
[01:10:40.480] [INFO] [AppBenchmark] DICTATION_SUMMARY asrMs=145 aiMs=3902 appOverheadMs=259 readyMs=4306 slowest=ai outcome=success
[01:10:40.496] [INFO] [AppBenchmark] PIPELINE_SUMMARY stopToReadyMs=4306 readyToDeliveryMs=16 totalMs=4322 outcome=inserted
```
