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
	}
	
	@MainActor func setupSut() {
		
		sut = SettingsViewModel(coordinator: coordinatorSpy)
	}
	
	@MainActor func test_showResetDialog_shouldShowDialog() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.showResetDialog)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.showResetDialog) == true
	}
	
	@MainActor func test_cancelDialog_shouldRemoveDialog() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.cancelDialog)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.showResetDialog) == false
	}

	@MainActor func test_displaySettings_shouldCallCoordinator() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.displaySettings)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showDisplaySettings
	}
	
	@MainActor func test_advancedSettings_shouldCallCoordinator() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.advancedSettings)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showAdvancedSettings
	}
	
	@MainActor func test_aboutTheApp_shouldCallCoordinator() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.aboutTheApp)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.showAboutTheApp
	}
	
	@MainActor func test_resetApplication_shouldCallCoordinator() {
		
		// Given
		setupSut()
		
		// When
		sut.reduce(.resetApplication)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.resetApplication
	}
}
