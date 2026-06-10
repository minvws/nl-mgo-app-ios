/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import MGOUI
@testable import MGO

@MainActor
@Suite
struct DashboardCoordinatorTests {

	private let sut: DashboardCoordinator
	private let parentCoordinatorSpy: AppCoordinatorSpy
	private let servicesSpies: ServicesSpies

	init() {
		servicesSpies = setupServicesSpies()
		parentCoordinatorSpy = AppCoordinatorSpy()
		sut = DashboardCoordinator(parentCoordinator: parentCoordinatorSpy)
	}

	// MARK: - Handle -

	@Test("resetApplication resets children, selects first tab and bubbles to parent")
	func coordinatorHandle_resetApplication_resetsChildrenSelectsFirstTabAndBubbles() {

		// Given
		sut.selectedTab = DashboardTab.settings.rawValue
		sut.healthCategoriesCoordinator.handle(
			Coordination.Action(identifier: "showHealthCategory", params: ["category": Generator.healthCategory])
		)
		sut.healthCategoriesCoordinator.handle(Coordination.Action.addHealthcareOrganization)
		sut.healthcareOrganizationsCoordinator.handle(
			Coordination.Action(identifier: "showHealthCategory", params: ["category": Generator.healthCategory])
		)
		sut.healthcareOrganizationsCoordinator.handle(Coordination.Action.addHealthcareOrganization)
		#expect(!sut.healthCategoriesCoordinator.path.isEmpty)
		#expect(sut.healthCategoriesCoordinator.rootStateForSheet == HealthcareCoordination.State.manualLocalization)
		#expect(!sut.healthcareOrganizationsCoordinator.path.isEmpty)
		#expect(sut.healthcareOrganizationsCoordinator.rootStateForSheet == HealthcareCoordination.State.manualLocalization)

		// When
		sut.handle(Coordination.Action.resetApplication)

		// Then
		#expect(parentCoordinatorSpy.invokedHandle)
		#expect(parentCoordinatorSpy.invokedHandleParameters?.0 == Coordination.Action.resetApplication)
		#expect(sut.selectedTab == DashboardTab.healthCategories.rawValue)
		#expect(sut.healthCategoriesCoordinator.path.isEmpty)
		#expect(sut.healthCategoriesCoordinator.rootStateForSheet == nil)
		#expect(sut.healthcareOrganizationsCoordinator.path.isEmpty)
		#expect(sut.healthcareOrganizationsCoordinator.rootStateForSheet == nil)
	}

	// MARK: - handleTabSwitch -

	@Test("handleTabSwitch on the categories tab clears the categories coordinator path")
	func handleTabSwitch_categoriesTab_clearsCategoriesPath() {

		// Given
		let category = Generator.healthCategory
		sut.selectedTab = DashboardTab.healthCategories.rawValue
		sut.healthCategoriesCoordinator.handle(
			Coordination.Action(identifier: "showHealthCategory", params: ["category": category])
		)
		#expect(sut.healthCategoriesCoordinator.path == NavigationStackBackport.NavigationPath(
			[HealthcareCoordination.State.showHealthCategory(category: category, organization: nil)]
		))

		// When
		sut.handleTabSwitch()

		// Then
		#expect(sut.healthCategoriesCoordinator.path.isEmpty)
	}

	@Test("handleTabSwitch on the organizations tab clears the organizations coordinator path")
	func handleTabSwitch_organizationsTab_clearsOrganizationsPath() {

		// Given
		let category = Generator.healthCategory
		sut.selectedTab = DashboardTab.healthcareOrganizations.rawValue
		sut.healthcareOrganizationsCoordinator.handle(
			Coordination.Action(identifier: "showHealthCategory", params: ["category": category])
		)
		#expect(sut.healthcareOrganizationsCoordinator.path == NavigationStackBackport.NavigationPath(
			[HealthcareCoordination.State.showHealthCategory(category: category, organization: nil)]
		))

		// When
		sut.handleTabSwitch()

		// Then
		#expect(sut.healthcareOrganizationsCoordinator.path.isEmpty)
	}

	@Test("handleTabSwitch on the settings tab clears the settings coordinator path")
	func handleTabSwitch_settingsTab_clearsSettingsPath() {

		// Given
		sut.selectedTab = DashboardTab.settings.rawValue
		sut.settingsCoordinator.handle(Coordination.Action.showDisplaySettings)
		#expect(sut.settingsCoordinator.path == NavigationStackBackport.NavigationPath(
			[SettingsCoordination.State.displaySettings]
		))

		// When
		sut.handleTabSwitch()

		// Then
		#expect(sut.settingsCoordinator.path.isEmpty)
	}
}
