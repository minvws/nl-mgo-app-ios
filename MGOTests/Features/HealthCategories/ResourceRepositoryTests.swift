/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@preconcurrency import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class ResourceRepositoryTests: XCTestCase {

	private var servicesSpies: ServicesSpies!
	private var sut: ResourceRepository!
	
	@MainActor func createSut() throws {
		
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
	
	@MainActor func test_load_noOrganizations() throws {
		
		// Given
		try createSut()
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
	
	@MainActor func test_load_oneOrganization() throws {
		
		// Given
		try createSut()
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [Generator.healthcareOrganization("1")]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount)
			.toEventually(equal(30), timeout: .seconds(10))
	}
	
	@MainActor func test_load_oneOrganization_demoMode() throws {
		
		// Given
		try createSut()
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [Generator.healthcareOrganization("1")]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount)
			.toEventually(equal(2), timeout: .seconds(10))
	}
	
	@MainActor func test_load_twoOrganizations() throws {
		
		// Given
		try createSut()
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
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount)
			.toEventually(equal(60), timeout: .seconds(15))
	}
	
	@MainActor func test_load_twoOrganizations_demoMode() throws {
		
		// Given
		try createSut()
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
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount)
			.toEventually(equal(4), timeout: .seconds(10))
	}
	
	@MainActor func test_loadForOrganization() throws {
		
		// Given
		try createSut()
		let organization = Generator.healthcareOrganization("1")
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.loadFor(organization)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount)
			.toEventually(equal(30), timeout: .seconds(10))
	}
	
	@MainActor func test_loadForCategory_oneOrganization() async throws {
		
		// Given
		try createSut()
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1")
		]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		await sut.loadFor(Generator.healthCategory)
		
		// Then
		await expect(self.servicesSpies.dataStoreSpy.invokedStoreCount)
			.toEventually(equal(3), timeout: .seconds(10))
	}
	
	@MainActor func test_loadForCategory_twoOrganizations() async throws {
		
		// Given
		try createSut()
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1"),
			Generator.healthcareOrganization("2")
		]
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		await sut.loadFor(Generator.healthCategory)
		
		// Then
		await expect(self.servicesSpies.dataStoreSpy.invokedStoreCount)
			.toEventually(equal(6), timeout: .seconds(10))
	}
	
	@MainActor func test_loadBinary() async throws {
		
		// Given
		try createSut()
		let organization = Generator.healthcareOrganization("1")
		let url = "https://example.com/Binary/file1"
		let json = try getResource("binary")
		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let hcim = try await sut.loadBinary(organization, serviceId: "48", url: url)
		
		// Then
		expect(hcim?.contentType) == "application/pdf"
	}
	
	@MainActor func test_loadBinary_noDataService() async throws {
		
		// Given
		try createSut()
		let organization = Generator.healthcareOrganization("1", useDataService: false)
		let url = "https://example.com/Binary/file1"
		
		// When
		let hcim = try await sut.loadBinary(organization, serviceId: "48", url: url)
		
		// Then
		expect(hcim) == nil
	}
	
	@MainActor func test_loadBinary_invalidBinary() async throws {
		
		// Given
		try createSut()
		let organization = Generator.healthcareOrganization("1")
		let url = "https://example.com/Binary/file1"
		let json = try getResource("bundle")
		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		let hcim = try await sut.loadBinary(organization, serviceId: "48", url: url)
		
		// Then
		expect(hcim) == nil
	}
	
	@MainActor func test_handleOrganizationChanges_added() throws {
		
		// Given
		try createSut()
		let organization = Generator.healthcareOrganization("1")
		let json = try getResource("bundle")

		stub(condition: isHost("example.com")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.handleOrganizationChanges(organization, reason: .added)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount)
			.toEventually(equal(30), timeout: .seconds(10))
	}
	
	@MainActor func test_handleOrganizationChanges_removed() throws {
		
		// Given
		try createSut()
		let organization = Generator.healthcareOrganization("1")
		
		// When
		sut.handleOrganizationChanges(organization, reason: .removed)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == true
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveAllRecords) == false
	}
	
	@MainActor func test_handleOrganizationChanges_changed() throws {
		
		// Given
		try createSut()
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
