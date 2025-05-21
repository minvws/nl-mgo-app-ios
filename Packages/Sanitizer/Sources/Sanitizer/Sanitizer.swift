/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import SwiftSoup

final public class Sanitizer {
	
	static public func strip(_ input: String?) -> String? {
		
		guard let input else { return nil }
		guard let doc: Document = try? SwiftSoup.parse(input) else { return nil } // parse html
		guard let sanitizedText = try? doc.text() else { return nil }
		return sanitizedText.trimmingCharacters(in: .whitespacesAndNewlines)
	}
	
	static public func sanitize(_ input: String) -> String {
		return strip(input) ?? ""
	}
}
