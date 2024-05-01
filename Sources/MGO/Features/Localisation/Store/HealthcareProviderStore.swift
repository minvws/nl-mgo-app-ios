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
	func read() async throws -> [HealthcareProvider]
	
	/// Delete a healthcare provider from storage
	/// - Parameter provider: the healthcare provider to be removed
	func remove(_ provider: HealthcareProvider) throws
	
	/// Remove all the healthcare providers
	func wipe()
}

class HealthcareProviderStore: HealthcareProviderStoreProtocol {
	
	private let queue = DispatchQueue(label: "com.healthcareProviderStore.serialqueue.\(UUID().uuidString)")
	
	private let storage = FileStorage()
	
	private let fileName = "healthcareproviders.json"
	
	/// Add a healthcare provider to the storage
	/// - Parameter provider: the healthcare provider to store
	func store(_ provider: HealthcareProvider) throws {
		
		try queue.sync {
			
			var list = [HealthcareProvider]()
			
			if let jsonData = storage.read(fileName: fileName) {
				let data = try JSONDecoder().decode([HealthcareProvider].self, from: jsonData)
				list = data
			}
			list.append(provider)
			let encoded = try JSONEncoder().encode(list)
			try storage.store(encoded, as: fileName)
		}
	}
	
	/// Get a list of all the stored healthcare providers
	/// - Returns: array of healthcare providers
	func read() async throws -> [HealthcareProvider] {
		
		if let jsonData = storage.read(fileName: fileName) {
			let data = try JSONDecoder().decode([HealthcareProvider].self, from: jsonData)
			return data
		}
		return []
	}
	
	/// Delete a healthcare provider from storage
	/// - Parameter provider: the healthcare provider to be removed
	func remove(_ provider: HealthcareProvider) throws {
		
		var list = [HealthcareProvider]()
		
		if let jsonData = storage.read(fileName: fileName) {
			let data = try JSONDecoder().decode([HealthcareProvider].self, from: jsonData)
			list = data
		}
		list = list.filter { $0 != provider }
		let encoded = try JSONEncoder().encode(list)
		try storage.store(encoded, as: fileName)
	}
	
	/// Remove all the healthcare providers
	func wipe() {
		storage.remove(fileName)
	}
}
