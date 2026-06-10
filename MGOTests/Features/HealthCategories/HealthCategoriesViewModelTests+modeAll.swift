/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import MGOUI
@testable import MGO

@MainActor
@Suite(.serialized)
struct HealthCategoriesViewModelModeAllTests {
	
	private let coordinatorSpy: DashboardCoordinatorSpy
	private let servicesSpies: ServicesSpies
	private let healthcareOrganization: OrganizationSearch.Organization
	
	init() {
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
	}
	
	private func makeSut() -> HealthCategoriesViewModel {
		HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
	}
	
	@Test("Selecting a category in .all mode omits the organization param")
	func categorySelected_shouldCallCoordinator() throws {
		
		// Given
		let sut = makeSut()
		let sharedCategories = try SharedHealthCategories()
		let category = try #require(sharedCategories.findCategory(id: "measurements"))
		
		// When
		sut.reduce(.categorySelected(category))
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		let params = try #require(coordinatorSpy.invokedHandleParameters?.0)
		#expect(params.identifier == Coordination.Action.showHealthCategory.identifier)
		#expect(params.params["category"] as? SharedHealthCategories.Category == category)
		#expect(params.params["healthcareOrganization"] == nil)
	}
	
	@Test("onAppear with full medication data sets state to .loaded")
	func loadMedication_withData() async throws {
		
		// Given
		let sut = makeSut()
		let resource = try getResource("zibMedicationUse")
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [resource],
			error: nil
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .loaded)
	}
	
	@Test("onAppear with server-error records sets state to .serverError")
	func loadMedication_withServerErrorData() async throws {
		
		// Given
		let sut = makeSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: ResourceRepositoryError.server.rawValue
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .serverError)
	}
	
	@Test("onAppear with client-error records sets state to .clientError")
	func loadMedication_withClientErrorData() async throws {
		
		// Given
		let sut = makeSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: ResourceRepositoryError.client.rawValue
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .clientError)
	}
	
	@Test("onAppear with empty resource records sets state to .empty")
	func loadMedication_emptyData_stateShouldBeEmpty() async throws {
		
		// Given
		let sut = makeSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: nil
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .empty)
	}
	
	@Test("onAppear with .noData failure keeps state as .loading")
	func loadMedication_noData_stateShouldBeLoading() async throws {
		
		// Given
		let sut = makeSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .failure(DataStoreError.noData)
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .loading)
	}
	
	@Test("onAppear with arbitrary data-store error sets state to .serverError")
	func loadMedication_dataError_stateShouldBeError() async throws {
		
		// Given
		let sut = makeSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .failure(NSError(domain: "test_loadMedication_cacheMiss_dataError", code: 404))
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.onAppear)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.buttonState["medication"] == .serverError)
	}
	
	@Test("Refresh in .all mode wipes all records and reloads everything")
	func refresh() {
		
		// Given
		let sut = makeSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([])
		#expect(sut.state.buttonState["medication"] == .loading)
		
		// When
		sut.reduce(.refresh)
		
		// Then
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecords == false)
		#expect(servicesSpies.dataStoreSpy.invokedRemoveAllRecords == true)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadCount == 1)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadForOrganizationCount == 0)
	}
	
	@Test("Retry in .all mode reloads only the faulty categories")
	func retry() {
		
		// Given
		let sut = makeSut()
		sut.state.buttonState["medication"] = .clientError
		
		// When
		sut.reduce(.retry)
		
		// Then
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecords == false)
		#expect(servicesSpies.dataStoreSpy.invokedRemoveAllRecords == false)
		#expect(servicesSpies.dataStoreSpy.invokedRemoveRecordsFor == true)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadCount == 0)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadForOrganizationCount == 0)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadForSharedHealthCategoriesCategoriesCount == 1)
		#expect(servicesSpies.resourceRepositorySpy.invokedLoadResourceCount == 0)
	}
	
	@Test("Search button routes to add-organization action")
	func searchButtonPressed_shouldCallCoordinator() {
		
		// Given
		let sut = makeSut()
		
		// When
		sut.reduce(.search)
		
		// Then
		#expect(coordinatorSpy.invokedHandle == true)
		#expect(coordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.addHealthcareOrganization)
	}
	
	@Test("Empty view is hidden when organizations are present")
	func emptyState_withOrganizations() {
		
		// Given
		let sut = makeSut()
		
		// Then
		#expect(sut.state.showEmptyView == false)
	}
	
	@Test("Empty view is shown when no organizations are stored")
	func emptyState_withoutOrganizations() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		let sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		
		// Then
		#expect(sut.state.showEmptyView == true)
	}
	
	@Test("Storing a favorite updates state.favorites via repository observer")
	func observe_favoriteRepository() async throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		let sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		#expect(sut.state.favorites.isEmpty)
		
		// When
		try Container.shared.favoritesRepository().store(Generator.healthCategory)
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(!sut.state.favorites.isEmpty)
		Container.shared.favoritesRepository().wipePersistedData()
	}
	
	@Test("Storing an organization flips showEmptyView via repository observer")
	func observe_healthcareOrganizationRepository() async throws {
		
		// Given
		let repo = try HealthcareOrganizationRepository()
		Container.shared.healthcareOrganizationRepository
			.register { repo }
		let healthcareOrganizationRepository = Container.shared.healthcareOrganizationRepository()
		
		healthcareOrganizationRepository.wipePersistedData()
		let sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		#expect(sut.state.showEmptyView == true)
		
		// When
		try healthcareOrganizationRepository.store(Generator.healthcareOrganization("1"))
		await Task.yield()
		await Task.yield()
		
		// Then
		#expect(sut.state.showEmptyView == false)
		healthcareOrganizationRepository.wipePersistedData()
	}
	
	@Test("Data-store change notifications trigger button state updates")
	func observe_dataStore() async throws {
		
		// Given
		Container.shared.dataStore
			.register { InMemoryDataStore() }
		let sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		sut.state.buttonState = [:]
		
		// When
		Container.shared.dataStore().observatory.notifyObservers(newValue: true)
		// The data-store observer debounces via a 150ms sleep before applying updates.
		try await Task.sleep(nanoseconds: 250_000_000)
		
		// Then
		#expect(!sut.state.buttonState.isEmpty)
	}
}
