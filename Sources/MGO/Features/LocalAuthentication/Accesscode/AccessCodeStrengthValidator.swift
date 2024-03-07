/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

protocol StrengthValidation {
	
	func validate(_ code: String) -> Bool
}

class StrengthValidator: StrengthValidation {
	
	private var invalid: [String] = [
		"00000"
	]
	
	func validate(_ code: String) -> Bool {
		return !invalid.contains(code)
	}
}
