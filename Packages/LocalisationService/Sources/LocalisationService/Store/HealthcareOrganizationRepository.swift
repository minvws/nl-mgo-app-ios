/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug
import Observatory
import FileStorage

public enum HealthcareOrganizationReason {
	case added
	case removed
	case changed
}

public protocol HealthcareOrganizationRepositoryProtocol {
	
	/// The list of stored healthcare organization
	var organizations: [MgoOrganization] { get }
	
	/// Observatory for changes
	var observatory: Observatory<(MgoOrganization?, HealthcareOrganizationReason)> { get }
	
	/// Add a healthcare organization to the storage
	/// - Parameter organization: the healthcare organization to store
	func store(_ organization: MgoOrganization) throws
	
	/// Delete a healthcare organization from storage
	/// - Parameter organization: the healthcare organization to be removed
	func remove(_ organization: MgoOrganization) throws
	
	/// set the list of organizations
	/// - Parameter newListOfOrganizations: the healthcare organizations to be stored
	func set(_ newListOfOrganizations: [MgoOrganization]) throws
	
	/// Remove all the healthcare organizations
	func wipePersistedData()
}

public class HealthcareOrganizationRepository: HealthcareOrganizationRepositoryProtocol {
	
	/// The storage provider
	private let storage: FileStorageProtocol
	
	/// The name of file in which we store the organizations
	private let fileName: String = {
		
		if NSClassFromString("XCTestCase") == nil {
			return "mgo_hco.json"
		} else {
			return "mgo_hco_test.json"
		}
	}()
	
	/// Dispatch Queue
	private let queue = DispatchQueue(label: "com.HealthcareOrganizationRepository.serialqueue.\(UUID().uuidString)")
	
	/// Observatory for changes
	public let observatory: Observatory<(MgoOrganization?, HealthcareOrganizationReason)>
	
	/// Observers for changes
	private let observers: ((MgoOrganization?, HealthcareOrganizationReason)) -> Void
	
	/// The list of stored healthcare organization
	public var organizations: [MgoOrganization]
	
	/// Initializer
	/// - Parameter storage: storage protocol
	public init(storage: FileStorageProtocol = FileStorage()) {
		
		self.storage = storage
		(self.observatory, self.observers) = Observatory<(MgoOrganization?, HealthcareOrganizationReason)>.create()
		
		self.organizations = []
		do {
			try self.organizations = read()
		} catch {
			logError("HealthcareOrganizationRepository - error initializing ", error)
			self.organizations = []
		}
	}
	
	/// Add a healthcare organization to the storage
	/// - Parameter organization: the healthcare organization to store
	public func store(_ organization: MgoOrganization) throws {
		
		guard !organizations.contains(organization) else {
			// Can't add twice
			return
		}

		organizations.append(organization)
		observers((organization, .added))
		try persistToStorage()
	}
	
	/// Get a list of all the stored healthcare organization
	/// - Returns: array of healthcare organization
	internal func read() throws -> [MgoOrganization] {
		
		if let jsonData = storage.read(fileName: fileName) {
			let data = try JSONDecoder().decode([MgoOrganization].self, from: jsonData)
			return data
		}
		return []
	}
	
	/// Delete a healthcare organization from storage
	/// - Parameter organization: the healthcare organization to be removed
	public func remove(_ organization: MgoOrganization) throws {
	
		logInfo("About to delete \(organization.display_name)")
		organizations = organizations.filter { $0 != organization }
		observers((organization, .removed))
		try persistToStorage()
	}
	
	/// set the list of organizations
	/// - Parameter newListOfOrganizations: the healthcare organizations to be stored
	public func set(_ newListOfOrganizations: [MgoOrganization]) throws {
		
		organizations = newListOfOrganizations
		observers((nil, .changed))
		try persistToStorage()
	}
	
	/// Remove all the healthcare organizations
	public func wipePersistedData() {
		
		organizations = []
		storage.remove(fileName)
	}
	
	/// Store a list of organizations
	private func persistToStorage() throws {
		
		try queue.sync {
			let encoded = try JSONEncoder().encode(organizations)
			try storage.store(encoded, as: fileName)
		}
	}
}
