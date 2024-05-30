/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public class ConditionRepositorySpy: ConditionRepository {
	
	/// Initlializer
	public init() {
		// Public initializer needed for public access.
	}
	
	public var invokedFetchConditions = false
	public var invokedFetchConditionsCount = 0
	public var stubbedFetchCondition: [Condition] = []
	public var stubbedError: Error?

	public func fetchConditions() async throws -> [Condition] {
		invokedFetchConditions = true
		invokedFetchConditionsCount += 1
		if let error = stubbedError {
			throw error
		}
		return stubbedFetchCondition
	}
}
