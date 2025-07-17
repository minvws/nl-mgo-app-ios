/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
@testable import Sanitizer
import Testing

@MainActor
struct SanitizerTests {
	
	@Test
	func sanitize_htmlInput_shouldHaveHtmlRemoved() {
		
		// Given
		let input = "Hello <b>World</b>\n\n"
		
		// When
		let sanitizedInput = Sanitizer.sanitize(input)
		
		// Then
		#expect(sanitizedInput == "Hello World")
	}
	
	@Test
	func sanitize_invalidInput_shouldReturnEmptyString() {
		
		// Given
		let input = "\n\n"
		
		// When
		let sanitizedInput = Sanitizer.sanitize(input)
		
		// Then
		#expect(sanitizedInput == "")
	}
	
	@Test
	func strip_nilInput_shouldReturnNil() {
		
		// Given
		
		// When
		let sanitizedInput = Sanitizer.strip(nil)
		
		// Then
		#expect(sanitizedInput == nil)
	}
}
