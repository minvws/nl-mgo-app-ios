/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(13), timeout: .seconds(5))
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
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(26), timeout: .seconds(5))
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
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(13))
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
		await expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(3))
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
		await expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(6))
	}
}
