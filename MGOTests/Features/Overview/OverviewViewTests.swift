/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class OverviewViewTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: OverviewViewModel!
	private var sut: OverviewView!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
	}
	
	private func createSut() {
		
		viewModel = OverviewViewModel(coordinator: coordinatorSpy)
		sut = OverviewView(viewModel: self.viewModel)
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
	
	func test_dashboard_threeOrganizations_toast() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [
			healthcareOrganization,
			Generator.healthcareOrganization("2"),
			Generator.healthcareOrganization("3")
		]
		createSut()
		
		viewModel.toast = Toast(
			title: String(
				format: String(localized: "toast.organization_removed.heading"),
				arguments: ["\(healthcareOrganization.display_name)"]
			),
			subtitle: String(localized: "toast.organization_removed.subheading"),
			type: .success
		)
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_dashboard_addHealthcareOrganization() throws {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		createSut()
		
		// When
		try sut.inspect().find(viewWithAccessibilityIdentifier: "overview.add_organizations").button().tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.addHealthcareOrganization
	}
}
