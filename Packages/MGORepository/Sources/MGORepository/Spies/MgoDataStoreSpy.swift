/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class MgoDataStoreSpy: MgoDataStoreProtocol {

	public init() {
		// Public init for public access
	}
	
	public var invokedGetCategoryId = false
	public var invokedGetCategoryIdCount = 0
	public var invokedGetCategoryIdParameters: (categoryId: String, organizationId: String)?
	public var invokedGetCategoryIdParametersList = [(categoryId: String, organizationId: String)]()
	public var stubbedGetCategoryIdResult: Result<MgoResourceRecord, Error>!

	public func get(categoryId: String, organizationId: String) -> Result<MgoResourceRecord, Error> {
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
	public var stubbedGetResult: Result<[MgoResourceRecord], Error>!

	public func get(categoryId: String) -> Result<[MgoResourceRecord], Error> {
		invokedGet = true
		invokedGetCount += 1
		invokedGetParameters = (categoryId, ())
		invokedGetParametersList.append((categoryId, ()))
		return stubbedGetResult
	}

	public var invokedStore = false
	public var invokedStoreCount = 0
	public var invokedStoreParameters: (data: MgoResourceRecord, Void)?
	public var invokedStoreParametersList = [(data: MgoResourceRecord, Void)]()

	public func store(data: MgoResourceRecord) {
		invokedStore = true
		invokedStoreCount += 1
		invokedStoreParameters = (data, ())
		invokedStoreParametersList.append((data, ()))
	}

	public var invokedWipePersistedDataOrganizationId = false
	public var invokedWipePersistedDataOrganizationIdCount = 0
	public var invokedWipePersistedDataOrganizationIdParameters: (organizationId: String, Void)?
	public var invokedWipePersistedDataOrganizationIdParametersList = [(organizationId: String, Void)]()

	public func wipePersistedData(organizationId: String) {
		invokedWipePersistedDataOrganizationId = true
		invokedWipePersistedDataOrganizationIdCount += 1
		invokedWipePersistedDataOrganizationIdParameters = (organizationId, ())
		invokedWipePersistedDataOrganizationIdParametersList.append((organizationId, ()))
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
