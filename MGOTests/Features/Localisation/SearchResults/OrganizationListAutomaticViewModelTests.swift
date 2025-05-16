/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
@testable import MGO

final class OrganizationListAutomaticViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var localisationServiceClientSpy: LocalisationServiceClientSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: OrganizationListAutomaticViewModel!

	override func setUpWithError() throws {
		
		try super.setUpWithError()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		localisationServiceClientSpy = LocalisationServiceClientSpy(serverUrl: serverUrl, username: nil, password: nil)
	}
	
	private func createSut(preselectAllOrganizations: Bool = true) {
		
		sut = OrganizationListAutomaticViewModel(
			coordinator: coordinatorSpy,
			localisationServiceClient: localisationServiceClientSpy,
			preselectAllOrganizations: preselectAllOrganizations
		)
	}

	func test_loading() {
		
		// Given
		
		// When
		createSut()
		
		// Then
		expect(self.sut.state) == .loading
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beFalse())
	}
	
	func test_noLocalisationServiceClient() {
		
		// Given
		sut = OrganizationListAutomaticViewModel(
			coordinator: self.coordinatorSpy,
			localisationServiceClient: nil,
			preselectAllOrganizations: true
		)
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure(LocalisationServiceClientError.noServer)))
	}
	
	func test_empty() {
		
		// Given
		createSut()
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure(LocalisationServiceClientError.noOrganizations)))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue())
	}

	func test_failure() {
		
		// Given
		createSut()
		let error = NSError(domain: "AutomaticSearchResultsViewModelTests", code: 404)
		localisationServiceClientSpy.stubbedSearchDemoOrganizationError = error
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure(error)))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue())
	}
	
	func test_retry() {
		
		// Given
		createSut()
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = []
		
		// When
		sut.reduce(.retry)
		
		// Then
		expect(self.sut.state).toEventually(equal(.failure(LocalisationServiceClientError.noOrganizations)))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue())
	}
	
	func test_list() {
		
		// Given
		createSut()
		let organization = Generator.healthcareOrganization("value")
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: true))])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue())
	}
	
	func test_list_demoMode() {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		createSut()
		let organization = Generator.healthcareOrganization("value")
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: true))])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue(), timeout: .seconds(10))
	}
	
	func test_list_notPreselected() {
		
		// Given
		createSut(preselectAllOrganizations: false)
		let organization = Generator.healthcareOrganization("value")
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: false))])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue())
	}
	
	func test_list_noDataServices() {
		
		// Given
		createSut()
		let organization = Generator.healthcareOrganization("value", useDataService: false)
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .notParticipating)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue())
	}
	
	func test_list_unsupportedDataServices() {
		
		// Given
		createSut()
		let organization = Generator.healthcareOrganization("value", useDataService: true, serviceId: "999")
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .notParticipating)])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue())
	}
	
	func test_list_selected() {
		
		// Given
		createSut()
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: true))])
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = list
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(state))
		expect(self.localisationServiceClientSpy.invokedSearchDemoOrganizations).toEventually(beTrue())
	}
	
	func test_closeSheet_shouldCallCoordinator() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	func test_select_shouldAddToList() {
		
		// Given
		createSut(preselectAllOrganizations: false)
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		sut.searchResultsList = list
		
		// When
		sut.reduce(.select(organization))
		
		// Then
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: true))])
		expect(self.sut.state).toEventually(equal(state))
	}
	
	func test_unselect_shouldRemoveFromList() {
		
		// Given
		createSut()
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		sut.searchResultsList = list
		sut.selectedSearchResultsList = list
		
		// When
		sut.reduce(.unselect(organization))
		
		// Then
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: false))])
		expect(self.sut.state).toEventually(equal(state))
	}
	
	func test_store() {
		
		// Given
		createSut()
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		let list: [MgoOrganization] = [organization]
		localisationServiceClientSpy.stubbedSearchDemoOrganizations = list
		sut.searchResultsList = list
		sut.reduce(.select(organization))
		
		// When
		sut.reduce(.store)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.finishedSearchingHealthcareOrganizations
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedStore) == true
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedStoreParameters?.organization) == organization
	}
}
