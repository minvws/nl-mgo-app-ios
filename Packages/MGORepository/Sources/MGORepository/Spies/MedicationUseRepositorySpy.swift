/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient
import FHIRParser
import Zibs

public class MedicationUseRepositorySpy: MedicationUseRepository {
	
	public init() {
		// Public init for public access
	}

	public var invokedFetchMedicationUse = false
	public var invokedFetchMedicationUseCount = 0
	public var stubbedFetchMedicationUse: [ZibSchema] = []
	public var stubbedError: Error?

	public func fetchMedicationUse(dvaTarget: String) async throws -> [ZibSchema] {
		invokedFetchMedicationUse = true
		invokedFetchMedicationUseCount += 1
		if let error = stubbedError {
			throw error
		}
		return stubbedFetchMedicationUse
	}
}
