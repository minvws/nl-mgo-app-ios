/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

class AdvancedSettingsViewTests: XCTestCase {
	
	private var coordinatorSpy: SettingsCoordinatorSpy!
	private var sut: AdvancedSettingsView!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = SettingsCoordinatorSpy()
		sut = AdvancedSettingsView(viewModel: AdvancedSettingsViewModel(coordinator: self.coordinatorSpy))
		super.setUp()
	}
	
	func test_advancedSettings_automaticLocationEnabled() {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = true
		servicesSpies.featureFlagSpy.stubbedBypassPincode = true
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_advancedSettings_automaticLocationDisabled() {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		servicesSpies.featureFlagSpy.stubbedBypassPincode = false
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}

	func test_toggle() throws {
		
		// Given
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		
		// When
		let toggles = try sut.inspect().findAll(ViewType.Toggle.self)
		let toggle = try XCTUnwrap(toggles.first)
		try toggle.tap()
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_backbuttonPressed() throws {
		
		// Given
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
