/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import Sanitizer

final class SanitizerTests: XCTestCase {
	
	func test_sanitize_htmlInInput_shouldHaveHtmlRemoved() {
		
		// Given
		let input = "Hello <b>World</b>\n\n"
		
		// When
		let sanitizedInput = Sanitizer.sanitize(input)
		
		// Then
		expect(sanitizedInput) == "Hello World"
	}
	
	func test_sanitize_invalidInput_resultIsEmptyString() {
		
		// Given
		let input = "\n\n"
		
		// When
		let sanitizedInput = Sanitizer.sanitize(input)
		
		// Then
		expect(sanitizedInput) == ""
	}
}
