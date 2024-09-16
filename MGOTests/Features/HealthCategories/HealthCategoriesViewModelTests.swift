/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
	
	func test_categorySelected_shouldCallCoordinator() throws {
		
		// Given
		let button = CategoryButton(id: 3, title: "test", state: .loaded)
		
		// When
		sut.reduce(.categorySelected(button))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.showCategoryOverview.identifier
		expect(params.params["categoryId"]) == AnyHashable(3)
		expect(params.params["healthcareOrganization"]) != nil
	}

	func test_categorySelected_invalidState_shouldNotCallCoordinator() {

		// Given
		let button = CategoryButton(id: 3, title: "test", state: .loading)
		
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
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource])]
		)
		expect(self.sut.state.healthCategories.first?.state) == .loading
	
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state.healthCategories.first?.state).toEventually(equal(.loaded))
	}
	
	func test_loadMedication_emptyData_stateShouldBeEmpty() throws {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.medication.rawValue)", organizationId: healthcareOrganization.identifier, resources: [])]
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
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoadForCount) == 1
	}
}
