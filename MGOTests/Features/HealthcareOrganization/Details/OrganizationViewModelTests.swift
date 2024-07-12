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

final class OrganizationViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: OrganizationViewModel!
	private var healthcareOrganization: MgoOrganization!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareOrganization = Generator.healthcareOrganization("1")
		
		sut = OrganizationViewModel(coordinator: coordinatorSpy, healthcareOrganization: healthcareOrganization)
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_showProblems_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.showProblems)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0.identifier) == "showProblems"
	}
	
	func test_showMedication_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.showMedication)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0.identifier) == "showMedication"
	}
	
	func test_showResults_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.showResults)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0.identifier) == "showLabResults"
	}
	
	func test_removeHealthcareOrganization_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.removeHealthcareOrganization)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0.identifier) == "removeHealthcareOrganization"
	}
}
