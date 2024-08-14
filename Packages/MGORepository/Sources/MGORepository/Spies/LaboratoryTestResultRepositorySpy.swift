/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public class LaboratoryTestResultRepositorySpy: LaboratoryTestResultRepository {
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }

	public var invokedFetchResults = false
	public var invokedFetchResultsCount = 0
	public var stubbedFetchResults: [MgoLaboratoryTestResult] = []
	public var stubbedError: Error?
	
	public func fetchResults(dvaTarget: String) async throws -> [MgoLaboratoryTestResult] {
		invokedFetchResults = true
		invokedFetchResultsCount += 1
		if let error = stubbedError {
			throw error
		}
		return stubbedFetchResults
	}
}
