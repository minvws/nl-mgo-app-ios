/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public protocol MgoDataStoreProtocol {
	
	/// Get a data set for a category and an organization
	/// - Parameters:
	///   - categoryId: the id of the category
	///   - organizationId: the id of the organization
	/// - Returns: Result object with dataset or error
	func get(categoryId: String, organizationId: String) -> Result<MgoDataStoreRecord, Error>
	
	/// Get all data sets for a category
	/// - Parameter categoryId: the id of the category
	/// - Returns: Result object with data sets or error
	func get(categoryId: String) -> Result<[MgoDataStoreRecord], Error>
	
	/// Store a data set
	/// - Parameter data: the data set to store
	func store(data: MgoDataStoreRecord)
	
	/// Remove all entries from the store for this organization
	/// - Parameter organizationId: the id of the organization to remove for
	func wipePersistedData(organizationId: String)

	/// Wipe all persisted data
	func wipePersistedData()
}
