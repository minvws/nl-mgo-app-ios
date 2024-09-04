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
	func fetchMedicationUse(dvaTarget: String) async throws -> [MgoResource]
	
	/// Get a data store record for medication
	/// - Parameters:
	///   - dataStore: the data store to use
	///   - organisationId: the id of the organization to fetch from
	///   - organizationName: the name of organization to fetch from
	///   - dvaTarget: the target for the API
	/// - Returns: data record.
	func fetchMedicationUse(dataStore: MgoDataStoreProtocol, organisationId: String, organizationName: String, dvaTarget: String) async throws -> MgoDataStoreRecord
}

extension FHIRClient: MedicationUseRepository {
	
	/// Get a data store record for medication
	/// - Parameters:
	///   - dataStore: the data store to use
	///   - organisationId: the id of the organization to fetch from
	///   - organizationName: the name of organization to fetch from
	///   - dvaTarget: the target for the API
	/// - Returns: data record.
	public func fetchMedicationUse(dataStore: MgoDataStoreProtocol, organisationId: String, organizationName: String, dvaTarget: String) async throws -> MgoDataStoreRecord {
		
		let cacheResult = dataStore.get(categoryId: "Medication", organizationId: organisationId)
		switch cacheResult {
			case .success(let success):
				logInfo("Cache hit")
				return success
				
			case .failure(let failure):
				logInfo("Cache miss: \(failure)")
				do {
					let mgoResources = try await fetchMedicationUse(dvaTarget: dvaTarget)
					let response = MgoDataStoreRecord(categoryId: "Medication", organizationId: organisationId, resources: mgoResources, name: organizationName)
					dataStore.store(data: response)
					logInfo("Cache store")
					return response
					
				} catch {
					throw error
				}
				throw failure
		}
	}
	
	/// Fetch all the medication usage
	/// - Returns: an array of medication use
	public func fetchMedicationUse(dvaTarget: String) async throws -> [MgoResource] {
		
		// The repository
		let repository = MGORepository(client: self)
		
		// Get the FHIR Bundle
		let data = try await repository.getBundleData(endpoint: DVP.CommonClinicalDataset.medicationUse, dvaTarget: dvaTarget)
		
		// Transfrom the FHIR bundle into MgoResources
		let mgoResources = try repository.process(data)
		
		return mgoResources.filter { resource in
			
			resource.hasProfile(ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse.rawValue) ||
			resource.hasProfile(ZibProductProfile.httpNictizNlFhirStructureDefinitionZibProduct.rawValue)
		}
	}
}

public typealias MgoResource = Data
