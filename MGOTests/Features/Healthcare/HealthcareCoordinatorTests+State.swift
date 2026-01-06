/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
import PdfExport
@testable import MGO

final class HealthcareCoordinatorStateTests: XCTestCase {
	
	private var sut: HealthcareCoordinator!
	private var parentCoordinator: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = DashboardCoordinatorSpy()
		sut = HealthcareCoordinator(parentCoordinator: parentCoordinator, rootState: .showHealthCategories)
	}
	
	@MainActor func test_coordinatorView_forOverview() throws {
		
		// Given
		let state = HealthcareCoordination.State.organizations
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forAddHealthcareOrganization() throws {
		
		// Given
		let state = HealthcareCoordination.State.manualLocalization
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forAutomaticLocalization() throws {
		
		// Given
		let state = HealthcareCoordination.State.automaticLocalization
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
		}
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forHealthcareOrganizationSearchResults() throws {
		
		// Given
		let state = HealthcareCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
		}
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forShowHealthcareOrganization() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = HealthcareCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view), precision: 0.95)
	}
	
	@MainActor func test_coordinatorView_forShowHealthcareOrganization_withStore() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = HealthcareCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [organization]
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view), precision: 0.95)
	}
	
	@MainActor func test_coordinatorView_forRemoveHealthcareOrganization() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = HealthcareCoordination.State.removeHealthcareOrganization(healthcareOrganization: organization)
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forShowHealthCategoryData() throws {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		let schema = HealthUISchema(
			children: [
				HealthUIGroup(
					children: [
						UIElement(
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
					label: "section heading")
			],
			label: "zib details"
		)
		let state = HealthcareCoordination.State.showHealthData(
			config: HealthDataViewConfig(
				backButtonTitle: "Heading",
				titleInline: false,
				inSheet: false
			),
			schema: schema,
			organization: healthcareOrganization,
		)
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_forShowHealthCategoryData_inSheet() throws {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		let schema = HealthUISchema(
			children: [
				HealthUIGroup(
					children: [
						UIElement(
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
					label: "section heading")
			],
			label: "zib details"
		)
		let state = HealthcareCoordination.State.showHealthData(
			config: HealthDataViewConfig(
				backButtonTitle: "Heading",
				titleInline: false,
				inSheet: true
			),
			schema: schema,
			organization: healthcareOrganization,
		)
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_showHealthCategories() throws {
		
		// Given
		
		// When
		let view = sut.view(for: .showHealthCategories)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_alerts() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "alerts"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_allergies() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "allergies"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_appointments() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "appointments"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_complaints() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "problems"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_devices() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "medical_devices"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_documents() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "documents"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_labresults() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "lab_results"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_lifestyle() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "lifestyle"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_measurements() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "measurements"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_medication() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "medication"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_functionalOrMentalStatus() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "mental_wellbeing"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_patient() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "patient"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_careTeam() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "care_team"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_plans() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "plans"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_treatments() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "treatments"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_showHealthCategory_vaccinations() throws {
		
		// Given
		let sharedCategories = try SharedHealthCategories()
		let category = try XCTUnwrap(sharedCategories.findCategory(id: "vaccinations"))
		let view = sut.view(for: .showHealthCategory(category: category, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	@MainActor func test_coordinatorView_exportHealthData() throws {
		
		// Given
		let state = HealthcareCoordination.State.exportHealthData(
			PdfData(heading: "test", subHeading: "test", tables: [], footer: "test")
		)
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view), precision: 0.95)
	}
	
	@MainActor func test_coordinatorView_favorites() throws {
		
		// Given
		let state = HealthcareCoordination.State.showFavorites
		
		// When
		let view = sut.view(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
}
