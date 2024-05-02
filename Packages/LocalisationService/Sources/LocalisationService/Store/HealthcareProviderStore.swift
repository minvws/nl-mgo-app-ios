/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Logging

public protocol HealthcareProviderStoreProtocol {
	
	var providers: [HealthcareProvider] { get }
	
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

public class HealthcareProviderStore: HealthcareProviderStoreProtocol {
	
	/// The storage provider
	private let storage = FileStorage()
	
	/// The name of the file where we store the healthcare providers
	private let fileName = "healthcareproviders.json"
	
	private let queue = DispatchQueue(label: "com.HealthcareProviderStore.serialqueue.\(UUID().uuidString)")
	
	public var providers: [HealthcareProvider]
	
	public init() {
		self.providers = []
		do {
			try self.providers = read()
		} catch {
			logError("HealthcareProviderStore - error initializing ", error)
			self.providers = []
		}
	}
	
	/// Add a healthcare provider to the storage
	/// - Parameter provider: the healthcare provider to store
	public func store(_ provider: HealthcareProvider) throws {
		
		guard !providers.contains(provider) else {
			// Can't add twice
			return
		}

		providers.append(provider)
		try persistToDisk()
	}
	
	/// Get a list of all the stored healthcare providers
	/// - Returns: array of healthcare providers
	public func read() throws -> [HealthcareProvider] {
		
		if let jsonData = storage.read(fileName: fileName) {
			let data = try JSONDecoder().decode([HealthcareProvider].self, from: jsonData)
			return data
		}
		return []
	}
	
	/// Delete a healthcare provider from storage
	/// - Parameter provider: the healthcare provider to be removed
	public func remove(_ provider: HealthcareProvider) throws {
		
		providers = providers.filter { $0 != provider }
		try persistToDisk()
	}
	
	/// Remove all the healthcare providers
	public func wipe() {
		
		storage.remove(fileName)
	}
	
	/// Store a list of providers
	private func persistToDisk() throws {
		
		try queue.sync {
			let encoded = try JSONEncoder().encode(providers)
			try storage.store(encoded, as: fileName)
		}
	}
}
