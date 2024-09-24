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

final class AlertsHealthCategoryViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: HealthCategoryViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var sut: HealthCategoryView!

	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		viewModel = AlertsHealthCategoryViewModel(
			coordinator: coordinatorSpy,
			organizationId: healthcareOrganization.identifier)
		sut = HealthCategoryView(viewModel: self.viewModel)
	}

	func test_stateLoading() {
		
		// Given
		viewModel.state = .loading
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_stateEmpty() {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.alerts.rawValue)", organizationId: healthcareOrganization.identifier, resources: [])]
		)
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.reduce(.onAppear)
		
		// Then
		expect(self.viewModel.state).toEventuallyNot(equal(.loading))
		takeSnapShots(content: content)
	}
	
	func test_stateFailure() {
		
		// Given
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .failure(DataStoreError.noData)
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.reduce(.onAppear)
		
		// Then
		takeSnapShots(content: content)
	}

	func test_stateList() throws {
		
		// Given
		let resource = try getResource("zibAlert")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.alerts.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource])]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		let content = NavigationView { sut }
		
		// When
		sut.viewModel.reduce(.onAppear)
		
		// Then
		expect(self.viewModel.state).toEventuallyNot(equal(.loading))
		takeSnapShots(content: content)
	}

	func test_backbuttonPressed() throws {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_search_itemNotFound() throws {
		
		// Given
		let resource = try getResource("zibAlert")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.alerts.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource])]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		let content = NavigationView { sut }
		sut.viewModel.reduce(.onAppear)
		
		// When
		viewModel.searchText = "alerts"
		
		// Then
		expect(self.viewModel.state).toEventuallyNot(equal(.loading))
		takeSnapShots(content: content)
	}
	
	func test_search_itemFound() throws {
		
		// Given
		let resource = try getResource("zibAlert")
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([
			MgoResourceRecord(categoryId: "\(HealthCategories.Category.alerts.rawValue)", organizationId: healthcareOrganization.identifier, resources: [resource])]
		)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		let content = NavigationView { sut }
		sut.viewModel.reduce(.onAppear)
		
		// When
		viewModel.searchText = "alert"
		
		// Then
		expect(self.viewModel.state).toEventuallyNot(equal(.loading))
		takeSnapShots(content: content)
	}
}
