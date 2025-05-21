/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class HealthcareCoordinatorTests: XCTestCase {
	
	private var sut: HealthcareCoordinator!
	private var parentCoordinator: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = DashboardCoordinatorSpy()
		sut = HealthcareCoordinator(parentCoordinator: parentCoordinator, rootState: .showHealthCategories)
	}
	
	// MARK: - Handle -
	
	func test_coordinatorHandle_addHealthcareOrganization_pathForSheet_shouldBeSet() {

		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = true
		
		// When
		sut.handle(Coordination.Action.addHealthcareOrganization)

		// Then
		expect(self.sut.rootStateForSheet) == HealthcareCoordination.State.automaticLocalization
	}
	
	func test_coordinatorHandle_addHealthcareOrganization_pathForSheet_shouldBeSet_featureFlagOff() {

		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		
		// When
		sut.handle(Coordination.Action.addHealthcareOrganization)

		// Then
		expect(self.sut.rootStateForSheet) == HealthcareCoordination.State.manualLocalization
	}

	func test_coordinatorHandle_search_pathForSheet_shouldContainHealthcareOrganizationSearchResults() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Roermond", "name": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([HealthcareCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")])
	}

	func test_coordinatorHandle_search_missingParams_pathForSheet_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganizationSearchResults", params: ["city": "Roermond", "wrong param": "Tandarts Tandje Erbij"]))

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
	}

	func test_coordinatorHandle_finishedSearchingHealthcareOrganizations_pathForSheet_shouldBeEmpty_rootSheet_shouldBeEmpty() {

		// Given
		sut.rootStateForSheet = HealthcareCoordination.State.manualLocalization
		sut.pathForSheet = NavigationStackBackport.NavigationPath([HealthcareCoordination.State.automaticLocalization])
		
		// When
		sut.handle(Coordination.Action.finishedSearchingHealthcareOrganizations)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
		expect(self.sut.rootStateForSheet) == nil
	}

	func test_coordinatorHandle_closeSheet_pathForSheet_shouldBeEmpty_rootSheet_shouldBeEmpty() {

		// Given
		sut.rootStateForSheet = HealthcareCoordination.State.manualLocalization
		sut.pathForSheet = NavigationStackBackport.NavigationPath([HealthcareCoordination.State.automaticLocalization])
		
		// When
		sut.handle(Coordination.Action.closeSheet)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath()
		expect(self.sut.rootStateForSheet) == nil
	}
	
	func test_coordinatorHandle_backButtonPressed_pathForSheetNotEmpty_shouldBeReduced() {

		// Given
		sut.path = NavigationStackBackport.NavigationPath([HealthcareCoordination.State.showHealthCategories])
		sut.pathForSheet = NavigationStackBackport.NavigationPath(
			[HealthcareCoordination.State.manualLocalization,
			 HealthcareCoordination.State.automaticLocalization]
		)
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)

		// Then
		expect(self.sut.pathForSheet) == NavigationStackBackport.NavigationPath([HealthcareCoordination.State.manualLocalization])
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([HealthcareCoordination.State.showHealthCategories])
	}
	
	func test_coordinatorHandle_backButtonPressed_pathForSheetEmpty_path_shouldBeReduced() {

		// Given
		sut.path = NavigationStackBackport.NavigationPath([HealthcareCoordination.State.organizations])
		sut.pathForSheet = NavigationStackBackport.NavigationPath()
		
		// When
		sut.handle(Coordination.Action.backButtonPressed)

		// Then
		expect(self.sut.pathForSheet.isEmpty) == true
		expect(self.sut.path.isEmpty) == true
	}
	
	func test_coordinatorHandle_showHealthcareOrganization_path_shouldContainShowHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganization", params: ["healthcareOrganization": organization]))

		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([HealthcareCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)])
	}

	func test_coordinatorHandle_showHealthcareOrganization_missingParams_path_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganization", params: [:]))

		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showHealthcareOrganization_wrongParams_path_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganization", params: ["showHealthcareOrganization": "wrong"]))

		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath()
	}

	func test_coordinatorHandle_showMedication_missingParams_path_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showMedication", params: [:]))

		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showMedication_wrongParams_path_shouldBeEmpty() {

		// Given
		
		// When
		sut.handle(Coordination.Action(identifier: "showMedication", params: ["showHealthcareOrganization": "wrong"]))

		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_removeHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")
		
		// When
		sut.handle(Coordination.Action(identifier: "removeHealthcareOrganization", params: ["healthcareOrganization": organization]))

		// Then
		expect(self.sut.rootStateForSheet) == HealthcareCoordination.State.removeHealthcareOrganization(healthcareOrganization: organization)
	}
	
	func test_coordinatorHandle_removedHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")
		self.sut.rootStateForSheet = HealthcareCoordination.State.removeHealthcareOrganization(healthcareOrganization: organization)
		self.sut.path = NavigationStackBackport.NavigationPath([
			HealthcareCoordination.State.organizations,
			HealthcareCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		])
		
		// When
		sut.handle(Coordination.Action.removedHealthcareOrganization)

		// Then
		expect(self.sut.rootStateForSheet) == nil
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([HealthcareCoordination.State.organizations])
	}
	
	func test_coordinatorHandle_showHealthCategory() {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let category = HealthCategories.Category.medication
	
		// When
		sut.handle(Coordination.Action(identifier: "showHealthCategory", params: ["category": category, "healthcareOrganization": organization]))
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([HealthcareCoordination.State.showHealthCategory(category: category, organization: organization)])
	}
	
	func test_coordinatorHandle_showHealthCategory_withoutOrganization() {
		
		// Given
		let category = HealthCategories.Category.medication
	
		// When
		sut.handle(Coordination.Action(identifier: "showHealthCategory", params: ["category": category]))
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([HealthcareCoordination.State.showHealthCategory(category: category, organization: nil)])
	}
	
	func test_coordinatorHandle_showHealthCategory_invalidParam() {
		
		// Given
	
		// When
		sut.handle(Coordination.Action(identifier: "showHealthCategory", params: ["param": "wrong"]))
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath()
	}
	
	func test_coordinatorHandle_showHealthCategoryData() {
		
		// Given
		let heading = "showHealthData"
		let schema = HealthUISchema(children: [], label: "test")
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthData", params: ["resource": Data(), "backButtonTitle": heading, "uiSchema": schema, "healthcareOrganization": Generator.healthcareOrganization("1")]))
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath([HealthcareCoordination.State.showHealthData(backButtonTitle: heading, schema: schema, organization: Generator.healthcareOrganization("1"))])
	}
	
	func test_coordinatorHandle_showHealthCategoryData_missingParam() {
		
		// Given
		let heading = "showHealthData"
		let schema = HealthUISchema(children: [], label: "test")
		
		// When
		sut.handle(Coordination.Action(identifier: "showHealthData", params: ["backButtonTitle": heading, "uiSchema": schema]))
		
		// Then
		expect(self.sut.path) == NavigationStackBackport.NavigationPath()
	}
}
