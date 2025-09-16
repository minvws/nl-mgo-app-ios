/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

public class PatientFriendlyTermsRepositorySpy: PatientFriendlyTermsRepositoryProtocol {

	public var invokedFetchTerms = false
	public var invokedFetchTermsCount = 0

	public func fetchTerms() {
		invokedFetchTerms = true
		invokedFetchTermsCount += 1
	}

	public var invokedFind = false
	public var invokedFindCount = 0
	public var invokedFindParameters: (code: String, Void)?
	public var invokedFindParametersList = [(code: String, Void)]()
	public var stubbedFindResult: PatientFriendlyTerm!

	public func find(_ code: String) -> PatientFriendlyTerm? {
		invokedFind = true
		invokedFindCount += 1
		invokedFindParameters = (code, ())
		invokedFindParametersList.append((code, ()))
		return stubbedFindResult
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
