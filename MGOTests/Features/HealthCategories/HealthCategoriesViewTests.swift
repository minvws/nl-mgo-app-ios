/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthCategoriesViewTests: XCTestCase {

	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var healthcareOrganization: MgoOrganization!
	private var viewModel: HealthCategoriesViewModel!
	private var sut: HealthCategoriesView!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .single(healthcareOrganization))
		sut = HealthCategoriesView(viewModel: self.viewModel)
	}
	
	func test_initialState_singleMode() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_initialState_singleMode_belowIOS18() {
		
		// Given
		sut.viewModel.state.belowIOS18 = true
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_initialState_multipleMode() {
		
		// Given
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([])
		sut = HealthCategoriesView(viewModel: self.viewModel)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
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
	
	func test_removeOrganization() throws {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		let view = try content.inspect().find(viewWithAccessibilityIdentifier: "organizations.remove_organization")
		try view.view(CallToActionButton.self).find(button: "organizations.remove_organization").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		let params = try XCTUnwrap(self.coordinatorSpy.invokedHandleParameters?.0)
		expect(params.identifier) == Coordination.Action.removeHealthcareOrganization.identifier
	}
	
	func test_addHealthcareOrganization_noOrganizations() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		sut = HealthCategoriesView(viewModel: self.viewModel)
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.add_organizations")
		try view.view(CallToActionButton.self).find(button: "common.add_organizations").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.addHealthcareOrganization
	}
	
	func test_noOrganizations_automaticLocalizationEnabled() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = true
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		sut = HealthCategoriesView(viewModel: self.viewModel)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_noOrganizations_automaticLocalizationDisabled() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		sut = HealthCategoriesView(viewModel: self.viewModel)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
}
