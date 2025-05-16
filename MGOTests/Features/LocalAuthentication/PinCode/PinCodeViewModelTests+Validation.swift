/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO
// swiftlint:disable type_body_length
final class PinCodeViewModelTests: XCTestCase {
	
	private var strengthMeterSpy: PinCodeStrengthValidationSpy!
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: PinCodeViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		strengthMeterSpy = PinCodeStrengthValidationSpy()
		servicesSpies = setupServicesSpies()
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = true
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .touchID }
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func setupSut(mode: PinCodeViewModel.PinCodeMode = .creation, bioMetricType: () -> LocalAuthentication.BiometricType) {
		
		sut = PinCodeViewModel(
			coordinator: coordinatorSpy,
			mode: mode,
			pinLimit: 5,
			bioMetricType: bioMetricType,
			strengthMeter: strengthMeterSpy
		)
	}
	
	private func expectedBoxState(
		_ state0: PinCodeBoxView.State,
		_ state1: PinCodeBoxView.State,
		_ state2: PinCodeBoxView.State,
		_ state3: PinCodeBoxView.State,
		_ state4: PinCodeBoxView.State ) -> [PinCodeViewModel.PinCodeBoxState] {
			
		return [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: state0),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: state1),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: state2),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: state3),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: state4)
		]
	}
	
	// MARK: - Validation Mode =
	
	func test_validation_touch() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		
		// When
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount) == 0
	}
	
	func test_validation_touch_twoDigits() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.filled, .filling, .focus, .empty, .empty)
		
		// When
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(2))
	}
	
	func test_validation_touch_fiveDigits_accessCodeMisMatch() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			error: "pincode.validation.wrong",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.error, .error, .error, .error, .error)
		self.servicesSpies.secureUserSettingsSpy.stubbedPinCode = "11111"
		
		// When
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))
		sut.reduce(.buttonPressed(value: "4"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCode) == nil
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(5))
	}
	
	func test_validation_touch_fiveDigits_accessCodeOk() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.filled, .filled, .filled, .filled, .filling)
		self.servicesSpies.secureUserSettingsSpy.stubbedPinCode = "01234"
		
		// When
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))
		sut.reduce(.buttonPressed(value: "4"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == true
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.pinCodeValidated))
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(4))
	}
	
	func test_validation_touch_fiveDigits_accessCodeOk_lockoutMode() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.filled, .filled, .filled, .filled, .filling)
		self.servicesSpies.secureUserSettingsSpy.stubbedPinCode = "01234"
		
		// When
		setupSut(mode: .validation(lockOut: true), bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))
		sut.reduce(.buttonPressed(value: "4"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == true
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.pinCodeValidatedAfterLockout))
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(4))
	}
	
	func test_validation_biometricEnabled_authenticated() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue(), timeout: .seconds(5))
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue(), timeout: .seconds(5))
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.pinCodeValidated), timeout: .seconds(5))
	}
	
	func test_validation_biometricEnabled_authenticated_lockOutMode() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		setupSut(mode: .validation(lockOut: true), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate) == false
	}
	
	func test_validation_biometricKeyPressed_authenticated() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.biometricKeyPressed)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.pinCodeValidated))
	}
	
	func test_validation_biometricKeyPressed_authenticated_lockOutMode() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		setupSut(mode: .validation(lockOut: true), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.biometricKeyPressed)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.pinCodeValidatedAfterLockout))
	}
	
	func test_validation_biometricEnabled_authenticationFailed() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.error, .error, .error, .error, .error)
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorAuthenticationFailed() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .authenticationFailed
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.error, .error, .error, .error, .error)
		
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorFallback() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .userFallback
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorCancelled() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .canceled
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorDeclined() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .declined
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorLockout() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .lockout
		let expectedState = PinCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "pincode.validation.heading",
			message: "pincode.validation.subheading",
			textAlignment: .center,
			showLockoutPopup: true
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_forgotPinCode() {
		
		// Given
		setupSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		sut.reduce(.forgotPinCode)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.forgotPinCode))
	}
}
// swiftlint: enable type_body_length
