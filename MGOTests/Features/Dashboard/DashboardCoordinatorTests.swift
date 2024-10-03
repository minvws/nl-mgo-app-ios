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

final class DashboardCoordinatorTests: XCTestCase {
	
	private var sut: DashboardCoordinator!
	private var parentCoordinator: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = AppCoordinatorSpy()
		sut = DashboardCoordinator(parentCoordinator: parentCoordinator)
	}
	
	// MARK: - Init -
	
	func test_init() {
		
		// Given
		
		// When
		
		// Then
		expect(self.servicesSpies.resourceRepositorySpy.invokedLoad) == true
	}
	
	// MARK: - Handle -
	
	func test_coordinatorHandle_addHealthcareOrganization_pathForSheet_shouldBeSet() {

		// Given
		
		// When
		sut.handle(Coordination.Action.addHealthcareOrganization)

		// Then
		expect(self.sut.rootStateForSheet) == DashboardCoordination.State.addHealthcareOrganization
	}

	func test_coordinatorHandle_search_pathForSheet_shouldContainHealthcareOrganizationSearchResults() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Roermond", "name": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")])
	}

	func test_coordinatorHandle_search_missingParams_pathForSheet_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Roermond", "wrong param": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_listHealthcareOrganizations_pathForSheet_shouldBeSet() {

		// Given
		
		// When
		sut.handle(Coordination.Action.listHealthcareOrganizations)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.listHealthcareOrganizations])
	}
	
	func test_coordinatorHandle_backToAddHealthcareOrganization_pathForSheet_shouldBeEmpty() {

		// Given
		sut.pathForSheet = NavigationStackBackport.NavigationPath([DashboardCoordination.State.listHealthcareOrganizations])
		
		// When
		sut.handle(Coordination.Action.backToAddHealthcareOrganization)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
	}

	func test_coordinatorHandle_finishedSearchingHealthcareOrganizations_pathForSheet_shouldBeEmpty_rootSheet_shouldBeEmpty() {

		// Given
		sut.rootStateForSheet = DashboardCoordination.State.addHealthcareOrganization
		sut.pathForSheet = NavigationStackBackport.NavigationPath([DashboardCoordination.State.listHealthcareOrganizations])
		
		// When
		sut.handle(Coordination.Action.finishedSearchingHealthcareOrganizations)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
		expect(self.sut.rootStateForSheet) == nil
	}

	func test_coordinatorHandle_closeSheet_pathForSheet_shouldBeEmpty_rootSheet_shouldBeEmpty() {

		// Given
		sut.rootStateForSheet = DashboardCoordination.State.addHealthcareOrganization
		sut.pathForSheet = NavigationStackBackport.NavigationPath([DashboardCoordination.State.listHealthcareOrganizations])
		
		// When
		sut.handle(Coordination.Action.closeSheet)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
		expect(self.sut.rootStateForSheet) == nil
	}
	
	func test_coordinatorHandle_backButtonPressed_pathForSheetNotEmpty_shouldBeReduced() {

		// Given
		sut.firstTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		sut.pathForSheet = NavigationStackBackport.NavigationPath(
			[DashboardCoordination.State.addHealthcareOrganization,
			 DashboardCoordination.State.listHealthcareOrganizations]
		)
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.addHealthcareOrganization])
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
	}
	
	func test_coordinatorHandle_backButtonPressed_pathForSheetEmpty_firstPath_shouldBeReduced() {

		// Given
		sut.firstTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		sut.pathForSheet = NavigationStackBackport.NavigationPath()
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)

		// Then
		expect(self.sut.pathForSheet.isEmpty) == true
		expect(self.sut.firstTabPath.isEmpty) == true
	}

	func test_coordinatorHandle_resetApplication_shouldCallParentCoordinator() {

		// Given
		sut.selectedTab = DashboardTab.about.rawValue
		
		// When
		sut.handle(Coordination.Action.resetApplication)

		// Then
		expect(self.parentCoordinator.invokedHandle).toEventually(beTrue())
		expect(self.parentCoordinator.invokedHandleParameters?.0) == Coordination.Action.resetApplication
		expect(self.sut.selectedTab) == DashboardTab.healthCategories.rawValue
	}
	
	func test_coordinatorHandle_showHealthcareOrganization_firstTabPath_shouldContainShowHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganization", params: ["healthcareOrganization": organization]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)])
	}

	func test_coordinatorHandle_showHealthcareOrganization_missingParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganization", params: [:]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showHealthcareOrganization_wrongParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganization", params: ["showHealthcareOrganization": "wrong"]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}

	func test_coordinatorHandle_showMedication_missingParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showMedication", params: [:]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showMedication_wrongParams_firstTabPath_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showMedication", params: ["showHealthcareOrganization": "wrong"]))

		// Then
		expect(self.sut.firstTabPath) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_removeHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")
		
		// When
		sut.handle(Coordination.Action(identifier: "removeHealthcareOrganization", params: ["healthcareOrganization": organization]))

		// Then
		expect(self.sut.rootStateForSheet) == DashboardCoordination.State.removeHealthcareOrganization(healthcareOrganization: organization)
	}
	
	func test_coordinatorHandle_removedHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")
		self.sut.rootStateForSheet = DashboardCoordination.State.removeHealthcareOrganization(healthcareOrganization: organization)
		self.sut.secondTabPath = NavigationStackBackport.NavigationPath([
			DashboardCoordination.State.overview,
			DashboardCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		])
		
		// When
		sut.handle(Coordination.Action.removedHealthcareOrganization)

		// Then
		expect(self.sut.rootStateForSheet) == nil
		expect(self.sut.secondTabPath) == NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
	}
	
	func test_switchTab_to1_shouldResetOtherTabs() {
		
		// Given
		sut.firstTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		expect(self.sut.firstTabPath.count) == 1
		
		// When
		sut.selectedTab = 1
		
		// Then
		expect(self.sut.firstTabPath.count) == 0
	}
	
	func test_switchTab_to2_shouldResetOtherTabs() {
		
		// Given
		sut.firstTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		sut.secondTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		expect(self.sut.firstTabPath.count) == 1
		expect(self.sut.secondTabPath.count) == 1
		
		// When
		sut.selectedTab = 2
		
		// Then
		expect(self.sut.firstTabPath.count) == 0
		expect(self.sut.secondTabPath.count) == 0
	}
	
	func test_switchTab_to0_shouldResetOtherTabs() {
		
		// Given
		sut.firstTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		sut.secondTabPath = NavigationStackBackport.NavigationPath([DashboardCoordination.State.overview])
		expect(self.sut.firstTabPath.count) == 1
		expect(self.sut.secondTabPath.count) == 1
		
		// When
		sut.selectedTab = 0
		
		// Then
		expect(self.sut.firstTabPath.count) == 1
		expect(self.sut.secondTabPath.count) == 0
	}
}
