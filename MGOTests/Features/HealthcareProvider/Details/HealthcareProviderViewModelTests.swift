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

final class HealthcareProviderViewModelTests: XCTestCase {
	
	private var coordinatorSpy: DashboardCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: HealthcareProviderViewModel!
	private var healthcareProvider: HealthcareProvider!
	
	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = DashboardCoordinatorSpy()
		healthcareProvider = Generator.healthcareProvider("1")
		
		sut = HealthcareProviderViewModel(coordinator: coordinatorSpy, healthcareProvider: healthcareProvider)
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
	
	func test_removeHealthcareProvider_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.removeHealthcareProvider)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0.identifier) == "removeHealthcareOrganization"
	}
}
