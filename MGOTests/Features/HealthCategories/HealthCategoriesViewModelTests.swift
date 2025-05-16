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
		sut = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .single(healthcareOrganization))
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
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
		expect(params.params["healthcareOrganization"]) != nil
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
		expect(params.params["healthcareOrganization"]) != nil
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
		expect(params.params["healthcareOrganization"]) != nil
	}
	
	func test_categorySelected_shouldNotCallCoordinator_whenCategoryIsInvalid() {

		// Given
		let button = CategoryButton(id: 9999, title: "test", state: .loaded, box: 1)
		
		// When
		sut.reduce(.categorySelected(button))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
	}
	
	func test_removeHealthcareOrganization_shouldCallCoordinator() throws {
		
		// Given
		
		// When
		sut.reduce(.removeHealthcareOrganization)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.removeHealthcareOrganization.identifier
		expect(params.params["healthcareOrganization"]) != nil
	}
	
	func test_loadMedication_withData() throws {
		
		// Given
		let resource = try getResource("zibMedicationUse")
		let mgoResource = MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource], error: false)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
			[mgoResource, mgoResource, mgoResource, mgoResource]
		)
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.healthCategories.first?.state).toEventually(equal(.loaded), timeout: .seconds(5))
	}
	
	func test_loadMedication_emptyData_stateShouldBeEmpty() throws {
		
		// Given
		let mgoResource = MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [], error: false)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .success(
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
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(DataStoreError.noData)
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.healthCategories.first?.state).toEventually(equal(.loading))
	}
	
	func test_loadMedication_dataError_stateShouldBeEmpty() throws {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdOrganizationIdResult = .failure(NSError(domain: "test_loadMedication_cacheMiss_dataError", code: 404))
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.healthCategories.first?.state).toEventually(equal(.empty))
	}
	
	func test_refresh() {
		
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.refresh)
		
		// Then
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == true
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveAllRecords) == false
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadCount) == 0
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForMgoOrganizationCount) == 1
	}
}
