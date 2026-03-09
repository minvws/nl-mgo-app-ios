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
	}
	
	@MainActor private func createSut() {
		
		viewModel = HealthCategoriesViewModel(
			coordinator: coordinatorSpy,
			mode: .single(healthcareOrganization)
		)
		sut = HealthCategoriesView(viewModel: self.viewModel)
	}
	
	@MainActor func test_initialState_singleMode() {
		
		// Given
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_initialState_singleMode_belowIOS18() {
		
		// Given
		createSut()
		viewModel.state.belowIOS18 = true
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_initialState_multipleMode() {
		
		// Given
		createSut()
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([])
		sut = HealthCategoriesView(viewModel: self.viewModel)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_initialState_multipleMode_withFavorite() throws {
		
		// Given
		try Container.shared.favoritesRepository().store(Generator.healthCategory)
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([])
		sut = HealthCategoriesView(viewModel: self.viewModel)
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
		Container.shared.favoritesRepository().wipePersistedData()
	}
	
	@MainActor func test_backbuttonPressed() throws {
		
		// Given
		createSut()
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	@MainActor func test_addHealthcareOrganization_noOrganizations() throws {
		
		// Given
		createSut()
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
	
	@MainActor func test_noOrganizations() throws {

		// Given
		createSut()
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		sut = HealthCategoriesView(viewModel: self.viewModel)

		// When
		let content = NavigationStackBackport.NavigationStack { sut }

		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	@MainActor func test_showFavorites() throws {
		
		// Given
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([])
		sut = HealthCategoriesView(viewModel: self.viewModel)
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "overview_favorites_action_add")
		try view.button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showFavorites
		
	}
	
	@MainActor func test_editFavorites() throws {
		
		// Given
		try Container.shared.favoritesRepository().store(Generator.healthCategory)
		viewModel = HealthCategoriesViewModel(coordinator: coordinatorSpy, mode: .all)
		servicesSpies.dataStoreSpy.stubbedGetCategoryIdResult = .success([])
		sut = HealthCategoriesView(viewModel: self.viewModel)
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "overview_favorites_action_edit")
		try view.button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showFavorites
		Container.shared.favoritesRepository().wipePersistedData()
	}
	
	@MainActor func test_toolbar() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
}
