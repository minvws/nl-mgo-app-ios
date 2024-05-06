/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
@testable import MGO

final class SearchResultViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: SearchResultViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		localisationServiceClientSpy = LocalisationServiceClientSpy()
	}
	
	private func createSut(city: String = "Roermond", name: String = "Tandarts Tandje Erbij") {
		
		sut = SearchResultViewModel(coordinator: coordinatorSpy, city: city, name: name, localisationServiceClient: localisationServiceClientSpy)
	}

	func test_loading() {
		
		// Given
		
		// When
		createSut()
		
		// Then
		expect(self.sut.state) == .loading
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareProviders).toEventually(beFalse())
	}
	
	func test_noLocalisationServiceClient() {
		
		// Given
		sut = SearchResultViewModel(coordinator: self.coordinatorSpy, city: "Roermond", name: "Tandarts Tandje Erbij", localisationServiceClient: nil)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure(LocalisationServiceClientError.noServer)))
	}
	
	func test_empty() {
		
		// Given
		createSut()
		localisationServiceClientSpy.stubbedSearchHealthcareProviders = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareProviders).toEventually(beTrue())
	}

	func test_failure() {
		
		// Given
		createSut()
		let error = NSError(domain: "SearchResultViewModelTests", code: 404)
		localisationServiceClientSpy.stubbedSearchHealthcareProviderError = error
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure(error)))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareProviders).toEventually(beTrue())
	}
	
	func test_retry() {
		
		// Given
		createSut()
		localisationServiceClientSpy.stubbedSearchHealthcareProviders = []
		
		// When
		sut.reduce(.retry)
		
		// Then
		expect(self.sut.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareProviders).toEventually(beTrue())
	}
	
	func test_list() {
		
		// Given
		createSut()
		let provider = Generator.healthcareProvider("value")
		let list: [HealthcareProvider] = [provider]
		localisationServiceClientSpy.stubbedSearchHealthcareProviders = list
		let state = SearchResultViewState.success([SearchResultSet(provider, .regular)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareProviders).toEventually(beTrue())
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.backButtonPressed
	}
	
	func test_searchAgainButtonPressed_shouldCallCoordinator() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.backToSearch)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.backToSearchHealthcareProvider
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}
	
	func test_persist() {
		
		// Given
		createSut()
		let provider = Generator.healthcareProvider("value")
		let list: [HealthcareProvider] = [provider]
		localisationServiceClientSpy.stubbedSearchHealthcareProviders = list
		
		// When
		sut.reduce(.store(provider))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == AppCoordination.Action.storeHealthcareProvider
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedStore) == true
		expect(self.servicesSpies.healthcareProviderStoreSpy.invokedStoreParameters?.provider) == provider
		
	}
}
