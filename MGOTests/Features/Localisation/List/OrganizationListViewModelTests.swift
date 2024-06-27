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

final class OrganizationListViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: OrganizationListViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = OrganizationListViewModel(coordinator: coordinatorSpy)
	}

	func test_onAppear_shouldCallStore() {
		
		// Given
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_backToSearch_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backToSearch)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backToAddHealthcareOrganization
		expect(self.servicesSpies.notificationCenterSpy.invokedPostName) == true
	}
	
	func test_done_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.done)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.finishedSearchingHealthcareOrganizations
	}
	
	func test_showRemoveDialog_shouldShowDialog() {
		
		// Given
		let provider = Generator.healthcareOrganization("1")
		
		// When
		sut.reduce(.showRemoveDialog(provider))
		
		// Then
		expect(self.sut.healthcareOrganizationToRemoveTitle) == "Tandarts Tandje Erbij weglaten?"
	}
	
	func test_cancelDialog_shouldClearDialog() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		sut.reduce(.showRemoveDialog(healthcareOrganization))
		
		// When
		sut.reduce(.cancelDialog)
		
		// Then
		expect(self.sut.healthcareOrganizationToRemoveTitle) == nil
	}

	func test_remove_shouldCallStore() {
		
		// Given
		let healthcareOrganization = Generator.healthcareOrganization("1")
		sut.reduce(.showRemoveDialog(healthcareOrganization))
		self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter = false
		self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetterCount = 0
		
		// When
		sut.reduce(.remove)
		
		// Then
		expect(self.sut.healthcareOrganizationToRemoveTitle) == nil
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedRemove) == true
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedRemoveParameters?.0) == healthcareOrganization

		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetter) == true
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedOrganizationsGetterCount) == 1
	}
}
