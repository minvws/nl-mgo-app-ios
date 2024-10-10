/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
@testable import MGO

final class OrganizationSearchResultsViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: OrganizationSearchResultsViewModel!

	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		localisationServiceClientSpy = LocalisationServiceClientSpy(serverUrl: serverUrl, username: nil, password: nil)
	}
	
	private func createSut(city: String = "Roermond", name: String = "Tandarts Tandje Erbij") {
		
		sut = OrganizationSearchResultsViewModel(
			coordinator: coordinatorSpy,
			city: city,
			name: name,
			localisationServiceClient: localisationServiceClientSpy
		)
	}

	func test_loading() {
		
		// Given
		
		// When
		createSut()
		
		// Then
		expect(self.sut.state) == .loading
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beFalse())
	}
	
	func test_noLocalisationServiceClient() {
		
		// Given
		sut = OrganizationSearchResultsViewModel(
			coordinator: self.coordinatorSpy,
			city: "Roermond",
			name: "Tandarts Tandje Erbij",
			localisationServiceClient: nil
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure(LocalisationServiceClientError.noServer)))
	}
	
	func test_empty() {
		
		// Given
		createSut()
		localisationServiceClientSpy.stubbedSearchHealthcareOrganizations = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beTrue())
	}

	func test_failure() {
		
		// Given
		createSut()
		let error = NSError(domain: "OrganizationSearchResultsViewModelTests", code: 404)
		localisationServiceClientSpy.stubbedSearchHealthcareOrganizationError = error
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure(error)))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	func test_retry() {
		
		// Given
		createSut()
		localisationServiceClientSpy.stubbedSearchHealthcareOrganizations = []
		
		// When
		sut.reduce(.retry)
		
		// Then
		expect(self.sut.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	func test_list() {
		
		// Given
		createSut()
		let organisation = Generator.healthcareOrganization("value")
		let list: [MgoOrganization] = [organisation]
		localisationServiceClientSpy.stubbedSearchHealthcareOrganizations = list
		let state = OrganizationSearchResultViewState.success([OrganizationSearchResultSet(organisation, .regular)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	func test_list_noDataServices() {
		
		// Given
		createSut()
		let organisation = Generator.healthcareOrganization("value", useDataService: false)
		let list: [MgoOrganization] = [organisation]
		localisationServiceClientSpy.stubbedSearchHealthcareOrganizations = list
		let state = OrganizationSearchResultViewState.success([OrganizationSearchResultSet(organisation, .notParticipating)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	func test_list_unsupportedDataServices() {
		
		// Given
		createSut()
		let organisation = Generator.healthcareOrganization("value", useDataService: true, serviceId: "999")
		let list: [MgoOrganization] = [organisation]
		localisationServiceClientSpy.stubbedSearchHealthcareOrganizations = list
		let state = OrganizationSearchResultViewState.success([OrganizationSearchResultSet(organisation, .notImplemented)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	func test_list_selected() {
		
		// Given
		createSut()
		let organisation = Generator.healthcareOrganization("value", useDataService: true)
		let list: [MgoOrganization] = [organisation]
		localisationServiceClientSpy.stubbedSearchHealthcareOrganizations = list
		let state = OrganizationSearchResultViewState.success([OrganizationSearchResultSet(organisation, .selected)])
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = list
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_searchAgainButtonPressed_shouldCallCoordinator() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.backToSearch)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backToAddHealthcareOrganization
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}
	
	func test_persist() {
		
		// Given
		createSut()
		let organization = Generator.healthcareOrganization("value")
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchHealthcareOrganizations = list
		
		// When
		sut.reduce(.store(organization))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.finishedSearchingHealthcareOrganizations
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedStore) == true
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedStoreParameters?.organization) == organization
	}
}
