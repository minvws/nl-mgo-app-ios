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
		let url = try XCTUnwrap(URL(string: "https:example.com"))
		sut = ResourceRepository(healthcareOrganizationRepository: servicesSpies.healthcareOrganizationStoreSpy, dataRepository: servicesSpies.dataStoreSpy, serverUrl: url)
	}
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_load_noOrganizations() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		let json = try getResource("bundle")
		stub(condition: isPath("/MedicationStatement")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(0))
	}
	
	func test_load_oneOrganizations() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [Generator.healthcareOrganization("1")]
		let json = try getResource("bundle")

		stub(condition: isPath("/MedicationStatement")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(1))
	}
	
	func test_load_twoOrganizations() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1"),
			Generator.healthcareOrganization("2")
		]
		let json = try getResource("bundle")

		stub(condition: isPath("/MedicationStatement")) { _ in
			return HTTPStubsResponse(data: json, statusCode: 200, headers: nil)
		}
		
		// When
		sut.load()
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedStoreCount).toEventually(equal(2), timeout: .seconds(5))
	}
}
