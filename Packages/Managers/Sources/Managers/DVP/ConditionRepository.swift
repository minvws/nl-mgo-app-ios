/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public protocol ConditionRepository {
	
	/// Fetch all the medication statements
	/// - Returns: an array of medication statements
	func fetchConditions() async throws -> [Condition]
}

extension FHIRClient: ConditionRepository {
	
	/// Fetch all the conditions
	/// - Returns: an array of conditions
	public func fetchConditions() async throws -> [ModelsSTU3.Condition] {
		
		let bundle = try await Condition.read("", client: self, parameters: DVPClient.BGZ.concern) as? ModelsSTU3.Bundle
		let statements: [Condition]? = bundle?.entry?.compactMap {
			$0.resource?.get(if: ModelsSTU3.Condition.self)
		}
		return statements ?? []
	}
}
