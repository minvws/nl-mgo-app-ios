/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

class SecuritySettingsViewTests: XCTestCase {
	
	private var coordinatorSpy: SettingsCoordinatorSpy!
	private var sut: SecuritySettingsView!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = SettingsCoordinatorSpy()
		super.setUp()
	}
	
	func createSut(bioMetricType: () -> LocalAuthentication.BiometricType) -> SecuritySettingsView {
		
		let viewModel = SecuritySettingsViewModel(coordinator: coordinatorSpy, bioMetricType: bioMetricType)
		
		return SecuritySettingsView(
			viewModel: viewModel
		)
	}
	
	func test_securitySettings_faceID() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = false
		let sut = createSut(bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_securitySettings_touchID() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = false
		let sut = createSut(bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_securitySettings_opticID() {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = false
		let sut = createSut(bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_toggle() throws {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = false
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .faceID }
		let sut = createSut(bioMetricType: { .faceID })
		
		// When
		let toggles = try sut.inspect().findAll(ViewType.Toggle.self)
		let toggle = try XCTUnwrap(toggles.first)
		try toggle.tap()
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_backbuttonPressed() throws {
		
		// Given
		let sut = createSut(bioMetricType: { .faceID })
		let content = NavigationView { sut }
		
		// When
		try content.inspect().find(viewWithAccessibilityIdentifier: "common.previous").button().tap()

		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}
}
