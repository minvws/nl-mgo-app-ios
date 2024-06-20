/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public protocol LaboratoryTestResultRepository {
	
	/// Fetch all the lab results
	/// - Returns: an array of lab results
	func fetchResults(dvaTarget: String?) async throws -> [MgoLaboratoryTestResult]
}

extension FHIRClient: LaboratoryTestResultRepository {
	
	/// Fetch all the lab results
	/// - Returns: an array of lab results
	public func fetchResults(dvaTarget: String?) async throws -> [MgoLaboratoryTestResult] {
		
		guard let bundle = try await Observation.read("$lastn", client: self, parameters: DVP.CommonClinicalDataset.laboratoryTestResult, dvaTarget: dvaTarget) as? ModelsSTU3.Bundle else { return [] }
		let observations: [Observation] = bundle.entry?.compactMap {
			$0.resource?.get(if: ModelsSTU3.Observation.self)
		} ?? []
		
		let results: [MgoLaboratoryTestResult] = observations.compactMap {
			LaboratoryTestResultDecorator.create($0, bundle: bundle)
		}
		return results
	}
}
