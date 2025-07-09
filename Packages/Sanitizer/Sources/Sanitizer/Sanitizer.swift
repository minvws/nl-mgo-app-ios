/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import SwiftSoup

/// A class to sanitize input from the user
@MainActor
final public class Sanitizer {
	
	/// Strip any unwanted html from the input
	/// - Parameter input: the user input
	/// - Returns: sanitized optional string
	static public func strip(_ input: String?) -> String? {
		
		guard let input else { return nil }
		guard let doc: Document = try? SwiftSoup.parse(input) else { return nil } // parse html
		guard let sanitizedText = try? doc.text() else { return nil }
		return sanitizedText.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	/// Strip any unwanted html from the input
	/// - Parameter input: the user input
	/// - Returns: sanitized string, defaults to an empty string
	static public func sanitize(_ input: String) -> String {
		return strip(input) ?? ""
	}
}
