/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import RemoteConfiguration

final class StringSemanticVersionTests: XCTestCase {

	func test_semanticVersion_empty() {
		
		// Given
		let value = ""
		
		// When
		let result = value.semanticVersion()
		
		// Then
		expect(result) == "0.0.0"
	}
	
	func test_semanticVersion_singleDigit() {
		
		// Given
		let value = "1"
		
		// When
		let result = value.semanticVersion()
		
		// Then
		expect(result) == "1.0.0"
	}
	
	func test_semanticVersion_twoDigits() {
		
		// Given
		let value = "2.1"
		
		// When
		let result = value.semanticVersion()
		
		// Then
		expect(result) == "2.1.0"
	}
	
	func test_semanticVersion_threeDigits() {
		
		// Given
		let value = "2.1.8"
		
		// When
		let result = value.semanticVersion()
		
		// Then
		expect(result) == "2.1.8"
	}
	
	func test_semanticVersion_fourDigits() {
		
		// Given
		let value = "2.1.8.A"
		
		// When
		let result = value.semanticVersion()
		
		// Then
		expect(result) == "2.1.8.A"
	}
	
	func test_semanticVersion_noDigits() {
		
		// Given
		let value = "🦠"
		
		// When
		let result = value.semanticVersion()
		
		// Then
		expect(result) == "🦠.0.0"
	}
}
