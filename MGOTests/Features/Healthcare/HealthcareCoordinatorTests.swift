/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

@MainActor
@Suite
struct HealthcareCoordinatorTests {

	private let sut: HealthcareCoordinator
	private let parentCoordinator: DashboardCoordinatorSpy
	private let servicesSpies: ServicesSpies

	init() {
		servicesSpies = setupServicesSpies()
		parentCoordinator = DashboardCoordinatorSpy()
		sut = HealthcareCoordinator(
			parentCoordinator: parentCoordinator,
			rootState: .showHealthCategories
		)
	}

	// MARK: - Handle -

	@Test("addHealthcareOrganization sets sheet path to manualLocalization")
	func coordinatorHandle_addHealthcareOrganization_pathForSheet_shouldBeSet() {

		// Given

		// When
		sut.handle(Coordination.Action.addHealthcareOrganization)

		// Then
		#expect(sut.rootStateForSheet == HealthcareCoordination.State.manualLocalization)
	}

	@Test("closeSheet clears path and root state for sheet")
	func coordinatorHandle_closeSheet_pathForSheet_shouldBeEmpty_rootSheet_shouldBeEmpty() {

		// Given
		sut.rootStateForSheet = HealthcareCoordination.State.manualLocalization
		sut.pathForSheet = NavigationStackBackport.NavigationPath(
			[HealthcareCoordination.State.manualLocalization]
		)

		// When
		sut.handle(Coordination.Action.closeSheet)

		// Then
		#expect(sut.pathForSheet == NavigationStackBackport.NavigationPath())
		#expect(sut.rootStateForSheet == nil)
	}

