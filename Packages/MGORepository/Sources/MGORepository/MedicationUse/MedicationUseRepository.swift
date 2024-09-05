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
import Logging

public protocol MedicationUseRepository {
	
	/// Fetch all the medication usage
	/// - Returns: an array of medication use
	func fetchResources(dvaTarget: String) async throws -> [MgoResource]
}

extension FHIRClient: MedicationUseRepository {
	
	/// Fetch all the medication usage
	/// - Returns: an array of Mgo Resources for MedicationUse
	public func fetchResources(dvaTarget: String) async throws -> [MgoResource] {
		
		// The repository
		let repository = MGORepository(client: self)
		
		// Get the FHIR Bundle
		let data = try await repository.getBundleData(endpoint: DVP.CommonClinicalDataset.medicationUse, dvaTarget: dvaTarget)
		
		// Transform the FHIR bundle into MgoResources
		let mgoResources = try repository.process(data)
		
		return mgoResources.filter { resource in
			
			resource.hasProfile(ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse.rawValue) ||
			resource.hasProfile(ZibProductProfile.httpNictizNlFhirStructureDefinitionZibProduct.rawValue)
		}
	}
}
