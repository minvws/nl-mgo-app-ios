/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

/// Protocol for Access Code Strenght Validation
protocol StrengthValidation {
	
	/// Is this code a strong enough  code
	/// - Parameter code: the code to be checked
	/// - Returns: true if the code is strong enough
	func validate(_ code: String) -> Bool
}

class StrengthValidator: StrengthValidation {
	
	/// A very small list of invalid codes.
	#warning("This will be improved in MGO-222 password strength")
	private var invalid: [String] = [
		"00000"
	]
	
	/// Is this code a strong enough  code
	/// - Parameter code: the code to be checked
	/// - Returns: true if the code is strong enough
	func validate(_ code: String) -> Bool {
		return !invalid.contains(code)
	}
}
