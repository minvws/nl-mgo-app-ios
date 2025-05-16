/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
@testable import MGO

class BinaryRepositorySpy: BinaryRepositoryProtocol {

	var invokedStore = false
	var invokedStoreCount = 0
	var invokedStoreParameters: (binary: FHIRBinary, filename: String)?
	var invokedStoreParametersList = [(binary: FHIRBinary, filename: String)]()
	var stubbedStoreError: Error?
	var stubbedStoreResult: URL!

	func store(_ binary: FHIRBinary, as filename: String) throws -> URL {
		invokedStore = true
		invokedStoreCount += 1
		invokedStoreParameters = (binary, filename)
		invokedStoreParametersList.append((binary, filename))
		if let error = stubbedStoreError {
			throw error
		}
		return stubbedStoreResult
	}

	var invokedClear = false
	var invokedClearCount = 0

	func clear() {
		invokedClear = true
		invokedClearCount += 1
	}
}
