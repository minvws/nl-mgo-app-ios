/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Logging

public protocol HealthcareOrganizationRepositoryProtocol {
	
	/// The list of stored healthcare provider
	var organizations: [HealthcareOrganization] { get }
	
	/// Observatory for changes
	var observatory: Observatory<Bool> { get }
	
	/// Observatory for removals
	var removalObservatory: Observatory<HealthcareOrganization> { get }
	
	/// Add a healthcare provider to the storage
	/// - Parameter provider: the healthcare provider to store
	func store(_ provider: HealthcareOrganization) throws
	
	/// Delete a healthcare provider from storage
	/// - Parameter provider: the healthcare provider to be removed
	func remove(_ provider: HealthcareOrganization) throws
	
	/// Remove all the healthcare providers
	func wipePersistedData()
}

public class HealthcareOrganizationRepository: HealthcareOrganizationRepositoryProtocol {
	
	/// The storage provider
	private let storage: FileStorageProtocol
	
	/// The name of the file where we store the healthcare providers
	private let fileName = "healthcareproviders.json"
	
	/// The name of file in which we store the providers
	private let name: String = {
		
		if NSClassFromString("XCTestCase") == nil {
			return "healthcareproviders.json"
		} else {
			return "healthcareproviders_test.json"
		}
	}()
	
	/// Dispatch Queue
	private let queue = DispatchQueue(label: "com.HealthcareProviderStore.serialqueue.\(UUID().uuidString)")
	
	/// Observatory for changes
	public let observatory: Observatory<Bool>
	
	/// Observers for changes
	private let observers: (Bool) -> Void
	
	/// Observatory for removal
	public let removalObservatory: Observatory<HealthcareOrganization>
	
	/// Observers for removal
	private let removalObservers: (HealthcareOrganization) -> Void
	
	/// The list of stored healthcare provider
	public var organizations: [HealthcareOrganization]
	
	/// Initializer
	/// - Parameter storage: storage protocol
	public init(storage: FileStorageProtocol = FileStorage()) {
		
		self.storage = storage
		(self.observatory, self.observers) = Observatory<Bool>.create()
		(self.removalObservatory, self.removalObservers) = Observatory<HealthcareOrganization>.create()
		
		self.organizations = []
		do {
			try self.organizations = read()
		} catch {
			logError("HealthcareProviderStore - error initializing ", error)
			self.organizations = []
		}
	}
	
	/// Add a healthcare provider to the storage
	/// - Parameter provider: the healthcare provider to store
	public func store(_ provider: HealthcareOrganization) throws {
		
		guard !organizations.contains(provider) else {
			// Can't add twice
			return
		}

		organizations.append(provider)
		observers(true)
		try persistToStorage()
	}
	
	/// Get a list of all the stored healthcare providers
	/// - Returns: array of healthcare providers
	internal func read() throws -> [HealthcareOrganization] {
		
		if let jsonData = storage.read(fileName: fileName) {
			let data = try JSONDecoder().decode([HealthcareOrganization].self, from: jsonData)
			return data
		}
		return []
	}
	
	/// Delete a healthcare provider from storage
	/// - Parameter provider: the healthcare provider to be removed
	public func remove(_ provider: HealthcareOrganization) throws {
	
		logInfo("About to delete \(provider.display_name)")
		organizations = organizations.filter { $0 != provider }
		observers(true)
		#warning("Removal notification disabled.")
//		removalObservers(provider)
		try persistToStorage()
	}
	
	/// Remove all the healthcare providers
	public func wipePersistedData() {
		
		organizations = []
		storage.remove(fileName)
		observatory.removeAll()
		removalObservatory.removeAll()
	}
	
	/// Store a list of providers
	private func persistToStorage() throws {
		
		try queue.sync {
			let encoded = try JSONEncoder().encode(organizations)
			try storage.store(encoded, as: fileName)
		}
	}
}
