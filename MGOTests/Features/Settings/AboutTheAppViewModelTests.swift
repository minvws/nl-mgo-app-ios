/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class AboutTheAppViewModelTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: AboutTheAppViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = AboutTheAppViewModel(coordinator: coordinatorSpy)
	}

	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_showSafety_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.showSafety)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showSafetyTips
	}
	
	func test_showOpenSource_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.showOpenSource)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showOpenSourceLibraries
	}
	
	func test_showAccessibility_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.showAccessibility)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showAccessibility
	}
	
	func test_showPrivacy_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.showPrivacy)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showPrivacyStatement
	}
	
	func test_showSharedCoreVersion_shouldShowDialog() {
		
		// Given
		
		// When
		sut.reduce(.showSharedCoreVersion)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.showSharedCoreVersionDialog) == true
	}
}
