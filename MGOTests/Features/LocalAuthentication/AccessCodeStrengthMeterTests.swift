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
		
		let codes = [
			"12345", "11111", "55555", "00000", "54321", "13579", "77777",
			"22222", "12321", "99999", "33333", "00700", "90210", "88888",
			"38317", "09876", "44444", "98765", "01234", "42069"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == false
		}
	}

	func test_repeatingCharacters() {
		
		// Given
		let codes = ["00000", "11111", "22222", "33333", "44444", "55555", "66666", "77777", "88888", "99999"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == false
		}
	}
	
	func test_notUnique() {
		
		// Given
		let codes = ["00001", "88885", "00500"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == false
		}
	}

	func test_noIssues() {
		
		// Given
		let codes = ["48259", "81625", "45678", "00501"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == true
		}
	}
}
