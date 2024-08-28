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

public protocol MedicationUseRepository {
	
	/// Fetch all the medication usage
	/// - Returns: an array of medication use
	func fetchMedicationUse(dvaTarget: String) async throws -> [ZibSchema]
}

extension FHIRClient: MedicationUseRepository {
	
	/// Fetch all the medication usage
	/// - Returns: an array of medication use
	public func fetchMedicationUse(dvaTarget: String) async throws -> [ZibSchema] {
		
		let parser = FHIRParser()
		let data = try await MGORepository(client: self).getBundleData(endpoint: DVP.CommonClinicalDataset.medicationUse, dvaTarget: dvaTarget)
		let resources = parser.getBundleResourcesJson(data)
		
		var result = [ZibSchema]()
	
		for element in resources {
			let resource = try JSONSerialization.data(withJSONObject: element)
			if let zib = parser.getMgoResourceJson(resource) {
				if let zibMedicationUse = ZibFactory.createZibMedicationUse(zib) {
					let schema = parser.getUiSchemaJson(zib)
					result.append(ZibSchema(zib: zibMedicationUse, schema: schema))
				}
				if let zibProduct = ZibFactory.createZibProduct(zib) {
					let schema = parser.getUiSchemaJson(zib)
					result.append(ZibSchema(zib: zibProduct, schema: schema))
				}
			}
		}
		return result
	}
}

public typealias ZibSchema = (zib: Zib, schema: UISchema?)
