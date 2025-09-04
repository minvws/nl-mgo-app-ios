/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class DashboardCoordinatorTests: XCTestCase {
	
	private var sut: DashboardCoordinator!
	private var parentCoordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		super.setUp()
	}
	
	@MainActor private func createSut() {
		
		parentCoordinatorSpy = AppCoordinatorSpy()
		sut = DashboardCoordinator(parentCoordinator: parentCoordinatorSpy)
	}

	@MainActor func test_handleResetApplication() throws {
		
		// Given
		createSut()
		sut.selectedTab = DashboardTab.settings.rawValue
		
		// When
		sut.handle(.resetApplication)
		
		// Then
		expect(self.parentCoordinatorSpy.invokedHandle) == true
		expect(self.parentCoordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.resetApplication
		expect(self.sut.selectedTab) == DashboardTab.healthCategories.rawValue
	}
	
	@MainActor func test_handleTabSwitch_categories() throws {
		
		// Given
		createSut()
		let category = Generator.healthCategory
		sut.selectedTab = DashboardTab.healthCategories.rawValue
		sut.healthCategoriesCoordinator.handle(
			Coordination.Action(
				identifier: "showHealthCategory",
				params: ["category": category]
			)
		)
		expect(self.sut.healthCategoriesCoordinator.path) == NavigationStackBackport.NavigationPath(
			[
				HealthcareCoordination.State.showHealthCategory(
					category: category,
					organization: nil
				)
			]
		)
		
		// When
		sut.handleTabSwitch()
		
		// Then
		expect(self.sut.healthCategoriesCoordinator.path.isEmpty) == true
	}
	
	@MainActor func test_handleTabSwitch_organizations() throws {
		
		// Given
		createSut()
		let category = Generator.healthCategory
		sut.selectedTab = DashboardTab.healthcareOrganizations.rawValue
		sut.healthcareOrganizationsCoordinator.handle(
			Coordination.Action(
				identifier: "showHealthCategory",
				params: ["category": category]
			)
		)
		expect(self.sut.healthcareOrganizationsCoordinator.path) == NavigationStackBackport.NavigationPath(
			[
				HealthcareCoordination.State.showHealthCategory(
					category: category,
					organization: nil
				)
			]
		)
		
		// When
		sut.handleTabSwitch()
		
		// Then
		expect(self.sut.healthcareOrganizationsCoordinator.path.isEmpty) == true
	}
	
	@MainActor func test_handleTabSwitch_settings() throws {

		// Given
		createSut()
		sut.selectedTab = DashboardTab.settings.rawValue
		sut.settingsCoordinator.handle(Coordination.Action.showDisplaySettings)
		expect(self.sut.settingsCoordinator.path) == NavigationStackBackport.NavigationPath([SettingsCoordination.State.displaySettings])
		
		// When
		sut.handleTabSwitch()
		
		// Then
		expect(self.sut.settingsCoordinator.path.isEmpty) == true
	}
}
