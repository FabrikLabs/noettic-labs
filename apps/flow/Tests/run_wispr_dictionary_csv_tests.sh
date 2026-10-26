#!/bin/sh
set -eu
cd "$(dirname "$0")/.."
task_developer_dir="${DEVELOPER_DIR:-$(xcode-select -p)}"
test -d "$task_developer_dir/Platforms/MacOSX.platform"
export DEVELOPER_DIR="$task_developer_dir"
task_test_dir=$(mktemp -d /tmp/noetticflow-wispr-csv.XXXXXX)
trap 'rm -rf "$task_test_dir"' EXIT HUP INT TERM
xcrun swiftc -D WISPR_CSV_STANDALONE -parse-as-library \
    Sources/Fluid/Services/WisprDictionaryCSV.swift \
    Tests/Standalone/WisprDictionaryCSVTests.swift \
    -o "$task_test_dir/tests"
"$task_test_dir/tests"
