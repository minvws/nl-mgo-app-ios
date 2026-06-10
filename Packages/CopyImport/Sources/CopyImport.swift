/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGOCommandLine

/// Converts Lokalise-exported `.strings` and `.stringsdict` files into
/// a single `.xcstrings` catalog.
///
/// Invoked by `make download_translations` after the files are downloaded from Lokalise.
/// - `--source-path`: flat key/value `.strings` file
/// - `--stringsdict-path`: optional plural variants in Apple plist XML format
/// - `--target-path`: output `.xcstrings` JSON file
@main
struct CopyImport: ParsableCommand {

	@Option(help: "The source path to the translation file")
	public var sourcePath: String

	@Option(help: "The target path to the translation file")
	public var targetPath: String

	@Option(help: "The optional path to the stringsdict plurals file")
	public var stringsdictPath: String?

	public func run() throws {

		Figlet.say("Copy Import")

		print("Looking for the translations in \(self.sourcePath)") // swiftlint:disable:this disable_print

		guard let stringsContent = try? String(contentsOfFile: sourcePath, encoding: .utf8) else {
			fatalError("Could not open path: \(sourcePath)")
		}

		var entries = parseStringsFile(stringsContent)
		if let dictPath = stringsdictPath {
			entries += parseStringsdictFile(atPath: dictPath)
		}
		entries = String(entries.dropLast()) // remove final trailing comma

		var output = "{\n  \"sourceLanguage\" : \"nl\","
		output += "\n  \"strings\" : {"
		output += entries
		output += "\n  },"
		output += "\n  \"version\" : \"1.0\"\n}"

		try output.write(toFile: self.targetPath, atomically: true, encoding: .utf8)

		print("done") // swiftlint:disable:this disable_print
	}

	/// Converts each `"key" = "value";` line into an xcstrings `stringUnit` entry.
	private func parseStringsFile(_ input: String) -> String {
		
		var output = ""
		input.enumerateLines { line, _ in
			if let lineOutput = parseLine(line) {
				output += lineOutput
			}
		}
		return output
	}

	/// Parses a single `.strings` line into a comma-terminated xcstrings JSON entry, or `nil` for comments/blanks.
	private func parseLine(_ input: String) -> String? {
		
		let elements = input.components(separatedBy: " = ")
		guard elements.count == 2,
			  let key = elements.first,
			  let value = elements.last else {
			return nil
		}
		var output = ""
		output += "\n    \(key) : {"
		output += "\n      \"extractionState\" : \"manual\","
		output += "\n      \"localizations\" : {"
		output += "\n        \"nl\" : {"
		output += "\n          \"stringUnit\" : {"
		output += "\n            \"state\" : \"translated\","
		output += "\n            \"value\" : \(parseValue(value))"
		output += "\n          }"
		output += "\n        }"
		output += "\n      }"
		output += "\n    },"
		return output
	}

	/// Strips the trailing `;`, then converts HTML inline tags to their Markdown equivalents.
	private func parseValue(_ input: String) -> String {
		
		var value = String(input.dropLast()) // remove trailing ;
		value = value.replacingOccurrences(of: "<b>", with: "**")
		value = value.replacingOccurrences(of: "</b>", with: "**")
		value = value.replacingOccurrences(of: "<strong>", with: "**")
		value = value.replacingOccurrences(of: "</strong>", with: "**")
		value = value.replacingOccurrences(of: "<i>", with: "*")
		value = value.replacingOccurrences(of: "</i>", with: "*")
		value = value.replacingOccurrences(of: "<em>", with: "*")
		value = value.replacingOccurrences(of: "</em>", with: "*")
		value = value.replacingOccurrences(of: "<a href=\\\"%1$@\\\">", with: "[%@](")
		value = value.replacingOccurrences(of: "</a>", with: ")")
		return value
	}

	/// Parses a `.stringsdict` plist file and returns comma-terminated xcstrings plural entries.
	///
	/// Keys are emitted in sorted order so the output is deterministic.
	/// Entries that contain no recognised plural rule type are skipped silently.
	private func parseStringsdictFile(atPath path: String) -> String {
		
		guard
			let data = FileManager.default.contents(atPath: path),
			let plist = try? PropertyListSerialization.propertyList(
				from: data,
				options: [],
				format: nil
			),
			let dict = plist as? [String: Any]
		else {
			fatalError("Could not open or parse stringsdict at: \(path)")
		}
		var output = ""
		for key in dict.keys.sorted() {
			guard let entryDict = dict[key] as? [String: Any] else { continue }
			if let entry = parsePluralEntry(key: key, dict: entryDict) {
				output += entry
			}
		}
		return output
	}

	/// Converts one stringsdict entry dict into a comma-terminated xcstrings `variations.plural` entry.
	///
	/// Looks for the first nested dict whose `NSStringFormatSpecTypeKey` is `NSStringPluralRuleType`
	/// and emits whichever of `zero / one / two / few / many / other` are present.
	/// Returns `nil` if no plural rule dict is found or no plural rules are present.
	private func parsePluralEntry(key: String, dict: [String: Any]) -> String? {
		
		let pluralRuleKeys = ["zero", "one", "two", "few", "many", "other"]
		guard let variableDict = dict.values
			.compactMap({ $0 as? [String: Any] })
			.first(where: { ($0["NSStringFormatSpecTypeKey"] as? String) == "NSStringPluralRuleType" })
		else { return nil }

		let rules = pluralRuleKeys.compactMap { ruleKey -> (String, String)? in
			guard var value = variableDict[ruleKey] as? String else { return nil }
			// Stringsdict uses positional %n$@ for the count; xcstrings requires plain %d
			for number in 1...9 {
				value = value.replacingOccurrences(of: "%\(number)$@", with: "%d")
			}
			return (ruleKey, value)
		}
		guard !rules.isEmpty else { return nil }

		// xcstrings plural lookup via String(localized: "key \(n)") derives the key "key %lld"
		// (Int interpolation in String.LocalizationValue uses %lld as the format specifier),
		// so the xcstrings key must carry the suffix for the runtime to match it.
		var output = ""
		output += "\n    \"\(key) %lld\" : {"
		output += "\n      \"extractionState\" : \"manual\","
		output += "\n      \"localizations\" : {"
		output += "\n        \"nl\" : {"
		output += "\n          \"variations\" : {"
		output += "\n            \"plural\" : {"
		for (ruleKey, value) in rules {
			output += "\n              \"\(ruleKey)\" : {"
			output += "\n                \"stringUnit\" : {"
			output += "\n                  \"state\" : \"translated\","
			output += "\n                  \"value\" : \"\(value)\""
			output += "\n                }"
			output += "\n              },"
		}
		output = String(output.dropLast()) // remove trailing comma after last rule
		output += "\n            }"
		output += "\n          }"
		output += "\n        }"
		output += "\n      }"
		output += "\n    },"
		return output
	}
}
