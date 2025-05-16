/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class ResourceRepositoryTests: XCTestCase {

	private var servicesSpies: ServicesSpies!
	private var sut: ResourceRepository!
	
	override func setUpWithError() throws {
		
		servicesSpies = setupServicesSpies()

		let url = try XCTUnwrap(URL(string: "https://example.com"))
		sut = ResourceRepository(
			healthcareOrganizationRepository: servicesSpies.healthcareOrganizationStoreSpy,
			dataRepository: servicesSpies.dataStoreSpy,
			featureFlagManager: servicesSpies.featureFlagSpy,
			serverUrl: url,
			username: "test",
			password: "test"
		)
	}
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_load_noOrganizations() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		let json = try getResource("bundle")
		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(0))
	}
	
	func test_load_oneOrganization() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [Generator.healthcareOrganization("1")]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(28), timeout: .seconds(10))
	}
	
	func test_load_oneOrganization_demoMode() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [Generator.healthcareOrganization("1")]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(2), timeout: .seconds(10))
	}
	
	func test_load_twoOrganizations() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1"),
			Generator.healthcareOrganization("2")
		]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(56), timeout: .seconds(15))
	}
	
	func test_load_twoOrganizations_demoMode() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1"),
			Generator.healthcareOrganization("2")
		]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(4), timeout: .seconds(10))
	}
	
	func test_loadForOrganization() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.loadFor(organization)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(28), timeout: .seconds(10))
	}
	
	func test_loadForCategory_oneOrganization() async throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1")
		]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		await sut.loadFor(HealthCategories.Category.medication)
		
		// Then
		await expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(3), timeout: .seconds(10))
	}
	
	func test_loadForCategory_twoOrganizations() async throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1"),
			Generator.healthcareOrganization("2")
		]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		await sut.loadFor(HealthCategories.Category.medication)
		
		// Then
		await expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(6), timeout: .seconds(10))
	}
	
	func test_loadBinary() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let url = "https://example.com/Binary/file1"
		let json = try getResource("binary")
		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let zib = try await sut.loadBinary(organization, serviceId: "48", url: url)
		
		// Then
		expect(zib?.contentType) == "application/pdf"
	}
	
	func test_loadBinary_noDataService() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1", useDataService: false)
		let url = "https://example.com/Binary/file1"
		
		// When
		let zib = try await sut.loadBinary(organization, serviceId: "48", url: url)
		
		// Then
		expect(zib) == nil
	}
	
	func test_loadBinary_invalidBinary() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let url = "https://example.com/Binary/file1"
		let json = try getResource("bundle")
		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let zib = try await sut.loadBinary(organization, serviceId: "48", url: url)
		
		// Then
		expect(zib) == nil
	}
	
	func test_handleOrganizationChanges_added() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.handleOrganizationChanges(organization, reason: .added)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(28), timeout: .seconds(10))
	}
	
	func test_handleOrganizationChanges_removed() {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		
		// When
		sut.handleOrganizationChanges(organization, reason: .removed)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == true
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveAllRecords) == false
	}
	
	func test_handleOrganizationChanges_changed() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		let json = try getResource("bundle")
		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.handleOrganizationChanges(nil, reason: .changed)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == false
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveAllRecords) == true
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(0))
	}
}
