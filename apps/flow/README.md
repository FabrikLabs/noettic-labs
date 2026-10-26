# Noettic Flow

A Wispr Flow-style dictation app for macOS, built on the open-source
[FluidVoice](https://github.com/altic-dev/FluidVoice) codebase. Hold a hotkey,
speak, and clean text is typed wherever your cursor is. Speech recognition runs
on your Mac; cloud AI cleanup is optional and bring-your-own-key.

It is a standalone app: it lives in `/Applications`, shows a menu bar item, and
can launch at login.

## What you get

| Wispr Flow page | Noettic Flow | Notes |
| --- | --- | --- |
| Dictation | Dashboard, History, Stats | Global hotkey, live overlay, per-app history, daily word counts |
| Dictionary | Dictionary | Corrections (`misspelling → correct spelling`) and custom vocabulary. Imports Wispr Flow CSV files. |
| Style | Styles | Cleanup prompts, assignable per app |
| Transforms | Edit Mode and Command Mode | Rewrite selected text by voice; run actions on your Mac by voice |
| Scratchpad | Scratchpad | A persistent note you dictate into when the words have no home yet |
| Notetaker | Notetaker | Records the meeting app you pick, transcribes with speakers, summarizes locally or with your AI provider |
| Snippets | Not included | Use a Dictionary correction for short expansions |

Speech models: Parakeet (fast, English and 25 languages), Nemotron, Whisper,
Apple Speech. AI cleanup: OpenAI, Groq, Anthropic, Gemini, Ollama, LM Studio and
any OpenAI-compatible endpoint. Keys are stored in the macOS Keychain.

## Requirements

- Apple Silicon Mac running macOS 15 (Sequoia) or later.
- About 1 GB of disk for a speech model.
- Microphone and Accessibility permissions. Notetaker also needs Screen &
  System Audio Recording.

## Install from a GitHub Actions build

Every push that touches `apps/flow` runs the
[Noettic Flow macOS build](../../.github/workflows/flow-macos.yml) workflow.

1. Open the repository's **Actions** tab, pick the latest green
   *Noettic Flow macOS build* run, and download the
   `noettic-flow-<version>-macos-arm64` artifact.
2. Unzip it. Open `Noettic-Flow-<version>.dmg` and drag **Noettic Flow** to
   **Applications** (or unzip `noettic-labs-<version>.zip` and move the app).
3. The build is ad-hoc signed, not notarized, so macOS blocks the first launch.
   Either right-click the app and choose **Open**, then **Open** again, or run:

   ```bash
   xattr -dr com.apple.quarantine "/Applications/Noettic Flow.app"
   ```

4. Launch it from Applications or Spotlight. The onboarding picks a speech
   model, requests Microphone and Accessibility access, and lets you set the
   hotkey. The waveform icon in the menu bar is the app's home afterwards.

Tagged releases (`v0.1.0`, `v0.2.0`, ...) publish the same files under
**Releases**, and the in-app *Check for Updates* looks there.

Because the build is not notarized, macOS forgets the Accessibility grant when
the app's signature changes. If typing stops working after an update, remove
Noettic Flow from **System Settings › Privacy & Security › Accessibility** and
add it again.

## Bring your Wispr Flow dictionary

Noettic Flow reads the same CSV that Wispr Flow's Dictionary page imports:

```csv
Noettic
Fabrik
Noetic,Noettic
Dan Co,Dan Koe
"Whisper Flow","Wispr Flow"
```

- One column is a vocabulary word. Two columns are `misspelling,correction`.
- No header row. Quote a field that contains a comma; double a literal quote.
- Up to 60 characters for a word, 4,000 for a correction. Blank lines are
  ignored and malformed rows are skipped and counted.

To get the file out of Wispr Flow: in Wispr Flow open **Settings › Data and
Privacy › Download your data**. The download includes your dictionary; if it
arrives as a spreadsheet or JSON rather than CSV, save the word and correction
columns as a `.csv`. A file you already prepared for Wispr's own bulk import
works unchanged.

Then in Noettic Flow open **Dictionary**, click the `…` menu, choose
**Import…**, pick the `.csv`, and choose **Merge**. Vocabulary words become
custom words that bias the Parakeet recognizer; corrections become replacement
rules applied to every transcript. The native `.json` export/import is still
there for backups.

## Scratchpad

The **Scratchpad** page is a single note saved to
`~/Library/Application Support/Noettic Flow/Scratchpad.md`. Click into it, hold
your dictation shortcut and speak: the text lands in the note instead of
another app. It autosaves, counts words, and offers **Copy all**, **Save as…**
and **Clear**. It is also available from the menu bar icon.

## Build locally

Xcode 16 or later on macOS 15.

```bash
cd apps/flow
./build.sh            # signed Debug build with your Apple Development identity
./build.sh unsigned   # no signing identity needed
open "DerivedData/Build/Products/Debug/Noettic Flow Debug.app"
```

`./build.sh` picks the first *Apple Development* certificate in your keychain
(a free personal team from Xcode › Settings › Accounts is enough). Set
`NOETTICFLOW_DEVELOPMENT_TEAM` to a 10-character Team ID if you have several.
A signed Debug build keeps its Accessibility grant across rebuilds.

A Release build like CI's:

```bash
cd apps/flow
xcodebuild -project Fluid.xcodeproj -scheme Fluid -configuration Release \
  -destination 'platform=macOS,arch=arm64' -derivedDataPath build/DerivedData \
  CODE_SIGNING_ALLOWED=NO CODE_SIGNING_REQUIRED=NO build
codesign --force --deep --sign - "build/DerivedData/Build/Products/Release/Noettic Flow.app"
```

Fast checks that need only `swiftc`:

```bash
sh Tests/run_wispr_dictionary_csv_tests.sh
sh Tests/run_scratchpad_store_tests.sh
sh Tests/run_page_presentation_tests.sh
```

The full XCTest suite runs with `xcodebuild test -project Fluid.xcodeproj
-scheme Fluid -destination 'platform=macOS,arch=arm64'`; some tests download
speech models.

## Releasing

1. Bump `MARKETING_VERSION` in `Fluid.xcodeproj/project.pbxproj` and
   `CFBundleShortVersionString` in `Info.plist` to the new version.
2. Update `ReleaseHighlightsContent.swift` if the first-launch highlights
   should change.
3. Commit, then tag `v<version>` and push the tag. The workflow refuses a tag
   that does not match the app version, and otherwise publishes the zip, dmg
   and checksums as a GitHub release.

To ship notarized builds later, add an Apple Developer ID certificate to the
workflow, sign with `--options runtime`, and run `notarytool`. The in-app
installer would then also need the team ID added to `SimpleUpdater`.

## What changed from FluidVoice

See [NOTICE.md](NOTICE.md). In short: rebranding, Wispr CSV dictionary import,
Wispr-style navigation (Dictionary, Styles, Notetaker, Scratchpad), the
Scratchpad page, feedback that opens a prefilled GitHub issue instead of
posting to Altic's servers, upstream analytics removed, and update checks that
point at this repository. Fluid Intelligence (Altic's private on-device
enhancement model) is not part of the open-source upstream and is not included.

## License

GPLv3, inherited from FluidVoice. See [LICENSE](LICENSE). The rest of the
`noettic-labs` repository is MIT licensed; the two apply to disjoint files.
