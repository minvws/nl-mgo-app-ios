/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class SecuritySettingsViewModelTests: XCTestCase {
	
	private var coordinatorSpy: SettingsCoordinatorSpy!
	private var sut: SecuritySettingsViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = SettingsCoordinatorSpy()
		super.setUp()
	}
	
	func setupSut(bioMetricType: () -> LocalAuthentication.BiometricType) {
		
		sut = SecuritySettingsViewModel(coordinator: coordinatorSpy, bioMetricType: bioMetricType)
	}
	
	func test_backButtonPressed_shouldCallCoordinator() {
		
		// Given
		setupSut { .none }
		
		// When
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == true
		expect(self.coordinatorSpy.invokedHandleParameters?.0) == Coordination.Action.backButtonPressed
	}

	func test_handleBiometricEnabled_authNotOK_shouldSetSecureSettings() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		
		// When
		sut.reduce(.biometricEnabled(false))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_handleBiometricEnabled_authOK_shouldSetSecureSettings() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		
		// When
		sut.reduce(.biometricEnabled(true))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle) == false
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beTrue())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_handleBiometricEnabled_authCancelled_shouldSetSecureSettings() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .canceled
		
		// When
		sut.reduce(.biometricEnabled(true))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_handleBiometricEnabled_authFailed_shouldSetSecureSettings() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .authenticationFailed
		
		// When
		sut.reduce(.biometricEnabled(true))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_handleBiometricEnabled_authUserFallback_shouldSetSecureSettings() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .userFallback
		
		// When
		sut.reduce(.biometricEnabled(true))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_handleBiometricEnabled_authDeclined_shouldSetSecureSettings() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .declined
		
		// When
		sut.reduce(.biometricEnabled(true))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
	
	func test_handleBiometricEnabled_authLockout_shouldSetSecureSettings() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .lockout
		
		// When
		sut.reduce(.biometricEnabled(true))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
		expect(self.sut.state.showLockoutPopup) == true
	}
	
	func test_handleBiometricEnabled_authError_shouldNotCallCoordinator() {
		
		// Given
		setupSut { .faceID }
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .other(NSError(domain: "test error", code: 12345))
		
		// When
		sut.reduce(.biometricEnabled(true))
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabled).toEventually(beFalse())
		expect(self.servicesSpies.secureUserSettingsSpy.invokedBioMetricAuthenticationEnabledSetter).toEventually(beTrue())
	}
}
