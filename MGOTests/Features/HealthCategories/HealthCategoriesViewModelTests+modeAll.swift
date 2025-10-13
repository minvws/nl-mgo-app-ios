/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthCategoriesViewModelModeAllTests: XCTestCase {

	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var healthcareOrganization: MgoOrganization!
	private var sut: HealthCategoriesViewModel!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
	}
	
	@MainActor private func setupSut() {
		
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
	}
	
	@MainActor func test_categorySelected_shouldCallCoordinator() throws {
		
		// Given
		setupSut()
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "measurements"))
		
		// When
		sut.reduce(.categorySelected(category))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthCategory.identifier
		expect(params.params["category"] as? SharedHealthCategories.Category) == category
		expect(params.params["healthcareOrganization"]) == nil
	}
	
	@MainActor func test_loadMedication_withData() throws {
		
		// Given
		setupSut()
		let resource = try getResource("zibMedicationUse")
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [resource],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.loaded))
	}
	
	@MainActor func test_loadMedication_emptyData_stateShouldBeEmpty() throws {
		
		// Given
		setupSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.empty))
	}
	
	@MainActor func test_loadMedication_noData_stateShouldBeLoading() throws {
		
		// Given
		setupSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .failure(DataStoreError.noData)
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.loading))
	}
	
	@MainActor func test_loadMedication_dataError_stateShouldBeEmpty() throws {
		
		// Given
		setupSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .failure(NSError(domain: "test_loadMedication_cacheMiss_dataError", code: 404))
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.empty), timeout: .seconds(5))
	}
	
	@MainActor func test_refresh() {
		
		// Given
		setupSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([])
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.refresh)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == false
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveAllRecords) == true
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadCount) == 1
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForMgoOrganizationCount) == 0
	}
	
	@MainActor func test_searchButtonPressed_shouldCallCoordinator() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.addHealthcareOrganization
	}
	
	@MainActor func test_emptyState_withOrganizations() {
		
		// Given
		setupSut()
		
		// When
		
		// Then
		expect(self.sut.state.showEmptyView) == false
	}
	
	@MainActor func test_emptyState_withoutOrganizations() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		
		// When
		
		// Then
		expect(self.sut.state.showEmptyView) == true
	}
	
	@MainActor func test_observe_favoriteRepository() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		expect(self.sut.state.favorites).to(beEmpty())
		
		// When
		try Container.shared.favoritesRepository().store(Generator.healthCategory)
		
		// Then
		expect(self.sut.state.favorites).toEventuallyNot(beEmpty())
		Container.shared.favoritesRepository().wipePersistedData()
	}
	
	@MainActor func test_observe_healthcareOrganizationRepository() throws {
	
		// Given
		Container.shared.healthcareOrganizationRepository
			.register { HealthcareOrganizationRepository() }
		let healthcareOrganizationRepository = Container.shared.healthcareOrganizationRepository()
		
		healthcareOrganizationRepository.wipePersistedData()
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		expect(self.sut.state.showEmptyView) == true
		
		// When
		try healthcareOrganizationRepository
			.store(Generator.healthcareOrganization("1"))
		
		// Then
		expect(self.sut.state.showEmptyView).toEventually(beFalse())
		healthcareOrganizationRepository.wipePersistedData()
	}
	
	@MainActor func test_observe_dataStore() throws {
		
		// Given
		Container.shared.dataStore
			.register { InMemoryDataStore() }
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		sut.state.buttonState = [:]
		
		// When
		Container.shared.dataStore().observatory.notifyObservers(newValue: true)
		
		// Then
		expect(self.sut.state.buttonState).toEventuallyNot(beEmpty())
	}
}
