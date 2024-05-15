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
	
	func test_coordinatorView_forSearchHealthcareProvider() throws {
		
		// Given
		let state = DashboardCoordination.State.searchHealthcareProvider
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}

	func test_coordinatorView_forSearchHealthcareProviders() throws {
		
		// Given
		let state = DashboardCoordination.State.searchHealthcareProviders(city: "Roermond", name: "Tandarts Tandje Erbij")
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}

	func test_coordinatorView_forStoredHealthcareProviders() throws {
		
		// Given
		let state = DashboardCoordination.State.storedHealthcareProviders
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
}
