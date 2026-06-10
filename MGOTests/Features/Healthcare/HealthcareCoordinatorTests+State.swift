/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

@MainActor
@Suite
struct HealthcareCoordinatorStateTests {

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

	@Test("organizations state renders OrganizationsView")
	func coordinatorView_forOverview() throws {

		// Given
		let state = HealthcareCoordination.State.organizations

		// When
		let view = sut.view(for: state)

		// Then
		_ = try view.inspect().find(OrganizationsView.self)
	}

	@Test("manualLocalization state renders SearchOrganizationView")
	func coordinatorView_forAddHealthcareOrganization() throws {

		// Given
		let state = HealthcareCoordination.State.manualLocalization

		// When
		let view = sut.view(for: state)

		// Then
		_ = try view.inspect().find(SearchOrganizationView.self)
	}

	@Test("showHealthcareOrganization state renders HealthCategoriesView")
	func coordinatorView_forShowHealthcareOrganization() throws {

		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = HealthcareCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)

		// When
		let view = sut.view(for: state)

		// Then
		_ = try view.inspect().find(HealthCategoriesView.self)
	}

	@Test("showHealthcareOrganization with stored organization renders HealthCategoriesView")
	func coordinatorView_forShowHealthcareOrganization_withStore() throws {

		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = HealthcareCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [organization]

		// When
		let view = sut.view(for: state)

		// Then
		_ = try view.inspect().find(HealthCategoriesView.self)
	}

	@Test("showHealthData state renders HealthDataView")
	func coordinatorView_forShowHealthCategoryData() throws {

		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		let schema = HealthUISchema(
			children: [
				HealthUIGroup(
					children: [
						UIElement(
							id: "label",
							label: "label",
							type: .singleValue,
							value: UIElementValue
								.displayValue(DisplayValue(
									code: nil,
									display: "value 1",
									system: nil)
								),
							display: nil,
							reference: nil,
							url: nil
						)
					],
					excludeFromPrint: false,
					id: "section_heading_1",
					label: "section heading 1"
				),
				HealthUIGroup(
					children: [
						UIElement(
							id: "label",
							label: "label",
							type: .singleValue,
							value: UIElementValue
								.displayValue(DisplayValue(
									code: nil,
									display: "value 2",
									system: nil)
								),
							display: nil,
							reference: nil,
							url: nil
						)
					],
					excludeFromPrint: false,
					id: "section_heading_2",
					label: "section heading 2"
				)
			],
			label: "zib details"
		)
		let state = HealthcareCoordination.State.showHealthData(
			config: HealthDataViewConfig(
				backButtonTitle: "Heading",
				inSheet: false
			),
			schema: schema,
			organization: healthcareOrganization,
		)

		// When
		let view = sut.view(for: state)

		// Then
		_ = try view.inspect().find(HealthDataView.self)
	}

	@Test("showHealthData in sheet state renders HealthDataView")
	func coordinatorView_forShowHealthCategoryData_inSheet() throws {

		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		let schema = HealthUISchema(
			children: [
				HealthUIGroup(
					children: [
						UIElement(
							id: "label",
							label: "label",
							type: .singleValue,
							value: UIElementValue
								.displayValue(DisplayValue(
									code: nil,
									display: "value 1",
									system: nil)
								),
							display: nil,
							reference: nil,
							url: nil
						)
					],
					excludeFromPrint: false,
					id: "test_coordinatorView_forShowHealthCategoryData_inSheet",
					label: "section heading")
			],
			label: "zib details"
		)
		let state = HealthcareCoordination.State.showHealthData(
			config: HealthDataViewConfig(
				backButtonTitle: "Heading",
				inSheet: true
			),
			schema: schema,
			organization: healthcareOrganization,
		)

		// When
		let view = sut.view(for: state)

		// Then
		_ = try view.inspect().find(HealthDataView.self)
	}

	@Test("showHealthCategories state renders HealthCategoriesView")
	func coordinatorView_showHealthCategories() throws {

		// Given

		// When
		let view = sut.view(for: .showHealthCategories)

		// Then
		_ = try view.inspect().find(HealthCategoriesView.self)
	}

	@Test("exportHealthData state renders HealthExportView")
	func coordinatorView_exportHealthData() throws {

		// Given
		let state = HealthcareCoordination.State.exportHealthData(
			PdfData(heading: "test", subHeading: "test", tables: [], footer: "test")
		)

		// When
		let view = sut.view(for: state)

		// Then
		_ = try view.inspect().find(HealthExportView.self)
	}

	@Test("showFavorites state renders FavoritesView")
	func coordinatorView_favorites() throws {

		// Given
		let state = HealthcareCoordination.State.showFavorites

		// When
		let view = sut.view(for: state)

		// Then
		_ = try view.inspect().find(FavoritesView.self)
	}
}
