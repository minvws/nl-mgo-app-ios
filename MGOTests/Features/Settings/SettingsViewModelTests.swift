/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class SettingsViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: SettingsViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = SettingsViewModel(coordinator: coordinatorSpy)
	}
	
	func test_showResetDialog_shouldShowDialog() {
		
		// Given
		
		// When
		sut.reduce(.showResetDialog)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.showResetDialog) == true
	}
	
	func test_cancelDialog_shouldRemoveDialog() {
		
		// Given
		
		// When
		sut.reduce(.cancelDialog)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.showResetDialog) == false
	}

	func test_displaySettings_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.displaySettings)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showDisplaySettings
	}
	
	func test_securitySettings_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.securitySettings)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showSecuritySettings
	}
	
	func test_advancedSettings_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.advancedSettings)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showAdvancedSettings
	}
	
	func test_aboutTheApp_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.aboutTheApp)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showAboutTheApp
	}
	
	func test_resetApplication_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.resetApplication)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.resetApplication
	}
	
	func test_lockApplication_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.lockApplication)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.lockApplication
	}
}
