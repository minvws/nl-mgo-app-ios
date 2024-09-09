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

final class DashboardCoordinatorStateTests: XCTestCase {
	
	private var sut: DashboardCoordinator!
	private var parentCoordinator: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = AppCoordinatorSpy()
		sut = DashboardCoordinator(parentCoordinator: parentCoordinator)
	}
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_coordinatorView_forAboutTheApp() throws {
		
		// Given
		let state = DashboardCoordination.State.aboutTheApp
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forOverview() throws {
		
		// Given
		let state = DashboardCoordination.State.overview
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forAddHealthcareOrganization() throws {
		
		// Given
		let state = DashboardCoordination.State.addHealthcareOrganization
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}

	func test_coordinatorView_forHealthcareOrganizationSearchResults() throws {
		
		// Given
		let state = DashboardCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
		}
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}

	func test_coordinatorView_forListHealthcareOrganizations() throws {
		
		// Given
		let state = DashboardCoordination.State.listHealthcareOrganizations
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forShowHealthcareOrganization() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = DashboardCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view), precision: 0.95)
	}
	
	func test_coordinatorView_forRemoveHealthcareOrganization() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = DashboardCoordination.State.removeHealthcareOrganization(healthcareOrganization: organization)
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forShowLabResults() throws {

		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = DashboardCoordination.State.showLabResults(healthcareOrganization: organization)
		stub(condition: isPath("/fhir/Observation/$lastn")) { _ in
			return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
		}
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
}
