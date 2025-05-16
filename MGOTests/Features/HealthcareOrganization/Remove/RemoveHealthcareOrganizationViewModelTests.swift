/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	private var healthcareOrganization: MgoOrganization!
	
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
		expect(self.servicesSpies.dataStoreSpy.invokedRemoveRecords) == true
	}
}
