/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Observatory

public protocol MgoDataStoreProtocol {
	
	/// Observatory for changes
	var observatory: Observatory<Bool> { get }
	
	/// Get a data set for a category and an organization
	/// - Parameters:
	///   - categoryId: the id of the category
	///   - organizationId: the id of the organization
	/// - Returns: Result object with dataset or error
	func get(categoryId: String, organizationId: String) -> Result<[MgoResourceRecord], Error>
	
	/// Get all data sets for a category
	/// - Parameter categoryId: the id of the category
	/// - Returns: Result object with data sets or error
	func get(categoryId: String) -> Result<[MgoResourceRecord], Error>

	/// Get a data set for an organization
	/// - Parameters:
	///   - organizationId: the id of the organization
	/// - Returns: Result object with dataset or error
	func get(organizationId: String) -> Result<[MgoResourceRecord], Error>
	
	/// Store a data set
	/// - Parameter data: the data set to store
	func store(data: MgoResourceRecord)
	
	/// Remove all entries from the store for this organization
	/// - Parameter organizationId: the id of the organization to remove for
	func removeRecords(for organizationId: String)
	
	/// Remove all entries from the store for this organization and category
	/// - Parameter categoryID: the id of the category to remove for
	/// - Parameter organizationId: the id of the organization to remove for
	func removeRecords(for categoryID: String, organizationId: String?)

	/// Remove all records from the store
	func removeAllRecords()
	
	/// Wipe all persisted data
	func wipePersistedData()
}

public enum DataStoreError: Error {
	case noData
}
