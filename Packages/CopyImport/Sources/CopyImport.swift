/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Figlet
import ArgumentParser

@main
struct CopyImport: ParsableCommand {
	
	@Option(help: "The source path to the translation file")
	public var sourcePath: String

	@Option(help: "The target path to the translation file")
	public var targetPath: String
	
	/// Run this script
	public func run() throws {
		
		Figlet.say("Copy Import")
		
		print("Looking for the translations in \(self.sourcePath)") // swiftlint:disable:this disable_print
		
		let output = parseFile(readFile())
		
		try output.write(toFile: self.targetPath, atomically: true, encoding: .utf8)
		
		print("done") // swiftlint:disable:this disable_print
	}
	
	/// Read the content of the source path file
	/// - Returns: content
	private func readFile() -> String {
		
		guard let contents = try? String(contentsOfFile: sourcePath, encoding: .utf8) else {
			fatalError("Could not open path: \(sourcePath)")
		}
		
		return contents
	}
	
	/// Parse the file into json
	/// - Parameter input: the file content
	/// - Returns: json (as string)
	private func parseFile(_ input: String) -> String {
		
		var output: String = ""
		output += "{\n  \"sourceLanguage\" : \"nl\","
		output += "\n  \"strings\" : {"
		
		input.enumerateLines { line, _ in
			
			if let lineOutput = parseLine(line) {
				output += lineOutput
			}
		}
		output = String(output.dropLast()) // Remove last trailing comma
		output += "\n  },"
		output += "\n  \"version\" : \"1.0\"\n}"
		return output
	}
	
	/// Parse a strings file line into json
	/// - Parameter input: the line from the strings file
	/// - Returns: json (as string)
	private func parseLine(_ input: String) -> String? {
		
		let elements = input.components(separatedBy: " = ")
		if elements.count == 2, let key = elements.first, let value = elements.last {
			var output: String = ""
			
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
		} else {
			return nil
		}
	}
	
	/// Parse a value from the strings file (replace html with markdown)
	/// - Parameter input: the value
	/// - Returns: cleanup value
	private func parseValue(_ input: String) -> String {
	
		var value = String(input.dropLast()) // remote trailing ;
		
		// Replace Bold tags
		value = value.replacingOccurrences(of: "<b>", with: "**")
		value = value.replacingOccurrences(of: "</b>", with: "**")
		value = value.replacingOccurrences(of: "<strong>", with: "**")
		value = value.replacingOccurrences(of: "</strong>", with: "**")
		
		// Replace Italic tags
		value = value.replacingOccurrences(of: "<i>", with: "*")
		value = value.replacingOccurrences(of: "</i>", with: "*")
		value = value.replacingOccurrences(of: "<em>", with: "*")
		value = value.replacingOccurrences(of: "</em>", with: "*")
		
		// Replace href
		value = value.replacingOccurrences(of: "<a href=\\\"%1$@\\\">", with: "[%@](")
		value = value.replacingOccurrences(of: "</a>", with: ")")
		
		return value
	}
}
