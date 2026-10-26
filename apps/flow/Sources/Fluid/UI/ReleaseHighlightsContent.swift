import Foundation

/// Edit this definition for each release. The renderer and acknowledgement logic stay unchanged.
struct ReleaseHighlightsContent {
    enum Destination { case meetings, dashboard, aiProviders }
    enum Preview { case meeting, dashboard, models }

    struct Feature: Identifiable {
        let id: String
        let preview: Preview
        let eyebrow: String
        let title: String
        let detail: String
        let action: String
        let destination: Destination
    }

    let release: String
    let title: String
    let subtitle: String
    let officialSiteNotice: String
    let features: [Feature]

    static func current(hasPrivateAI: Bool) -> Self {
        Self(
            release: "0.1.0",
            title: "Welcome to Noettic Flow",
            subtitle: "Hold your hotkey, speak, and clean text lands wherever your cursor is. Everything runs on your Mac.",
            officialSiteNotice: "**Built on FluidVoice.** Noettic Flow is an open-source fork of [FluidVoice](https://github.com/altic-dev/FluidVoice) "
                + "with Wispr-style Dictionary, Styles, Notetaker and Scratchpad pages. Source and releases live at "
                + "[github.com/FabrikLabs/noettic-labs](https://github.com/FabrikLabs/noettic-labs).",
            features: [
                Feature(
                    id: "dictionary-import",
                    preview: .dashboard,
                    eyebrow: "BRING YOUR WORDS",
                    title: "Import your Wispr Flow dictionary",
                    detail: "Dictionary › Import accepts the CSV Wispr Flow exports, one word per line or misspelling,correction pairs.",
                    action: "Open Dashboard",
                    destination: .dashboard
                ),
                Feature(
                    id: "notetaker",
                    preview: .meeting,
                    eyebrow: "MEETINGS, CAPTURED",
                    title: "Notetaker records and summarizes meetings",
                    detail: "Record the meeting app you choose, get a transcript with speakers, and summarize on-device or with your AI provider.",
                    action: "Open Notetaker",
                    destination: .meetings
                ),
            ]
        )
    }
}