	@Test("backButtonPressed removes last item from sheet path when sheet path is non-empty")
	func coordinatorHandle_backButtonPressed_pathForSheetNotEmpty_shouldBeReduced() {

		// Given
		sut.path = NavigationStackBackport.NavigationPath([HealthcareCoordination.State.showHealthCategories])
		sut.pathForSheet = NavigationStackBackport.NavigationPath(
			[HealthcareCoordination.State.manualLocalization,
			 HealthcareCoordination.State.manualLocalization]
		)

		// When
		sut.handle(Coordination.Action.backButtonPressed)

		// Then
		#expect(sut.pathForSheet == NavigationStackBackport.NavigationPath(
			[HealthcareCoordination.State.manualLocalization]
		))
		#expect(sut.path == NavigationStackBackport.NavigationPath(
			[HealthcareCoordination.State.showHealthCategories]
		))
	}

	@Test("backButtonPressed removes last item from main path when sheet path is empty")
	func coordinatorHandle_backButtonPressed_pathForSheetEmpty_path_shouldBeReduced() {

		// Given
		sut.path = NavigationStackBackport.NavigationPath([HealthcareCoordination.State.organizations])
		sut.pathForSheet = NavigationStackBackport.NavigationPath()

		// When
		sut.handle(Coordination.Action.backButtonPressed)

		// Then
		#expect(sut.pathForSheet.isEmpty)
		#expect(sut.path.isEmpty)
	}

	@Test("showHealthcareOrganization pushes organization onto path")
	func coordinatorHandle_showHealthcareOrganization_path_shouldContainShowHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showHealthcareOrganization",
				params: ["healthcareOrganization": organization]
			)
		)

		// Then
		#expect(sut.path == NavigationStackBackport.NavigationPath(
			[
				HealthcareCoordination.State.showHealthcareOrganization(
					healthcareOrganization: organization
				)
			]
		))
	}

	@Test("showHealthcareOrganization with missing params leaves path empty")
	func coordinatorHandle_showHealthcareOrganization_missingParams_path_shouldBeEmpty() {

		// Given

		// When
		sut.handle(Coordination.Action(identifier: "showHealthcareOrganization", params: [:]))

		// Then
		#expect(sut.path.isEmpty)
	}

	@Test("showHealthcareOrganization with wrong params leaves path empty")
	func coordinatorHandle_showHealthcareOrganization_wrongParams_path_shouldBeEmpty() {

		// Given

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showHealthcareOrganization",
				params: ["showHealthcareOrganization": "wrong"]
			)
		)

		// Then
		#expect(sut.path.isEmpty)
	}

	@Test("showMedication with missing params leaves path empty")
	func coordinatorHandle_showMedication_missingParams_path_shouldBeEmpty() {

		// Given

		// When
		sut.handle(Coordination.Action(identifier: "showMedication", params: [:]))

		// Then
		#expect(sut.path.isEmpty)
	}

	@Test("showMedication with wrong params leaves path empty")
	func coordinatorHandle_showMedication_wrongParams_path_shouldBeEmpty() {

		// Given

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showMedication",
				params: ["showHealthcareOrganization": "wrong"]
			)
		)

		// Then
		#expect(sut.path.isEmpty)
	}

	@Test("removeHealthcareOrganization sets confirmation sheet state")
	func coordinatorHandle_removeHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")

		// When
		sut.handle(
			Coordination.Action(
				identifier: "removeHealthcareOrganization",
				params: ["healthcareOrganization": organization]
			)
		)

		// Then
		#expect(sut.rootStateForSheet == HealthcareCoordination.State.removeHealthcareOrganization(
			healthcareOrganization: organization
		))
	}

	@Test("removedHealthcareOrganization clears sheet and pops organization from path")
	func coordinatorHandle_removedHealthcareOrganization() {

		// Given
		let organization = Generator.healthcareOrganization("1")
		sut.rootStateForSheet = HealthcareCoordination.State.removeHealthcareOrganization(healthcareOrganization: organization)
		sut.path = NavigationStackBackport.NavigationPath([
			HealthcareCoordination.State.organizations,
			HealthcareCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		])

		// When
		sut.handle(Coordination.Action.removedHealthcareOrganization)

		// Then
		#expect(sut.rootStateForSheet == nil)
		#expect(sut.path == NavigationStackBackport.NavigationPath(
			[HealthcareCoordination.State.organizations]
		))
	}

	@Test("showHealthCategory pushes category and organization onto path")
	func coordinatorHandle_showHealthCategory() {

		// Given
		let organization = Generator.healthcareOrganization("1")
		let category = Generator.healthCategory

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showHealthCategory",
				params: [
					"category": category,
					"healthcareOrganization": organization
				]
			)
		)

		// Then
		#expect(sut.path == NavigationStackBackport.NavigationPath(
			[
				HealthcareCoordination.State.showHealthCategory(
					category: category,
					organization: organization
				)
			]
		))
	}

	@Test("showHealthCategory without organization pushes category with nil organization")
	func coordinatorHandle_showHealthCategory_withoutOrganization() {

		// Given
		let category = Generator.healthCategory

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showHealthCategory",
				params: ["category": category]
			)
		)

		// Then
		#expect(sut.path == NavigationStackBackport.NavigationPath(
			[
				HealthcareCoordination.State.showHealthCategory(
					category: category,
					organization: nil
				)
			]
		))
	}

	@Test("showHealthCategory with invalid params leaves path empty")
	func coordinatorHandle_showHealthCategory_invalidParam() {

		// Given

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showHealthCategory",
				params: ["param": "wrong"]
			)
		)

		// Then
		#expect(sut.path.isEmpty)
	}

	@Test("showHealthData pushes health data view onto path")
	func coordinatorHandle_showHealthCategoryData() {

		// Given
		let heading = "showHealthData"
		let schema = HealthUISchema(children: [], label: "test")
		let org = Generator.healthcareOrganization("1")

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showHealthData",
				params: [
					"resource": Data(),
					"backButtonTitle": heading,
					"uiSchema": schema,
					"healthcareOrganization": org,
					"inSheet": false
				]
			)
		)

		// Then
		#expect(sut.path == NavigationStackBackport.NavigationPath(
			[
				HealthcareCoordination.State.showHealthData(
					config: HealthDataViewConfig(
						backButtonTitle: heading,
						inSheet: false
					),
					schema: schema,
					organization: org,
				)
			]
		))
	}

	@Test("showHealthData in sheet opens as sheet instead of push")
	func coordinatorHandle_showHealthCategoryData_inSheet() {

		// Given
		let heading = "showHealthData"
		let schema = HealthUISchema(children: [], label: "test")
		let org = Generator.healthcareOrganization("1")

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showHealthData",
				params: [
					"resource": Data(),
					"backButtonTitle": heading,
					"uiSchema": schema,
					"healthcareOrganization": org,
					"inSheet": true
				]
			)
		)

		// Then
		#expect(sut.path.isEmpty)
		#expect(sut.rootStateForSheet == HealthcareCoordination.State.showHealthData(
			config: HealthDataViewConfig(
				backButtonTitle: nil,
				inSheet: true
			),
			schema: schema,
			organization: org,
		))
	}

	@Test("showHealthData with missing params leaves path empty")
	func coordinatorHandle_showHealthCategoryData_missingParam() {

		// Given
		let heading = "showHealthData"
		let schema = HealthUISchema(children: [], label: "test")

		// When
		sut.handle(
			Coordination.Action(
				identifier: "showHealthData",
				params: [
					"backButtonTitle": heading,
					"uiSchema": schema
				]
			)
		)

		// Then
		#expect(sut.path.isEmpty)
	}

	@Test("exportHealthData opens PDF export as sheet")
	func coordinatorHandle_exportHealthData() {

		// Given
		let data = PdfData(heading: "test", subHeading: "test", tables: [], footer: "test")

		// When
		sut.handle(
			Coordination.Action(
				identifier: "exportHealthData",
				params: [
					"healthData": data
				]
			)
		)

		// Then
		#expect(sut.path.isEmpty)
		#expect(sut.rootStateForSheet == HealthcareCoordination.State.exportHealthData(data))
	}

	@Test("exportHealthData with missing data does not open sheet")
	func coordinatorHandle_exportHealthData_missingData() {

		// Given

		// When
		sut.handle(
			Coordination.Action(
				identifier: "exportHealthData",
				params: [:]
			)
		)

		// Then
		#expect(sut.path.isEmpty)
		#expect(sut.rootStateForSheet == nil)
	}

	@Test("showFavorites opens favorites as sheet")
	func coordinatorHandle_showFavorites() {

		// Given

		// When
		sut.handle(Coordination.Action.showFavorites)

		// Then
		#expect(sut.rootStateForSheet == HealthcareCoordination.State.showFavorites)
	}
}
