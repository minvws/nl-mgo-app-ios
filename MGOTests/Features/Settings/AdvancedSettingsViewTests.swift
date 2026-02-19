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
		super.setUp()
	}
	
	@MainActor private func createSut() {
		
		sut = AdvancedSettingsView(
			viewModel: AdvancedSettingsViewModel(
				coordinator: self.coordinatorSpy
			)
		)
	}
	
	@MainActor func test_advancedSettings_automaticLocationEnabled() {
		
		// Given
		createSut()
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = true
		servicesSpies.featureFlagSpy.stubbedBypassRemoteAuthentication = true
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_advancedSettings_automaticLocationDisabled() {
		
		// Given
		createSut()
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		servicesSpies.featureFlagSpy.stubbedBypassRemoteAuthentication = false
		
		// When
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// Then
		takeSnapShots(content: content)
	}

	@MainActor func test_toggle() throws {
		
		// Given
		createSut()
		servicesSpies.featureFlagSpy.stubbedIsAutomaticLocalizationEnabled = false
		
		// When
		let toggles = try sut.inspect().findAll(ViewType.Toggle.self)
		let toggle = try XCTUnwrap(toggles.first)
		try toggle.tap()
		
		// Then
		takeSnapShots(content: sut)
	}
	
	@MainActor func test_backbuttonPressed() throws {
		
		// Given
		createSut()
		let content = NavigationStackBackport.NavigationStack { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
