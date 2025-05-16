/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Observatory

public class MgoDataStoreSpy: MgoDataStoreProtocol {

	private let queue = DispatchQueue(label: "com.MgoDataStoreSpy.serialqueue.\(UUID().uuidString)")
	
	public init() {
		// Public init for public access
	}
	
	public var invokedObservatoryGetter = false
	public var invokedObservatoryGetterCount = 0
	public var stubbedObservatory: Observatory<Bool>!

	public var observatory: Observatory<Bool> {
		invokedObservatoryGetter = true
		invokedObservatoryGetterCount += 1
		return stubbedObservatory
	}

	public var invokedGetCategoryIdOrganizationId = false
	public var invokedGetCategoryIdOrganizationIdCount = 0
	public var invokedGetCategoryIdOrganizationIdParameters: (categoryId: String, organizationId: String)?
	public var invokedGetCategoryIdOrganizationIdParametersList = [(categoryId: String, organizationId: String)]()
	public var stubbedGetCategoryIdOrganizationIdResult: Result<[MgoResourceRecord], Error>!

	public func get(categoryId: String, organizationId: String) -> Result<[MgoResourceRecord], Error> {
		invokedGetCategoryIdOrganizationId = true
		invokedGetCategoryIdOrganizationIdCount += 1
		invokedGetCategoryIdOrganizationIdParameters = (categoryId, organizationId)
		invokedGetCategoryIdOrganizationIdParametersList.append((categoryId, organizationId))
		return stubbedGetCategoryIdOrganizationIdResult
	}

	public var invokedGetCategoryId = false
	public var invokedGetCategoryIdCount = 0
	public var invokedGetCategoryIdParameters: (categoryId: String, Void)?
	public var invokedGetCategoryIdParametersList = [(categoryId: String, Void)]()
	public var stubbedGetCategoryIdResult: Result<[MgoResourceRecord], Error>!

	public func get(categoryId: String) -> Result<[MgoResourceRecord], Error> {
		invokedGetCategoryId = true
		invokedGetCategoryIdCount += 1
		invokedGetCategoryIdParameters = (categoryId, ())
		invokedGetCategoryIdParametersList.append((categoryId, ()))
		return stubbedGetCategoryIdResult
	}

	public var invokedGetOrganizationId = false
	public var invokedGetOrganizationIdCount = 0
	public var invokedGetOrganizationIdParameters: (organizationId: String, Void)?
	public var invokedGetOrganizationIdParametersList = [(organizationId: String, Void)]()
	public var stubbedGetOrganizationIdResult: Result<[MgoResourceRecord], Error>!

	public func get(organizationId: String) -> Result<[MgoResourceRecord], Error> {
		invokedGetOrganizationId = true
		invokedGetOrganizationIdCount += 1
		invokedGetOrganizationIdParameters = (organizationId, ())
		invokedGetOrganizationIdParametersList.append((organizationId, ()))
		return stubbedGetOrganizationIdResult
	}

	public var invokedStore = false
	public var invokedStoreCount = 0
	public var invokedStoreParameters: (data: MgoResourceRecord, Void)?
	public var invokedStoreParametersList = [(data: MgoResourceRecord, Void)]()
	
	public func store(data: MgoResourceRecord) {
		queue.sync {
			invokedStore = true
			invokedStoreCount += 1
			invokedStoreParameters = (data, ())
			invokedStoreParametersList.append((data, ()))
		}
	}

	public var invokedRemoveRecords = false
	public var invokedRemoveRecordsCount = 0
	public var invokedRemoveRecordsParameters: (organizationId: String, Void)?
	public var invokedRemoveRecordsParametersList = [(organizationId: String, Void)]()

	public func removeRecords(for organizationId: String) {
		queue.sync {
			invokedRemoveRecords = true
			invokedRemoveRecordsCount += 1
			invokedRemoveRecordsParameters = (organizationId, ())
			invokedRemoveRecordsParametersList.append((organizationId, ()))
		}
	}

	public var invokedRemoveRecordsFor = false
	public var invokedRemoveRecordsForCount = 0
	public var invokedRemoveRecordsForParameters: (categoryID: String, organizationId: String?)?
	public var invokedRemoveRecordsForParametersList = [(categoryID: String, organizationId: String?)]()

	public func removeRecords(for categoryID: String, organizationId: String?) {
		queue.sync {
			invokedRemoveRecordsFor = true
			invokedRemoveRecordsForCount += 1
			invokedRemoveRecordsForParameters = (categoryID, organizationId)
			invokedRemoveRecordsForParametersList.append((categoryID, organizationId))
		}
	}

	public var invokedRemoveAllRecords = false
	public var invokedRemoveAllRecordsCount = 0

	public func removeAllRecords() {
		invokedRemoveAllRecords = true
		invokedRemoveAllRecordsCount += 1
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
