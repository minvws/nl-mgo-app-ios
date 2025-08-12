/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
@testable import MGO

final class OrganizationListManualViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: OrganizationListManualViewModel!

	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	@MainActor private func createSut(
		city: String = "Roermond",
		name: String = "Tandarts Tandje Erbij",
		list: [MgoOrganization] = [],
		error: Error? = nil
	) throws {
		
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		localisationServiceClientSpy = LocalisationServiceClientSpy(serverUrl: serverUrl, username: nil, password: nil, organizations: list, error: error)
		sut = OrganizationListManualViewModel(
			coordinator: coordinatorSpy,
			city: city,
			name: name,
			localisationServiceClient: localisationServiceClientSpy
		)
	}

	@MainActor func test_loading() async throws {
		
		// Given
		
		// When
		try createSut()
		
		// Then
		expect(self.sut.state) == .loading
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beFalse())
	}
	
	@MainActor func test_noLocalisationServiceClient() {
		
		// Given
		sut = OrganizationListManualViewModel(
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
	
	@MainActor func test_empty() async throws {
		
		// Given
		try createSut()
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beTrue())
	}

	@MainActor func test_failure() async throws {
		
		// Given
		let error = NSError(domain: "OrganizationSearchResultsViewModelTests", code: 404)
		try createSut(error: error)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(.failure(error)))
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_retry() async throws {
		
		// Given
		try createSut()
		
		// When
		sut.reduce(.retry)
		
		// Then
		await expect(self.sut.state).toEventually(equal(.empty(city: "Roermond", name: "Tandarts Tandje Erbij")))
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value")
		try createSut(list: [organization])
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .regular)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(state))
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list_noDataServices() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value", useDataService: false)
		try createSut(list: [organization])
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .notParticipating)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(state))
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list_unsupportedDataServices() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value", useDataService: true, serviceId: "999")
		try createSut(list: [organization])
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .notParticipating)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(state))
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list_selected() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		try createSut(list: [organization])
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .selected)])
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [organization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(state))
		let didInvokeSearchHealthcareOrganizations = await localisationServiceClientSpy.didInvokeSearchHealthcareOrganizations()
		await expect(didInvokeSearchHealthcareOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_backButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		try createSut()
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	@MainActor func test_searchAgainButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		try createSut()
		
		// When
		sut.reduce(.backToSearch)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backToAddHealthcareOrganization
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}
	
	@MainActor func test_persist() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value")
		try createSut(list: [organization])
		
		// When
		sut.reduce(.store(organization))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.finishedSearchingHealthcareOrganizations
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedStore) == true
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedStoreParameters?.organization) == organization
	}
	
	@MainActor func test_closeSheet_shouldCallCoordinator() throws {
		
		// Given
		try createSut()
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
}
