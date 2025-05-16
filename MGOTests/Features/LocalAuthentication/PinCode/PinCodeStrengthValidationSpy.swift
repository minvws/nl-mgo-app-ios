/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGO

public class PinCodeStrengthValidationSpy: PinCodeStrengthValidation {

	public var invokedValidate = false
	public var invokedValidateCount = 0
	public var invokedValidateParameters: (code: String, Void)?
	public var invokedValidateParametersList = [(code: String, Void)]()
	public var stubbedValidateResult: Bool! = false

	public func validate(_ code: String) -> Bool {
		invokedValidate = true
		invokedValidateCount += 1
		invokedValidateParameters = (code, ())
		invokedValidateParametersList.append((code, ()))
		return stubbedValidateResult
	}
}
