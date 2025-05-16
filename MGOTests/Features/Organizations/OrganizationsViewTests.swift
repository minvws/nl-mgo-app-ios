/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class OrganizationsViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: OrganizationsViewModel!
	private var sut: OrganizationsView!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	private func createSut() {
		
		viewModel = OrganizationsViewModel(coordinator: coordinatorSpy)
		sut = OrganizationsView(viewModel: self.viewModel)
	}
	
	func test_dashboard_emptyList() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_dashboard_emptyList_automaticLocalizationEnabled() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = true
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_dashboard_threeOrganizations() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1"),
			Generator.healthcareOrganization("2"),
			Generator.healthcareOrganization("3")
		]
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_dashboard_threeOrganizations_automaticLocalizationEnabled() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			Generator.healthcareOrganization("1"),
			Generator.healthcareOrganization("2"),
			Generator.healthcareOrganization("3")
		]
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = true
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_dashboard_threeOrganizations_toast() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			healthcareOrganization,
			Generator.healthcareOrganization("2"),
			Generator.healthcareOrganization("3")
		]
		createSut()
		
		viewModel.toast = Feedback(
			title: String(localized: "toast.organizations_changed.heading"),
			subtitle: String(localized: "toast.organizations_changed.subheading"),
			type: .success
		)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_dashboard_addHealthcareOrganization_noOrganizations() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "common.add_organizations")
		try view.view(CallToActionButton.self).find(button: "common.add_organizations").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.addHealthcareOrganization
	}
}
