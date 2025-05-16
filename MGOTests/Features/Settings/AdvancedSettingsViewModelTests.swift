/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import MGO
import MGOFoundation
import MGOUI

final class AdvancedSettingsViewModelTests: XCTestCase {

	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	private var sut: AdvancedSettingsViewModel!

	override func setUp() {
		
		super.setUp()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		sut = AdvancedSettingsViewModel(coordinator: coordinatorSpy)
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
	
	func test_automaticLocalization() {
		
		// Given
		
		// When
		sut.reduce(.automaticLocalization(false))
		
		// Then
		expect(self.servicesSpies.featureFlagSpy.invokedIsAutomaticLocalizationEnabledSetter).toEventually(beTrue())
		expect(self.servicesSpies.featureFlagSpy.invokedIsAutomaticLocalizationEnabled) == false
	}
	
	func test_bypassPincode() {
		
		// Given
		
		// When
		sut.reduce(.bypassPincode(false))
		
		// Then
		expect(self.servicesSpies.featureFlagSpy.invokedBypassPincodeSetter).toEventually(beTrue())
		expect(self.servicesSpies.featureFlagSpy.invokedBypassPincode) == false
	}
}
