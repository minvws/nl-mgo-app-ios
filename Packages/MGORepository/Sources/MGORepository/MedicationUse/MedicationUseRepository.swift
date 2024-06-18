/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public protocol MedicationUseRepository {
	
	/// Fetch all the medication usage
	/// - Returns: an array of medication use
	func fetchMedicationUse(dvaTarget: String?) async throws -> [MgoMedicationUse]
}

extension FHIRClient: MedicationUseRepository {
	
	/// Fetch all the medication usage
	/// - Returns: an array of medication use
	public func fetchMedicationUse(dvaTarget: String?) async throws -> [MgoMedicationUse] {
		
		let bundle = try await MedicationStatement.read("", client: self, parameters: DVP.BGZ.medicationUse, dvaTarget: dvaTarget) as? ModelsSTU3.Bundle
		let statements: [MedicationStatement] = bundle?.entry?.compactMap {
			$0.resource?.get(if: ModelsSTU3.MedicationStatement.self)
		} ?? []
		let medicationUsage: [MgoMedicationUse] = statements.compactMap {
			MedicationUseDecorator.create($0)
		}
		return medicationUsage
	}
}
