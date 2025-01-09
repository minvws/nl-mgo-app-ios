/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
import Zibs
@testable import MGO

final class DashboardCoordinatorStateTests: XCTestCase {
	
	private var sut: DashboardCoordinator!
	private var parentCoordinator: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		parentCoordinator = AppCoordinatorSpy()
		sut = DashboardCoordinator(parentCoordinator: parentCoordinator)
	}
	
	override func tearDown() {
		super.tearDown()
		HTTPStubs.removeAllStubs()
	}
	
	func test_coordinatorView_forSettings() throws {
		
		// Given
		let state = DashboardCoordination.State.settings
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forOverview() throws {
		
		// Given
		let state = DashboardCoordination.State.overview
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forAddHealthcareOrganization() throws {
		
		// Given
		let state = DashboardCoordination.State.manualLocalization
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}

	func test_coordinatorView_forAutomaticLocalization() throws {
		
		// Given
		let state = DashboardCoordination.State.automaticLocalization
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
		}
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forHealthcareOrganizationSearchResults() throws {
		
		// Given
		let state = DashboardCoordination.State.healthcareOrganizationSearchResults(city: "Roermond", name: "Tandarts Tandje Erbij")
		stub(condition: isPath("/localization/organization/search")) { _ in
			return HTTPStubsResponse(data: Data(), statusCode: 200, headers: nil)
		}
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forShowHealthcareOrganization() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = DashboardCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view), precision: 0.95)
	}
	
	func test_coordinatorView_forShowHealthcareOrganization_withStore() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = DashboardCoordination.State.showHealthcareOrganization(healthcareOrganization: organization)
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [organization]
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view), precision: 0.95)
	}
	
	func test_coordinatorView_forRemoveHealthcareOrganization() throws {
		
		// Given
		let organization = Generator.healthcareOrganization("1")
		let state = DashboardCoordination.State.removeHealthcareOrganization(healthcareOrganization: organization)
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_forshowHealthCategoryData() throws {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		let schema = UISchema(
			children: [
				UISchemaGroup(
					children: [
						UIElement(
							display: .string("value 1"),
							label: "label",
							type: .singleValue,
							reference: nil,
							url: nil
						)
					],
					label: "section heading")
			],
			label: "zib details"
		)
		let state = DashboardCoordination.State.showHealthData(
			heading: "Heading",
			schema: schema,
			organization: healthcareOrganization
		)
		
		// When
		let view = sut.viewState(for: state)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_showHealthCategories() throws {
		
		// Given
		
		// When
		let view = sut.viewState(for: .showHealthCategories)
		
		// Then
		takeSnapShots(content: try XCTUnwrap(view))
	}
	
	func test_coordinatorView_showHealthCategory_alerts() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .alerts, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_allergies() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .allergies, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_appointments() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .appointments, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_complaints() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .complaints, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_devices() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .devices, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_documents() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .documents, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_labresults() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .labresults, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_lifestyle() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .lifestyle, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_measurements() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .measurements, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_medication() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .medication, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_functionalOrMentalStatus() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .functionalOrMentalStatus, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_patient() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .patient, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_payment() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .payment, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_plans() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .plans, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_treatments() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .treatments, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
	
	func test_coordinatorView_showHealthCategory_vaccinations() throws {
		
		// Given
		let view = sut.viewState(for: .showHealthCategory(category: .vaccinations, organization: nil))
		
		// When
		let content = NavigationView { view }
		
		// Then
		takeSnapShots(content: try XCTUnwrap(content))
	}
}
