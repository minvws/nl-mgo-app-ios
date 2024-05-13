/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class OverviewViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: OverviewViewModel!
	private var sut: OverviewView!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	private func createSut() {
		
		viewModel = OverviewViewModel(coordinator: coordinatorSpy)
		sut = OverviewView(viewModel: self.viewModel)
	}
	
	func test_dashboard_emptyList() {
		
		// Given
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = []
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_dashboard_threeProviders() {
		
		// Given
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = [
			Generator.healthcareProvider("1"),
			Generator.healthcareProvider("2"),
			Generator.healthcareProvider("3")
		]
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_dashboard_searchHealthcareProvider() throws {
		
		// Given
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = []
		createSut()
		
		// When
		try sut.inspect().find(viewWithTag: "dashboard_search_healthcareProviders").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.searchHealthcareProviders
	}
}
