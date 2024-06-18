/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public protocol ConcernRepository {
	
	/// Fetch all the concerns
	/// - Returns: an array of concerns
	func fetchConcerns(dvaTarget: String?) async throws -> [MgoConcern]
}

extension FHIRClient: ConcernRepository {
	
	/// Fetch all the conditions
	/// - Returns: an array of conditions
	public func fetchConcerns(dvaTarget: String?) async throws -> [MgoConcern] {
		
		let bundle = try await Condition.read(nil, client: self, parameters: DVP.BGZ.concern, dvaTarget: dvaTarget) as? ModelsSTU3.Bundle
		let conditions: [Condition] = bundle?.entry?.compactMap {
			$0.resource?.get(if: ModelsSTU3.Condition.self)
		} ?? []
		
		let concerns: [MgoConcern] = conditions.compactMap {
			ConcernDecorator.create($0)
		}
		return concerns
	}
}
