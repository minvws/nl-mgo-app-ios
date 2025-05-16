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
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
	}
	
	func test_categorySelected_shouldCallCoordinator_whenStateIsLoaded() throws {
		
		// Given
		let button = CategoryButton(category: HealthCategories.Category.measurements, title: "test", state: .loaded, box: 1)
		
		// When
		sut.reduce(.categorySelected(button))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthCategory.identifier
		expect(params.params["category"] as? HealthCategories.Category) == HealthCategories.Category.measurements
		expect(params.params["healthcareOrganization"]) == nil
	}
	
	func test_categorySelected_shouldCallCoordinator_whenStateIsEmpty() throws {
		
		// Given
		let button = CategoryButton(category: HealthCategories.Category.measurements, title: "test", state: .empty, box: 1)
		
		// When
		sut.reduce(.categorySelected(button))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthCategory.identifier
		expect(params.params["category"] as? HealthCategories.Category) == HealthCategories.Category.measurements
		expect(params.params["healthcareOrganization"]) == nil
	}
	
	func test_categorySelected_shouldCallCoordinator_whenStateIsLoading() throws {
		
		// Given
		let button = CategoryButton(id: HealthCategories.Category.measurements.rawValue, title: "test", state: .loading, box: 1)
		
		// When
		sut.reduce(.categorySelected(button))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showHealthCategory.identifier
		expect(params.params["category"] as? HealthCategories.Category) == HealthCategories.Category.measurements
		expect(params.params["healthcareOrganization"]) == nil
	}
	
	func test_loadMedication_withData() throws {
		
		// Given
		let resource = try getResource("zibMedicationUse")
		let mgoResource = MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.healthCategories.first?.state).toEventually(equal(.loaded))
	}
	
	func test_loadMedication_emptyData_stateShouldBeEmpty() throws {
		
		// Given
		let mgoResource = MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: false)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.healthCategories.first?.state).toEventually(equal(.empty))
	}
	
	func test_loadMedication_noData_stateShouldBeLoading() throws {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .failure(DataStoreError.noData)
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.healthCategories.first?.state).toEventually(equal(.loading))
	}
	
	func test_loadMedication_dataError_stateShouldBeEmpty() throws {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .failure(NSError(domain: "test_loadMedication_cacheMiss_dataError", code: 404))
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.healthCategories.first?.state).toEventually(equal(.empty), timeout: .seconds(5))
	}
	
	func test_refresh() {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([])
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.refresh)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == false
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveAllRecords) == true
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadCount) == 1
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForMgoOrganizationCount) == 0
	}
	
	func test_searchButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.addHealthcareOrganization
	}
	
	func test_emptyState_withOrganizations() {
		
		// Given
		
		// When
		
		// Then
		expect(self.sut.state.showEmptyView) == false
	}
	
	func test_emptyState_withoutOrganizations() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
	// When
	
	// Then
		expect(self.sut.state.showEmptyView) == true
	}
}
