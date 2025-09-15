/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@preconcurrency import MGOTest
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
	}
	
	@MainActor private func createSut(
		preselectAllOrganizations: Bool = true,
		list: [MgoOrganization] = [],
		error: Error? = nil
	) throws {
		
		let serverUrl = try XCTUnwrap(URL(string: "https://example.com"))
		localisationServiceClientSpy = LocalisationServiceClientSpy(
			serverUrl: serverUrl,
			username: nil,
			password: nil,
			organizations: list,
			error: error
		)
		
		sut = OrganizationListAutomaticViewModel(
			coordinator: coordinatorSpy,
			localisationServiceClient: localisationServiceClientSpy,
			preselectAllOrganizations: preselectAllOrganizations
		)
	}
	
	@MainActor func test_loading() async throws {
		
		// Given
		
		// When
		try createSut()
		
		// Then
		expect(self.sut.state) == .loading
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beFalse())
	}
	
	@MainActor func test_noLocalisationServiceClient() {
		
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
	
	@MainActor func test_empty() async throws {
		
		// Given
		try createSut()
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(.failure(LocalisationServiceClientError.noOrganizations)))
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_retry() async throws {
		
		// Given
		try createSut()
		
		// When
		sut.reduce(.retry)
		
		// Then
		await expect(self.sut.state).toEventually(equal(.failure(LocalisationServiceClientError.noOrganizations)))
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value")
		try createSut(list: [organization])
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: true))])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(state))
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list_demoMode() async throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsDemo = true
		let organization = Generator.healthcareOrganization("value")
		try createSut(list: [organization])
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: true))])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(state))
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list_notPreselected() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value")
		try createSut(preselectAllOrganizations: false, list: [organization])
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: false))])
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(state))
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beTrue())
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
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beTrue())
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
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_list_selected() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		try createSut(list: [organization])
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: true))])
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [organization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		await expect(self.sut.state).toEventually(equal(state))
		let didInvokeSearchDemoOrganizations = await localisationServiceClientSpy.didInvokeSearchDemoOrganizations()
		await expect(didInvokeSearchDemoOrganizations).toEventually(beTrue())
	}
	
	@MainActor func test_closeSheet_shouldCallCoordinator() async throws {
		
		// Given
		try createSut()
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	@MainActor func test_select_shouldAddToList() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		try createSut(preselectAllOrganizations: false, list: [organization])
		sut.searchResultsList = [organization]
		
		// When
		sut.reduce(.select(organization))
		
		// Then
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: true))])
		await expect(self.sut.state).toEventually(equal(state))
	}
	
	@MainActor func test_unselect_shouldRemoveFromList() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		try createSut(list: [organization])
		sut.searchResultsList = [organization]
		sut.selectedSearchResultsList = [organization]
		
		// When
		sut.reduce(.unselect(organization))
		
		// Then
		let state = OrganizationListViewState.success([OrganizationListSet(organization, .automatic(isSelected: false))])
		await expect(self.sut.state).toEventually(equal(state))
	}
		
	@MainActor func test_store() async throws {
		
		// Given
		let organization = Generator.healthcareOrganization("value", useDataService: true)
		try createSut(list: [organization])
		sut.searchResultsList = [organization]
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
