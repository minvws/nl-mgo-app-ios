/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

/// Protocol for Access Code Strength Validation
protocol PinCodeStrengthValidation {
	
	/// Is this code a strong enough  code
	/// - Parameter code: the code to be checked
	/// - Returns: true if the code is strong enough
	func validate(_ code: String) -> Bool
}

class PinCodeStrengthMeter: PinCodeStrengthValidation {
	
	/// Is this code a strong enough  code
	/// - Parameter code: the code to be checked
	/// - Returns: true if the code is strong enough
	func validate(_ code: String) -> Bool {
		
		return isNumeric(code) && !isFrequentlyUsed(code) && isUnique(code)
	}
	
	/// Is this code frequently used?
	/// - Parameter code: the code to check
	/// - Returns: true if the code is not in the frequently used lst.
	private func isFrequentlyUsed(_ code: String) -> Bool {
		
		let frequentlyUsed = [
			"12345", "54321", "13579", "12321", "90210", "38317", "09876", "98765", "01234", "42069",
			"00012", "00098", "11123", "21012", "31415", "32123", "36963", "43210", "80087", "99987"
		]
		
		return frequentlyUsed.contains(code)
	}
	
	/// Is this code unique enough?
	/// A code is considered unique enough if there are 3 or more different characters (for a code length of 5)
	/// - Parameter code: the code to check
	/// - Returns: true if there are 3 or more unique characters in this code
	private func isUnique(_ code: String) -> Bool {
		
		var uniqueChars: [String] = []
		for element in code where !uniqueChars.contains(String(element)) {
			uniqueChars.append(String(element))
		}
		return uniqueChars.count >= 3
	}
	
	/// Is this a numeric String
	/// - Parameter code: the code to check
	/// - Returns: true if all characters are numbers
	private func isNumeric(_ code: String) -> Bool {
		
		let digitsCharacters = CharacterSet(charactersIn: "0123456789")
		return CharacterSet(charactersIn: code).isSubset(of: digitsCharacters)
	}
}
