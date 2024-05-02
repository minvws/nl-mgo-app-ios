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

final class StoredHealthcareProvidersViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: StoredHealthcareProvidersViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = StoredHealthcareProvidersViewModel(coordinator: coordinatorSpy)
	}

	func test_onAppear_shouldCallStore() {
		
		// Given
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedProvidersGetter) == true
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.backButtonPressed
	}
	
	func test_backToSearch_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backToSearch)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.backToSearchHealthcareProvider
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}
	
	func test_done_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.done)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.finishedSearchingHealthcareProviders
	}
	
	func test_showRemoveDialog_shouldShowDialog() {
		
		// Given
		let provider = generateHealthcareProvider("1")
		
		// When
		sut.reduce(.showRemoveDialog(provider))
		
		// Then
		expect(self.sut.healthcareProviderToRemoveTitle) == "Tandarts Tandje Erbij weglaten?"
	}
	
	func test_cancelDialog_shouldClearDialog() {
		
		// Given
		let provider = generateHealthcareProvider("1")
		sut.reduce(.showRemoveDialog(provider))
		
		// When
		sut.reduce(.cancelDialog)
		
		// Then
		expect(self.sut.healthcareProviderToRemoveTitle) == nil
	}

	func test_remove_shouldCallStore() {
		
		// Given
		let provider = generateHealthcareProvider("1")
		sut.reduce(.showRemoveDialog(provider))
		self.servicesSpies.healthcareProviderStoreSpy.invokedProvidersGetter = false
		self.servicesSpies.healthcareProviderStoreSpy.invokedProvidersGetterCount = 0
		
		// When
		sut.reduce(.remove)
		
		// Then
		expect(self.sut.healthcareProviderToRemoveTitle) == nil
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedRemove) == true
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedRemoveParameters?.0) == provider

		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedProvidersGetter) == true
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedProvidersGetterCount) == 1
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
