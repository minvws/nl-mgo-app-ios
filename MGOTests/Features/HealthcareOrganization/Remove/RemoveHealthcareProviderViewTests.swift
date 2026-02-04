/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class RemoveHealthcareOrganizationViewTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var viewModel: RemoveHealthcareOrganizationViewModel!
	private var healthcareOrganization: MgoOrganization!
	private var sut: RemoveHealthcareOrganizationView!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
	}
	
	@MainActor private func createSut() {
		
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		
		viewModel = RemoveHealthcareOrganizationViewModel(
			coordinator: coordinatorSpy,
			healthcareOrganization: healthcareOrganization
		)
		sut = RemoveHealthcareOrganizationView(viewModel: self.viewModel)
	}
	
	@MainActor func test_healthcareOrganization_details() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_healthcareOrganization_details_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_removeButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "remove_organization.remove")
		try view.view(CallToActionButton.self).find(button: "remove_organization.yes_delete").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.removedHealthcareOrganization
	}
	
	@MainActor func test_cancelButtonPressed_shouldCallCoordinator() throws {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		createSut()
		
		// When
		let view = try sut.inspect().find(viewWithAccessibilityIdentifier: "remove_organization.cancel")
		try view.view(CallToActionButton.self).find(button: "remove_organization.no_cancel").tap()
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
}
