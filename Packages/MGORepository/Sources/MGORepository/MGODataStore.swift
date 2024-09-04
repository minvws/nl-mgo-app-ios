/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public protocol MGODataStoreProtocol {

	func get(categoryId: String, organizationId: String) -> Result<MgoDataSet, Error>
	
	func get(categoryId: String) -> Result<[MgoDataSet], Error>
	
	func store(data: MgoDataSet)
}

public typealias MgoDataSet = (categoryId: String, organizationId: String, zibSchemas: [ZibSchema], name: String)

public class MGOMemoryDataStore: MGODataStoreProtocol {
	
	private var dataSource = [MgoDataSet]()
	
	public init() { /* public init for public access */ }
	
	public func get(categoryId: String, organizationId: String) -> Result<MgoDataSet, any Error> {
		
		for element in dataSource where element.categoryId == categoryId && element.organizationId == organizationId {
			return .success(element)
		}
		return .failure(NSError(domain: "MGODataStore", code: 404))
	}
	
	public func get(categoryId: String) -> Result<[MgoDataSet], any Error> {
		
		var result = [MgoDataSet]()
		
		for element in dataSource where element.categoryId == categoryId {
			result.append(element)
		}
		return .success(result)
	}
	
	public func store(data: MgoDataSet) {
		
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
