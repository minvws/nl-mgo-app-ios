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
			generateHealthcareProvider("1"),
			generateHealthcareProvider("2"),
			generateHealthcareProvider("3")
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
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.backToSearchHealthcareProvider
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
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.finishedSearchingHealthcareProviders
	}

	// MARK: - helper methods -
	
	private func generateHealthcareProvider(_ id: String, city: String = "Roermond", address: String = "Boorplatform 5", postalCode: String = "1234AB") -> HealthcareProvider {
		return HealthcareProvider(
			display_name: "Tandarts Tandje Erbij",
			   identification_type: "type",
			   identification_value: id,
			   active: true,
			   addresses: [Components.Schemas.Address(
				   active: true,
				   address: address,
				   city: city,
				   postalcode: postalCode,
				   _type: "postal")
			   ],
			   names: [],
			   types: [
					Components.Schemas.CType(
						code: "01",
						display_name: "Tandarts",
						_type: ""
					)
			   ]
		   )
	}
}
