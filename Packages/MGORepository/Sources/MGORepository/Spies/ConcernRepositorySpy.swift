/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public class ConcernRepositorySpy: ConcernRepository {
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }

	public var invokedFetchConcerns = false
	public var invokedFetchConcernsCount = 0
	public var stubbedFetchConcerns: [MgoConcern] = []
	public var stubbedError: Error?
	
	public func fetchConcerns(dvaTarget: String) async throws -> [MgoConcern] {
		invokedFetchConcerns = true
		invokedFetchConcernsCount += 1
		if let error = stubbedError {
			throw error
		}
		return stubbedFetchConcerns
	}
}
