/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGO
import MGOTest

final class PinCodeStrengthMeterTests: XCTestCase {

	var sut: PinCodeStrengthMeter!
	
	override func setUp() {
		sut = PinCodeStrengthMeter()
	}
	
	func test_frequentlyUsed() {
		
		let codes = [
			"12345", "54321", "13579", "12321", "90210", "38317", "09876", "98765", "01234", "42069",
			"00012", "00098", "11123", "21012", "31415", "32123", "36963", "43210", "80087", "99987"
		]
		
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
		let codes = ["00001", "88885", "00500", "05500", "50505", "50005"]
		
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
	
	func test_notNumeric() {
		
		// Given
		let codes = ["0123A", "WRONG", "0O0o0", "1l1l7"]
		
		for code in codes {
			// When
			let result = sut.validate(code)
			
			// Then
			expect(result) == false
		}
	}
}
