/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

public class PatientFriendlyTermsRepositorySpy: PatientFriendlyTermsRepositoryProtocol {

	public var invokedFetchTerms = false
	public var invokedFetchTermsCount = 0

	public func fetchTerms() async {
		invokedFetchTerms = true
		invokedFetchTermsCount += 1
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
