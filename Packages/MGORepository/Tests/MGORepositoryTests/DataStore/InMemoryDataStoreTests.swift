/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import MGORepository
import MGOTest

final class InMemoryDataStoreTests: XCTestCase {

	var sut: InMemoryDataStore!
	let record = MgoResourceRecord(categoryId: "test category", organizationId: "test organization", resources: [Data("test".utf8)], error: false)
	let otherRecord = MgoResourceRecord(categoryId: "test category", organizationId: "test organization 2", resources: [Data("test".utf8)], error: false)
	
	override func setUp() {
		super.setUp()
		sut = InMemoryDataStore()
		sut.store(data: self.record)
		sut.store(data: self.otherRecord)
	}
	
	func test_store_shouldNotOverwrite() {
		
		// Given
		var result = sut.get(categoryId: "test category")
		expect(result.successValue?.count) == 2
		
		// When
		sut.store(data: self.record)
		
		// Then
		result = sut.get(categoryId: "test category")
		expect(result.successValue?.count) == 3
	}

	func test_get_forOrganization_dataAvailable() {
		
		// Given
		
		// When
		let result = sut.get(organizationId: "test organization")
		
		// Then
		expect(result.isSuccess) == true
		expect(result.successValue?.count) == 1
		expect(result.successValue?[0].categoryId) == "test category"
		expect(result.successValue?[0].organizationId) == "test organization"
		expect(result.successValue?[0].resources) == [Data("test".utf8)]
		
		// Extra result checks
		expect(result.isFailure) == false
		expect(result.failureError) == nil
	}
	
	func test_get_forOrganization_noDataAvailable() {
		
		// Given
		
		// When
		let result = sut.get(organizationId: "no data available")
		
		// Then
		expect(result.isFailure) == true
		expect(result.failureError) != nil
	}
	
	func test_get_forCategoryAndOrganization_dataAvailable() {
		
		// Given
		
		// When
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		
		// Then
		expect(result.isSuccess) == true
		expect(result.successValue?.count) == 1
		expect(result.successValue?[0].categoryId) == "test category"
		expect(result.successValue?[0].organizationId) == "test organization"
		expect(result.successValue?[0].resources) == [Data("test".utf8)]
		
		// Extra result checks
		expect(result.isFailure) == false
		expect(result.failureError) == nil
	}
	
	func test_get_forCategoryAndOrganization_fetchOtherData() {
		
		// Given
		
		// When
		let result = sut.get(categoryId: "test category", organizationId: "test organization 2")
		
		// Then
		expect(result.isSuccess) == true
		expect(result.successValue?.count) == 1
		expect(result.successValue?[0].categoryId) == "test category"
		expect(result.successValue?[0].organizationId) == "test organization 2"
		expect(result.successValue?[0].resources) == [Data("test".utf8)]
	}
	
	func test_get_forCategoryAndOrganization_invalidOrganization() {
		
		// Given
		
		// When
		let result = sut.get(categoryId: "test category", organizationId: "wrong")
		
		// Then
		expect(result.isFailure) == true
		expect(result.failureError) != nil
		
		// Extra result checks
		expect(result.isSuccess) == false
		expect(result.successValue) == nil
	}
	
	func test_get_forCategoryAndOrganization_invalidCategory() {
		
		// Given
		
		// When
		let result = sut.get(categoryId: "wrong", organizationId: "test organization")
		
		// Then
		expect(result.isFailure) == true
		expect(result.failureError) != nil
	}
	
	func test_get_forCategory() {
		
		// Given
		
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
		
		// When
		let result = sut.get(categoryId: "wrong")
		
		// Then
		expect(result.isFailure) == true
		expect(result.failureError) != nil
	}
	
	func test_removeRecords_forOrganization() {
		
		// Given
		
		// When
		sut.removeRecords(for: "test organization")
		
		// Then
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		expect(result.isFailure) == true
		expect(result.failureError) != nil
	}
	
	func test_removeRecords_forOrganization_removeOtherOrganization() {
		
		// Given
		
		// When
		sut.removeRecords(for: "test organization 2")
		
		// Then
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		expect(result.isSuccess) == true
		expect(result.successValue?.count) == 1
		expect(result.successValue?[0].categoryId) == "test category"
		expect(result.successValue?[0].organizationId) == "test organization"
		expect(result.successValue?[0].resources) == [Data("test".utf8)]
	}
	
	func test_removeRecords_forCategory_forOrganization() {
		
		// Given
		
		// When
		sut.removeRecords(for: "test category", organizationId: "test organization 2")
		
		// Then
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		expect(result.isSuccess) == true
		expect(result.successValue?.count) == 1
		expect(result.successValue?[0].categoryId) == "test category"
		expect(result.successValue?[0].organizationId) == "test organization"
		expect(result.successValue?[0].resources) == [Data("test".utf8)]
	}
	
	func test_removeRecords_forCategory() {
		
		// Given
		
		// When
		sut.removeRecords(for: "test category", organizationId: nil)
		
		// Then
		let result = sut.get(categoryId: "test category", organizationId: "test organization")
		expect(result.isFailure) == true
		expect(result.failureError) != nil
	}
	
	func test_wipePersistentData() {
		
		// Given
		
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
