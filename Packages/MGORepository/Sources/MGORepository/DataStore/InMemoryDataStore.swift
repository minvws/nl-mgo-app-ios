/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient
import Observatory

/// The in memory data store
public class InMemoryDataStore: MgoDataStoreProtocol {
	
	/// The in memory data source
	private var dataSource = [MgoResourceRecord]()
	
	/// Observatory for changes
	public let observatory: Observatory<Bool>
	
	/// Observers for changes
	private let observers: (Bool) -> Void
	
	/// Keep the datastore in sync across threads
	private let queue = DispatchQueue(label: "nl.mijngezondheidsomgeving.datastore.serialqueue.\(UUID().uuidString)")
	
	/// Create an in memory data store
	public init() {
		
		(self.observatory, self.observers) = Observatory<Bool>.create()
	}
	
	/// Get a data set for a category and an organization
	/// - Parameters:
	///   - categoryId: the id of the category
	///   - organizationId: the id of the organization
	/// - Returns: Result object with dataset or error
	public func get(categoryId: String, organizationId: String) -> Result<[MgoResourceRecord], any Error> {
		
		var result = [MgoResourceRecord]()
		
		for element in dataSource where element.categoryId == categoryId && element.organizationId == organizationId {
			result.append(element)
		}
		if result.isEmpty {
			return .failure(DataStoreError.noData)
		}
		return .success(result)
	}
	
	/// Get all data sets for a category
	/// - Parameter categoryId: the id of the category
	/// - Returns: Result object with data sets or error
	public func get(categoryId: String) -> Result<[MgoResourceRecord], any Error> {
		
		var result = [MgoResourceRecord]()
		
		for element in dataSource where element.categoryId == categoryId {
			result.append(element)
		}
		if result.isEmpty {
			return .failure(DataStoreError.noData)
		}
		return .success(result)
	}
	
	/// Get a data set for an organization
	/// - Parameters:
	///   - organizationId: the id of the organization
	/// - Returns: Result object with dataset or error
	public func get(organizationId: String) -> Result<[MgoResourceRecord], any Error> {
		
		var result = [MgoResourceRecord]()
		
		for element in dataSource where element.organizationId == organizationId {
			result.append(element)
		}
		if result.isEmpty {
			return .failure(DataStoreError.noData)
		}
		return .success(result)
	}
	
	/// Store a data set
	/// - Parameter data: the data set to store
	public func store(data: MgoResourceRecord) {
		
		queue.sync {
			dataSource.append(data)
		}
		DispatchQueue.main.async {
			self.observers(true)
		}
	}
	
	/// Remove all entries from the store for this organization
	/// - Parameter organizationId: the id of the organization to remove for
	public func removeRecords(for organizationId: String) {
		queue.sync {
			dataSource = dataSource.filter({ entry in
				entry.organizationId != organizationId
			})
		}
	}
	
	/// Remove all entries from the store for this organization and category
	/// - Parameter categoryID: the id of the category to remove for
	/// - Parameter organizationId: the id of the organization to remove for
	public func removeRecords(for categoryId: String, organizationId: String?) {
		queue.sync {
			if let organizationId {
				dataSource = dataSource.filter({ entry in
					entry.organizationId != organizationId || entry.categoryId != categoryId
				})
			} else {
				dataSource = dataSource.filter({ entry in
					entry.categoryId != categoryId
				})
			}
		}
	}
	
	/// Remove all records from the store
	public func removeAllRecords() {
		queue.sync {
			dataSource.removeAll()
		}
	}
	
	/// Wipe all persisted data
	public func wipePersistedData() {
		removeAllRecords()
	}
}
