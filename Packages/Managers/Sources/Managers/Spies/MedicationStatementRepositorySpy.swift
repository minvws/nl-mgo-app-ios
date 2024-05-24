/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public class MedicationStatementRepositorySpy: MedicationStatementRepository {

	/// Initlializer
	public init() {
		// Public initializer needed for public access.
	}
	
	public var invokedFetchMedicationStatements = false
	public var invokedFetchMedicationStatementsCount = 0
	public var stubbedFetchMedicationStatements: [MedicationStatement] = []
	public var stubbedError: Error?

	public func fetchMedicationStatements() async throws -> [MedicationStatement] {
		invokedFetchMedicationStatements = true
		invokedFetchMedicationStatementsCount += 1
		if let error = stubbedError {
			throw error
		}
		return stubbedFetchMedicationStatements
	}
}
