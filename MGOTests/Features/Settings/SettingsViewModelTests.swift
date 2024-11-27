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
	
	func test_showResetDialog_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.showResetDialog)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.sut.showResetDialog) == true
	}
	
	func test_resetApplication_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.resetApplication)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.resetApplication
	}
	
	func test_automaticLocalization() {
		
		// Given
		
		// When
		sut.reduce(.automaticLocalization(false))
		
		// Then
		expect(self.servicesSpies.featureFlagSpy.invokedIsAutomaticLocalizationEnabledSetter) == true
		expect(self.servicesSpies.featureFlagSpy.invokedIsAutomaticLocalizationEnabled) == false
		
	}
}
