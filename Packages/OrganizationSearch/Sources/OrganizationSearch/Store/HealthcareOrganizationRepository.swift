/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB
import MGODebug
import Observatory

public enum HealthcareOrganizationReason {
	case added
	case removed
	case changed
}

public protocol HealthcareOrganizationRepositoryProtocol {

	/// The list of stored healthcare organization
	var organizations: [Organization] { get }

	/// Observatory for changes
	var observatory: Observatory<(Organization?, HealthcareOrganizationReason)> { get }

	/// Add a healthcare organization to the storage
	/// - Parameter organization: the healthcare organization to store
	func store(_ organization: Organization) throws

	/// Delete a healthcare organization from storage
	/// - Parameter organization: the healthcare organization to be removed
	func remove(_ organization: Organization) throws

	/// set the list of organizations
	/// - Parameter newListOfOrganizations: the healthcare organizations to be stored
	func set(_ newListOfOrganizations: [Organization]) throws

	/// Remove all the healthcare organizations
	func wipePersistedData()
}

public class HealthcareOrganizationRepository: HealthcareOrganizationRepositoryProtocol, @unchecked Sendable {

	/// The SQLite database queue (serial — provides synchronization guarantee)
	private let dbQueue: DatabaseQueue

	/// Observatory for changes
	public let observatory: Observatory<(Organization?, HealthcareOrganizationReason)>

	/// Observers for changes
	private let observers: ((Organization?, HealthcareOrganizationReason)) -> Void

	/// The list of stored healthcare organizations (in-memory cache)
	public var organizations: [Organization]

	/// Initializer — opens the database, runs migrations, loads the stored list.
	/// - Throws: GRDB or Foundation errors if the database cannot be opened or migrated.
	public init() throws {

		self.dbQueue = try StoreDatabaseSetup.openDatabase()
		try StoreDatabaseMigrations.migrate(self.dbQueue)
		(self.observatory, self.observers) = Observatory<(Organization?, HealthcareOrganizationReason)>.create()

		do {
			self.organizations = try StoreDatabase.fetchAll(from: self.dbQueue)
		} catch {
			logError("HealthcareOrganizationRepository - error initializing ", error)
			self.organizations = []
		}
	}

	/// Add a healthcare organization to the storage
	/// - Parameter organization: the healthcare organization to store
	public func store(_ organization: Organization) throws {

		guard !organizations.contains(organization) else {
			// Can't add twice
			return
		}

		try StoreDatabase.insert(organization, into: dbQueue)
		organizations.append(organization)
		observers((organization, HealthcareOrganizationReason.added))
	}

	/// Get a list of all the stored healthcare organizations from the database
	/// - Returns: array of healthcare organization
	internal func read() throws -> [Organization] {
		try StoreDatabase.fetchAll(from: dbQueue)
	}

	/// Delete a healthcare organization from storage
	/// - Parameter organization: the healthcare organization to be removed
	public func remove(_ organization: Organization) throws {

		logInfo("About to delete \(organization.displayName ?? "")")
		try StoreDatabase.delete(organization, from: dbQueue)
		organizations = organizations.filter { $0 != organization }
		observers((organization, HealthcareOrganizationReason.removed))
	}

	/// set the list of organizations
	/// - Parameter newListOfOrganizations: the healthcare organizations to be stored
	public func set(_ newListOfOrganizations: [Organization]) throws {

		try StoreDatabase.replace(with: newListOfOrganizations, in: dbQueue)
		organizations = newListOfOrganizations
		observers((nil, HealthcareOrganizationReason.changed))
	}

	/// Remove all the healthcare organizations
	public func wipePersistedData() {

		try? StoreDatabase.deleteAll(from: dbQueue)
		organizations = []
	}
}
