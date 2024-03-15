/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGO
import MGOTest

final class AccessCodeStrengthMeterTests: XCTestCase {

	var sut: AccessCodeStrengthMeter!
	
	override func setUp() {
		sut = AccessCodeStrengthMeter()
	}
	
	func test_frequentlyUsed() {
		
		let codes = ["00000", "12345", "98765", "45678"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == false
		}
	}

	func test_repeatingCharacters() {
		
		// Given
		let codes = ["00000", "88888", "99999"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == false
		}
	}
	
	func test_notUnique() {
		
		// Given
		let codes = ["00001", "88885"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == false
		}
	}
	
	func test_patternFound() {
		
		// Given
		let codes = ["12357", "96321", "45678"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == false
		}
	}

	func test_noIssues() {
		
		// Given
		let codes = ["48259", "81625"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == true
		}
	}
}
