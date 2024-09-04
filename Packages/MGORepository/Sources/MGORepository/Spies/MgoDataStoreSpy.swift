/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

class MgoDataStoreSpy: MgoDataStoreProtocol {

	public init() {
		// Public init for public access
	}
	
	public var invokedClear = false
	public var invokedClearCount = 0
	public var invokedClearParameters: (organizationId: String, Void)?
	public var invokedClearParametersList = [(organizationId: String, Void)]()

	public func clear(organizationId: String) {
		invokedClear = true
		invokedClearCount += 1
		invokedClearParameters = (organizationId, ())
		invokedClearParametersList.append((organizationId, ()))
	}

	public var invokedGetCategoryId = false
	public var invokedGetCategoryIdCount = 0
	public var invokedGetCategoryIdParameters: (categoryId: String, organizationId: String)?
	public var invokedGetCategoryIdParametersList = [(categoryId: String, organizationId: String)]()
	public var stubbedGetCategoryIdResult: Result<MgoDataSet, Error>!

	public func get(categoryId: String, organizationId: String) -> Result<MgoDataSet, Error> {
		invokedGetCategoryId = true
		invokedGetCategoryIdCount += 1
		invokedGetCategoryIdParameters = (categoryId, organizationId)
		invokedGetCategoryIdParametersList.append((categoryId, organizationId))
		return stubbedGetCategoryIdResult
	}

	public var invokedGet = false
	public var invokedGetCount = 0
	public var invokedGetParameters: (categoryId: String, Void)?
	public var invokedGetParametersList = [(categoryId: String, Void)]()
	public var stubbedGetResult: Result<[MgoDataSet], Error>!

	public func get(categoryId: String) -> Result<[MgoDataSet], Error> {
		invokedGet = true
		invokedGetCount += 1
		invokedGetParameters = (categoryId, ())
		invokedGetParametersList.append((categoryId, ()))
		return stubbedGetResult
	}

	public var invokedStore = false
	public var invokedStoreCount = 0
	public var invokedStoreParameters: (data: MgoDataSet, Void)?
	public var invokedStoreParametersList = [(data: MgoDataSet, Void)]()

	public func store(data: MgoDataSet) {
		invokedStore = true
		invokedStoreCount += 1
		invokedStoreParameters = (data, ())
		invokedStoreParametersList.append((data, ()))
	}
}
