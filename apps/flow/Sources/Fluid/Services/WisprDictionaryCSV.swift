import Foundation

/// Parses the CSV that Wispr Flow's Dictionary page imports and exports, so a Wispr user can
/// bring their words across in one step.
///
/// Format (per Wispr's help centre): no header row; one column for a vocabulary word, or two
/// columns for `misspelling,correction`. Fields may be double-quoted, with `""` for a literal
/// quote. Blank lines are ignored. Rows with an unterminated quote, more than two non-empty
/// columns, an over-long field, or only invisible characters are skipped. The first field is
/// limited to 60 characters and the correction to 4,000. Duplicates (case-insensitive, after
/// trimming) keep the first valid occurrence.
///
/// This file has no app dependencies so `Tests/run_wispr_dictionary_csv_tests.sh` can compile
/// it standalone.
enum WisprDictionaryCSV {
    struct Replacement: Equatable {
        let misspelling: String
        let correction: String
    }

    struct ParseResult: Equatable {
        var replacements: [Replacement] = []
        var vocabulary: [String] = []
        /// Rows that held content but were not importable.
        var skippedRows = 0

        var isEmpty: Bool { self.replacements.isEmpty && self.vocabulary.isEmpty }
        var entryCount: Int { self.replacements.count + self.vocabulary.count }
    }

    enum ParseError: LocalizedError, Equatable {
        case unreadableText
        case noEntries(skippedRows: Int)
        /// A row whose quoted field never closes. Only `splitFields` throws it; `parse` skips the row.
        case unterminatedQuote

        var errorDescription: String? {
            switch self {
            case .unreadableText:
                return "The selected file is not UTF-8 text. Export the dictionary from Wispr Flow again."
            case let .noEntries(skippedRows):
                if skippedRows > 0 {
                    return "No dictionary items found in file. \(skippedRows) row(s) were skipped because they were not in Wispr Flow's CSV format."
                }
                return "No dictionary items found in file."
            case .unterminatedQuote:
                return "A quoted field is missing its closing quote."
            }
        }
    }

    static let maxWordLength = 60
    static let maxCorrectionLength = 4000

    static func parse(data: Data) throws -> ParseResult {
        guard let text = String(bytes: data, encoding: .utf8) else {
            throw ParseError.unreadableText
        }
        let result = self.parse(text: text)
        guard !result.isEmpty else { throw ParseError.noEntries(skippedRows: result.skippedRows) }
        return result
    }

    static func parse(text: String) -> ParseResult {
        var result = ParseResult()
        var seenKeys: Set<String> = []
        let normalized = text.hasPrefix("\u{FEFF}") ? String(text.dropFirst()) : text

        for rawLine in normalized.split(omittingEmptySubsequences: false, whereSeparator: { $0 == "\n" || $0 == "\r\n" || $0 == "\r" }) {
            let line = String(rawLine)
            let hasInvisible = line.unicodeScalars.contains { self.isInvisible($0) }
            let isBlank = !hasInvisible && line.unicodeScalars.allSatisfy { CharacterSet.whitespacesAndNewlines.contains($0) }
            if isBlank { continue }

            guard let fields = try? self.splitFields(line) else {
                result.skippedRows += 1
                continue
            }
            let values = fields.map(self.cleaned).filter { !$0.isEmpty }
            guard !values.isEmpty else {
                // Commas, quotes or spaces only import nothing. A word made only of invisible
                // characters is reported as skipped, as Wispr Flow does.
                if hasInvisible { result.skippedRows += 1 }
                continue
            }
            guard values.count <= 2 else {
                result.skippedRows += 1
                continue
            }

            let first = values[0]
            guard first.count <= self.maxWordLength, !self.isInvisible(first) else {
                result.skippedRows += 1
                continue
            }
            let key = first.lowercased()
            guard !seenKeys.contains(key) else { continue }

            if values.count == 2 {
                let correction = values[1]
                guard correction.count <= self.maxCorrectionLength, !self.isInvisible(correction) else {
                    result.skippedRows += 1
                    continue
                }
                seenKeys.insert(key)
                result.replacements.append(Replacement(misspelling: first, correction: correction))
            } else {
                seenKeys.insert(key)
                result.vocabulary.append(first)
            }
        }
        return result
    }

    // MARK: - CSV mechanics

    /// Splits one line into raw fields. Throws `ParseError.unterminatedQuote` when a quoted field never closes.
    static func splitFields(_ line: String) throws -> [String] {
        var fields: [String] = []
        var current = ""
        var iterator = line.makeIterator()
        var pending: Character? = iterator.next()

        func advance() -> Character? {
            let value = pending
            pending = iterator.next()
            return value
        }

        var fieldStarted = false
        while let character = advance() {
            if character == "," {
                fields.append(current)
                current = ""
                fieldStarted = false
                continue
            }
            if character == "\"", !fieldStarted, current.allSatisfy(\.isWhitespace) {
                // Quoted field: read until the closing quote; "" is a literal quote.
                current = ""
                var closed = false
                while let inner = advance() {
                    if inner == "\"" {
                        if pending == "\"" {
                            _ = advance()
                            current.append("\"")
                        } else {
                            closed = true
                            break
                        }
                    } else {
                        current.append(inner)
                    }
                }
                guard closed else { throw ParseError.unterminatedQuote }
                // Anything between the closing quote and the next comma is dropped.
                while let trailing = pending, trailing != "," {
                    _ = advance()
                }
                fieldStarted = true
                continue
            }
            current.append(character)
            if !character.isWhitespace { fieldStarted = true }
        }
        fields.append(current)
        return fields
    }

    /// Trims whitespace and invisible characters from both ends of a field.
    static func cleaned(_ field: String) -> String {
        var scalars = Substring(field).unicodeScalars
        while let first = scalars.first, self.isTrimmable(first) { scalars.removeFirst() }
        while let last = scalars.last, self.isTrimmable(last) { scalars.removeLast() }
        return String(scalars)
    }

    private static func isTrimmable(_ scalar: Unicode.Scalar) -> Bool {
        CharacterSet.whitespacesAndNewlines.contains(scalar) || self.isInvisible(scalar)
    }

    private static func isInvisible(_ scalar: Unicode.Scalar) -> Bool {
        if CharacterSet.whitespacesAndNewlines.contains(scalar) { return false }
        switch scalar.value {
        case 0x200B...0x200F, 0x2028...0x202E, 0x2060...0x2064, 0xFEFF, 0x00AD, 0x180E:
            return true
        default:
            return CharacterSet.controlCharacters.contains(scalar)
        }
    }

    /// True when nothing visible would be typed: only invisible scalars, whitespace or combining marks.
    static func isInvisible(_ text: String) -> Bool {
        text.unicodeScalars.allSatisfy { scalar in
            self.isTrimmable(scalar) || scalar.properties.generalCategory == .nonspacingMark || scalar.properties.generalCategory == .format
        }
    }
}

#if !WISPR_CSV_STANDALONE
extension WisprDictionaryCSV {
    /// The parsed CSV in the app's native transfer shape: misspellings become replacement rules and
    /// single words become custom (boost) words, exactly as a JSON import would.
    static func document(from data: Data) throws -> DictionaryTransferDocument {
        let parsed = try self.parse(data: data)
        return DictionaryTransferDocument(
            replacements: parsed.replacements.map { DictionaryTransferReplacement(from: [$0.misspelling], to: $0.correction) },
            customWords: parsed.vocabulary
        )
    }
}
#endif
