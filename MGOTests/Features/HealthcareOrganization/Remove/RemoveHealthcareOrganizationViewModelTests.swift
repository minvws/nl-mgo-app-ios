/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class RemoveHCOViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: RemoveHealthcareOrganizationViewModel!
	private var healthcareOrganization: HealthcareOrganization!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		
		sut = RemoveHealthcareOrganizationViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization)
	}
	
	func test_closeButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.closeSheet)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	func test_cancelButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.cancel)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.closeSheet
	}
	
	func test_removeButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.removeOrganization)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.removedHealthcareOrganization
		expect(self.servicesSpies.healthcareOrganizationStoreSpy.invokedRemove) == true
	}
}
