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

final class OverviewViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: OverviewViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		
		sut = OverviewViewModel(coordinator: coordinatorSpy)
	}

	func test_onAppear_shouldCallStore_noOrganzations_stateShouldBeEmtpy() {
		
		// Given
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = []
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.state) == .empty
	}
	
	func test_onAppear_shouldCallStore_withOrganizations_stateShouldBeList() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		servicesSpies.healthcareOrganizationStoreSpy.stubbedOrganizations = [healthcareOrganization]
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.sut.state) == .list([healthcareOrganization])
	}
	
	func test_searchButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.search)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.addHealthcareOrganization
	}
	
	func test_detailsButtonPressed_shouldCallCoordinator() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		
		// When
		sut.reduce(.details(healthcareOrganization))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action(
			identifier: "showHealthcareOrganization",
			params: ["healthcareOrganization": healthcareOrganization]
		)
	}
	
	func test_closeBanner_shouldRemoveBanner() {
		
		// Given
		sut.toast = Feedback(title: "test", subtitle: "test", type: .error)
		
		// When
		sut.reduce(.closeToast)
		
		// Then
		expect(self.sut.toast) == nil
	}
}
