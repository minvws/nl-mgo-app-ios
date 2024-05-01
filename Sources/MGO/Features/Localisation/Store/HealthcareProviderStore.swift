/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import LocalisationServiceClient

protocol HealthcareProviderStoreProtocol {
	
	/// Add a healthcare provider to the storage
	/// - Parameter provider: the healthcare provider to store
	func store(_ provider: HealthcareProvider) throws
	
	/// Get a list of all the stored healthcare providers
	/// - Returns: array of healthcare providers
	func read() throws -> [HealthcareProvider]
	
	/// Delete a healthcare provider from storage
	/// - Parameter provider: the healthcare provider to be removed
	func remove(_ provider: HealthcareProvider) throws
	
	/// Remove all the healthcare providers
	func wipe()
}

class HealthcareProviderStore: HealthcareProviderStoreProtocol {
	
	/// The storage provider
	private let storage = FileStorage()
	
	/// The name of the file where we store the healthcare providers
	private let fileName = "healthcareproviders.json"
	
	/// Add a healthcare provider to the storage
	/// - Parameter provider: the healthcare provider to store
	func store(_ provider: HealthcareProvider) throws {
		
		var list = try read()
		list.append(provider)
		try storeList(list)
	}
	
	/// Get a list of all the stored healthcare providers
	/// - Returns: array of healthcare providers
	func read() throws -> [HealthcareProvider] {
		
		if let jsonData = storage.read(fileName: fileName) {
			let data = try JSONDecoder().decode([HealthcareProvider].self, from: jsonData)
			return data
		}
		return []
	}
	
	/// Delete a healthcare provider from storage
	/// - Parameter provider: the healthcare provider to be removed
	func remove(_ provider: HealthcareProvider) throws {
		
		var list = try read()
		list = list.filter { $0 != provider }
		try storeList(list)
	}
	
	/// Remove all the healthcare providers
	func wipe() {
		
		storage.remove(fileName)
	}
	
	/// Store a list of providers
	/// - Parameter list: a list of healthcare providers
	private func storeList(_ list: [HealthcareProvider]) throws {
		
		let encoded = try JSONEncoder().encode(list)
		try storage.store(encoded, as: fileName)
	}
}
