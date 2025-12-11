/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthCategoriesViewModelTests: XCTestCase {

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
	
	@MainActor private func createSut() {
		
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .single(healthcareOrganization))
	}
	
	@MainActor func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	@MainActor func test_categorySelected_shouldCallCoordinator() throws {
		
		// Given
		createSut()
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "measurements"))
		
		// When
		sut.reduce(.categorySelected(category))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthCategory.identifier
		expect(params.params["category"] as? SharedHealthCategories.Category) == category
		expect(params.params["healthcareOrganization"]) != nil
	}
	
	@MainActor func test_removeHealthcareOrganization_shouldCallCoordinator() throws {
		
		// Given
		createSut()
		
		// When
		sut.reduce(.removeHealthcareOrganization)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.removeHealthcareOrganization.identifier
		expect(params.params["healthcareOrganization"]) != nil
	}
	
	@MainActor func test_loadMedication_withData() throws {
		
		// Given
		createSut()
		let resource = try getResource("zibMedicationUse")
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [resource],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.loaded), timeout: .seconds(5))
	}
	
	@MainActor func test_loadMedication_withServerErrorData() throws {
		
		// Given
		createSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: ResourceRepositoryError.server.rawValue
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		expect(self.sut.state.buttonState["medication"]) == .loading
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.serverError), timeout: .seconds(5))
	}
	
	@MainActor func test_loadMedication_withClientErrorData() throws {
		
		// Given
		createSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: ResourceRepositoryError.client.rawValue
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		expect(self.sut.state.buttonState["medication"]) == .loading
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.clientError), timeout: .seconds(5))
	}
	
	@MainActor func test_loadMedication_emptyData_stateShouldBeEmpty() throws {
		
		// Given
		createSut()
		let mgoResource = MgoResourceRecord(
			categoryId: "medication",
			organizationId: healthcareOrganization.identifier,
			resources: [],
			error: false
		)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
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
		createSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(DataStoreError.noData)
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.loading))
	}
	
	@MainActor func test_loadMedication_dataError_stateShouldBeError() throws {
		
		// Given
		createSut()
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(NSError(domain: "test_loadMedication_dataError_stateShouldBeEmpty", code: 404))
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.buttonState["medication"]).toEventually(equal(.serverError))
	}
	
	@MainActor func test_refresh() {
		
		// Given
		createSut()
		expect(self.sut.state.buttonState["medication"]) == .loading
	
		// When
		sut.reduce(.refresh)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == true
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveAllRecords) == false
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadCount) == 0
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForMgoOrganizationCount) == 1
	}
	
	@MainActor func test_retry() {
		
		// Given
		createSut()
		self.sut.state.buttonState["medication"] = .clientError
		
		// When
		sut.reduce(.retry)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == false
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveAllRecords) == false
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecordsFor) == true
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadCount) == 0
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForMgoOrganizationCount) == 0
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForSharedHealthCategoriesCategoriesCount) == 0
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadResourceCount) == 1
	}
	
	@MainActor func test_showFavorites_modeAll_shouldCallCoordinator() {
		
		// Given
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
	
		// When
		sut.reduce(HealthCategoriesViewModel.Action.showFavorites)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showFavorites
	}
	
	@MainActor func test_showFavorites_modeSingle_shouldNotCallCoordinator() {
		
		// Given
		createSut()
	
		// When
		sut.reduce(HealthCategoriesViewModel.Action.showFavorites)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
}
