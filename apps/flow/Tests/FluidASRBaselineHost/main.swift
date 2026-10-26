import AppKit
import Foundation

if CommandLine.arguments.contains(MeetingReferenceSynchronizerReplayCLI.argument)
    || ProcessInfo.processInfo.environment[MeetingReferenceSynchronizerReplayCLI.environmentKey] == "1"
{
    let status = MeetingReferenceSynchronizerReplayCLI.run(
        arguments: CommandLine.arguments,
        // A path-selected replay does not need stdin. Avoid waiting on an attached
        // terminal before the CLI opens the explicitly supplied local fixture.
        inputData: CommandLine.arguments.contains("--input")
            ? Data() : (MeetingReferenceSynchronizerReplayCLI.readBoundedStandardInput() ?? Data()),
        output: { data in
            FileHandle.standardOutput.write(data)
            FileHandle.standardOutput.write(Data([0x0a]))
        }
    )
    exit(status)
}

assert(
    Bundle.main.bundleIdentifier == "com.noetticlabs.flow.ASRBaselineHost",
    "FluidASRBaselineHost must run as com.noetticlabs.flow.ASRBaselineHost"
)

let app = NSApplication.shared
app.setActivationPolicy(.prohibited)
app.run()
