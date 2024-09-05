/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest

final class MgoMemoryDataStoreTests: XCTestCase {

	var sut: MgoMemoryDataStore!
	
	override func setUp() {
		super.setUp()
		sut = MgoMemoryDataStore()
	}
	
	func test_get_forOrganization_dataAvailable() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		
		// Then
		expect(result.isSuccess) == true
		expect(result.successValue?.categoryId) == "test category"
		expect(result.successValue?.organizationId) == "test organization"
		expect(result.successValue?.resources) == [Data("test".utf8)]
		expect(result.successValue?.name) == "test name"
		
		// Extra result checks
		expect(result.isFailure) == false
		expect(result.failureError) == nil
	}
	
	func test_get_forOrganization_dataAvailable_otherDataAvailable() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization 2", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		
		// Then
		expect(result.isSuccess) == true
		expect(result.successValue?.categoryId) == "test category"
		expect(result.successValue?.organizationId) == "test organization"
		expect(result.successValue?.resources) == [Data("test".utf8)]
		expect(result.successValue?.name) == "test name"
	}
	
	func test_get_forOrganization_dataAvailable_otherDataAvailable_fetchOtherData() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization 2", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		let result = sut.get(categoryId: "test category", organizationId: "test organization 2")
		
		// Then
		expect(result.isSuccess) == true
		expect(result.successValue?.categoryId) == "test category"
		expect(result.successValue?.organizationId) == "test organization 2"
		expect(result.successValue?.resources) == [Data("test".utf8)]
		expect(result.successValue?.name) == "test name"
	}
	
	func test_get_forOrganization_invalidOrganization() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		let result = sut.get(categoryId: "test category", organizationId: "wrong")
		
		// Then
		expect(result.isFailure) == true
		expect(result.failureError) != nil
		
		// Extra result checks
		expect(result.isSuccess) == false
		expect(result.successValue) == nil
	}
	
	func test_get_forOrganization_invalidCategory() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		let result = sut.get(categoryId: "wrong", organizationId: "test organization")
		
		// Then
		expect(result.isFailure) == true
		expect(result.failureError) != nil
	}
	
	func test_get_forCategory() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization 2", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		let result = sut.get(categoryId: "test category")
		
		// Then
		expect(result.isSuccess) == true
		expect(result.successValue?.count) == 2
		expect(result.successValue?[0].organizationId) == "test organization"
		expect(result.successValue?[1].organizationId) == "test organization 2"
	}
	
	func test_get_forCategory_invalidCategory() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization 2", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		let result = sut.get(categoryId: "wrong")
		
		// Then
		expect(result.isFailure) == false
		expect(result.successValue?.isEmpty) == true
	}
	
	func test_wipePersistentData_forOrganization() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization 2", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		sut.wipePersistedData(organizationId: "test organization")
		
		// Then
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		expect(result.isFailure) == true
		expect(result.failureError) != nil
	}
	
	func test_wipePersistentData_forOrganization_removeOtherOrganization() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization 2", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		sut.wipePersistedData(organizationId: "test organization 2")
		
		// Then
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		expect(result.isSuccess) == true
		expect(result.successValue?.categoryId) == "test category"
		expect(result.successValue?.organizationId) == "test organization"
		expect(result.successValue?.resources) == [Data("test".utf8)]
		expect(result.successValue?.name) == "test name"
	}
	
	func test_wipePersistentData() {
		
		// Given
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], name: "test name"))
		sut.store(data: MgoDataStoreRecord(categoryId: "test category", organizationId: "test organization 2", resources: [Data("test".utf8)], name: "test name"))
		
		// When
		sut.wipePersistedData()
		
		// Then
		let result1 = sut.get(categoryId: "test category", organizationId: "test organization")
		expect(result1.isFailure) == true
		expect(result1.failureError) != nil

		let result2 = sut.get(categoryId: "test category", organizationId: "test organization 2")
		expect(result2.isFailure) == true
		expect(result2.failureError) != nil
	}
}
