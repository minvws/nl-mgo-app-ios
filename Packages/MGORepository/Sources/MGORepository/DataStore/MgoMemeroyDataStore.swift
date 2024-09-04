/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

/// The in memory data store
public class MgoMemoryDataStore: MgoDataStoreProtocol {
	
	/// The in memory data source
	private var dataSource = [MgoDataStoreRecord]()
	
	/// Create an in memory data store
	public init() { /* public init for public access */ }
	
	/// Remove all entries from the store for this organization
	/// - Parameter organizationId: the id of the organization to remove for
	public func clear(organizationId: String) {
		
		dataSource = dataSource.filter({ entry in
			entry.organizationId != organizationId
		})
	}
	
	/// Get a data set for a category and an organization
	/// - Parameters:
	///   - categoryId: the id of the category
	///   - organizationId: the id of the organization
	/// - Returns: Result object with dataset or error
	public func get(categoryId: String, organizationId: String) -> Result<MgoDataStoreRecord, any Error> {
		
		for element in dataSource where element.categoryId == categoryId && element.organizationId == organizationId {
			return .success(element)
		}
		return .failure(NSError(domain: "MGODataStore", code: 404))
	}
	
	/// Get all data sets for a category
	/// - Parameter categoryId: the id of the category
	/// - Returns: Result object with data sets or error
	public func get(categoryId: String) -> Result<[MgoDataStoreRecord], any Error> {
		
		var result = [MgoDataStoreRecord]()
		
		for element in dataSource where element.categoryId == categoryId {
			result.append(element)
		}
		return .success(result)
	}
	
	/// Store a data set
	/// - Parameter data: the data set to store
	public func store(data: MgoDataStoreRecord) {
		
		var found = false

		for (index, element) in dataSource.enumerated() where element.categoryId == data.categoryId && element.organizationId == data.organizationId {
			dataSource[index] = data
			found = true
		}
		
		if !found {
			dataSource.append(data)
		}
	}
}
