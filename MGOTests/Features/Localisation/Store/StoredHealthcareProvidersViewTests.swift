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

final class StoredHealthcareProvidersViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: StoredHealthcareProvidersViewModel!
	private var sut: StoredHealthcareProvidersView!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	private func createSut() {
		
		viewModel = StoredHealthcareProvidersViewModel(coordinator: coordinatorSpy)
		sut = StoredHealthcareProvidersView(viewModel: self.viewModel)
		
	}
	
	func test_backbuttonPressed() throws {
		
		// Given
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = []
		createSut()
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithTag: "back_button").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_storedHealthcareProviders_emptyList() {
		
		// Given
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = []
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_storedHealthcareProviders_threeProviders() {
		
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
	
	func test_storedHealthcareProviders_backToSearchHealthcareProvider() throws {
		
		// Given
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = []
		createSut()
		
		// When
		try sut.inspect().find(viewWithTag: "storedhp_action_again").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backToSearchHealthcareProvider
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}
	
	func test_storedHealthcareProviders_finishedSearchingHealthcareProviders() throws {
		
		// Given
		servicesSpies.healthcareProviderStoreSpy.stubbedProviders = []
		createSut()
		
		// When
		try sut.inspect().find(viewWithTag: "storedhp_action_done").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.finishedSearchingHealthcareProviders
	}
}
