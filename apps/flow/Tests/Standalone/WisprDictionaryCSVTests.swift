import Foundation

@main
struct WisprDictionaryCSVTests {
    static func main() throws {
        var checks = 0
        func check(_ value: Bool, _ message: String) {
            precondition(value, message)
            checks += 1
        }
        func firstReplacement(_ text: String) -> (String, String) {
            let first = WisprDictionaryCSV.parse(text: text).replacements.first
            return (first?.misspelling ?? "", first?.correction ?? "")
        }

        // One and two column rows, Unix and Windows line endings, surrounding whitespace.
        let basic = WisprDictionaryCSV.parse(text: "Noettic\r\nNoetic,Noettic\n  Dan Co , Dan Koe \n\n\nFabrik\n")
        check(basic.vocabulary == ["Noettic", "Fabrik"], "Vocabulary rows import in order: \(basic.vocabulary)")
        let expectedBasic: [WisprDictionaryCSV.Replacement] = [
            .init(misspelling: "Noetic", correction: "Noettic"),
            .init(misspelling: "Dan Co", correction: "Dan Koe"),
        ]
        check(basic.replacements == expectedBasic, "Two-column rows become corrections: \(basic.replacements)")
        check(basic.skippedRows == 0, "Blank lines are ignored, not skipped")

        // Quoting rules from Wispr's help centre.
        check(firstReplacement("\"Whisper Flow\",\"Wispr Flow\"") == ("Whisper Flow", "Wispr Flow"), "Quoted fields")
        check(firstReplacement("Whisper Flow,Wispr Flow") == ("Whisper Flow", "Wispr Flow"), "Unquoted fields with spaces")
        check(firstReplacement("\"say \"\"hi\"\", please\",greeting") == ("say \"hi\", please", "greeting"), "Doubled quotes and embedded commas")
        check(firstReplacement("don\"t,do not") == ("don\"t", "do not"), "A quote inside an unquoted field is literal")
        let unterminated = WisprDictionaryCSV.parse(text: "\"broken,row\nok")
        check(unterminated.vocabulary == ["ok"] && unterminated.skippedRows == 1, "Unterminated quote skips only that row")

        // Empty fields and trailing commas.
        check(firstReplacement("hello,world,") == ("hello", "world"), "Trailing comma is harmless")
        check(WisprDictionaryCSV.parse(text: "word,").vocabulary == ["word"], "Trailing comma on a single word")
        check(WisprDictionaryCSV.parse(text: "   ,correction").vocabulary == ["correction"], "Blank first field imports the correction as vocabulary")
        let onlyCommas = WisprDictionaryCSV.parse(text: ",,\n\"\"\n")
        check(onlyCommas.isEmpty, "Rows with only empty fields import nothing")
        let threeColumns = WisprDictionaryCSV.parse(text: "a,b,c\nkeep")
        check(threeColumns.vocabulary == ["keep"] && threeColumns.skippedRows == 1, "More than two non-empty columns is skipped")

        // Length limits.
        let longWord = String(repeating: "a", count: 61)
        let maxWord = String(repeating: "b", count: 60)
        let limits = WisprDictionaryCSV.parse(text: "\(longWord)\n\(maxWord)\nshort,\(String(repeating: "c", count: 4001))")
        check(limits.vocabulary == [maxWord] && limits.skippedRows == 2, "60/4000 character limits: \(limits)")

        // Invisible characters and duplicates.
        let invisible = WisprDictionaryCSV.parse(text: "\u{200B}\u{200B}\n\u{FEFF}Noettic\u{200B},Fixed\nnoettic,Other\nNOETTIC")
        check(invisible.replacements == [.init(misspelling: "Noettic", correction: "Fixed")], "Zero-width padding is trimmed and the first occurrence wins: \(invisible.replacements)")
        check(invisible.vocabulary.isEmpty && invisible.skippedRows == 1, "Invisible-only rows are skipped, later duplicates are dropped silently")

        // Unicode content survives.
        let unicode = WisprDictionaryCSV.parse(text: "café,Café\n日本語\n🚀 launch")
        check(unicode.replacements.first?.correction == "Café" && unicode.vocabulary == ["日本語", "🚀 launch"], "Accents, CJK and emoji are accepted")

        // Data entry points.
        check((try? WisprDictionaryCSV.parse(data: Data("\u{FEFF}Noettic\n".utf8)))?.vocabulary == ["Noettic"], "A UTF-8 BOM is ignored")
        do {
            _ = try WisprDictionaryCSV.parse(data: Data("\n , \n".utf8))
            check(false, "Empty files must throw")
        } catch let error as WisprDictionaryCSV.ParseError {
            check(error == .noEntries(skippedRows: 0), "Empty file error: \(error)")
        }
        do {
            _ = try WisprDictionaryCSV.parse(data: Data([0xFF, 0xFE, 0x00, 0xD8]))
            check(false, "Invalid UTF-8 must throw")
        } catch let error as WisprDictionaryCSV.ParseError {
            check(error == .unreadableText, "Invalid encoding error: \(error)")
        }

        print("Wispr dictionary CSV: \(checks) checks passed")
    }
}
