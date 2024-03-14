/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import WultraPassphraseMeter

/// Protocol for Access Code Strenght Validation
protocol AccessCodeStrengthValidation {
	
	/// Is this code a strong enough  code
	/// - Parameter code: the code to be checked
	/// - Returns: true if the code is strong enough
	func validate(_ code: String) -> Bool
}

class AccessCodeStrengthMeter: AccessCodeStrengthValidation {
	
	/// Is this code a strong enough  code
	/// - Parameter code: the code to be checked
	/// - Returns: true if the code is strong enough
	func validate(_ code: String) -> Bool {
		
		let result = PasswordTester.shared.testPin(code)
		
		return !(result.issues.contains(.frequentlyUsed) || result.issues.contains(.repeatingCharacters) || result.issues.contains(.notUnique) || result.issues.contains(.patternFound))
	}
}
