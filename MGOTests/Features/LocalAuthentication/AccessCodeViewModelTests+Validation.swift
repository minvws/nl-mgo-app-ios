/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class AccessCodeViewModelTests: XCTestCase {
	
	private var strengthMeterSpy: AccessCodeStrengthValidationSpy!
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: AccessCodeViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		strengthMeterSpy = AccessCodeStrengthValidationSpy()
		servicesSpies = setupServicesSpies()
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = true
		servicesSpies.localAuthenticationProviderSpy.stubbedBiometricType = { .touchID }
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func setupSut(mode: AccessCodeViewModel.AccessCodeMode = .creation, bioMetricType: () -> LocalAuthentication.BiometricType) {
		
		sut = AccessCodeViewModel(
			coordinator: coordinatorSpy,
			mode: mode,
			pinLimit: 5,
			bioMetricType: bioMetricType,
			strengthMeter: strengthMeterSpy
		)
	}
	
	private func expectedBoxState(
		_ state0: AccessCodeBoxView.State,
		_ state1: AccessCodeBoxView.State,
		_ state2: AccessCodeBoxView.State,
		_ state3: AccessCodeBoxView.State,
		_ state4: AccessCodeBoxView.State ) -> [AccessCodeViewModel.AccessCodeBoxState] {
			
		return [
			AccessCodeViewModel.AccessCodeBoxState(id: 0, state: state0),
			AccessCodeViewModel.AccessCodeBoxState(id: 1, state: state1),
			AccessCodeViewModel.AccessCodeBoxState(id: 2, state: state2),
			AccessCodeViewModel.AccessCodeBoxState(id: 3, state: state3),
			AccessCodeViewModel.AccessCodeBoxState(id: 4, state: state4)
		]
	}
	
	// MARK: - Validation Mode =
	
	func test_validation_touch() {
		
		// Given
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: false,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		
		// When
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount) == 0
	}
	
	func test_validation_touch_twoDigits() {
		
		// Given
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: true,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.filled, .filling, .focus, .empty, .empty)
		
		// When
		setupSut(mode: .validation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(2))
	}
	
	func test_validation_touch_fiveDigits_accessCodeMisMatch() {
		
		// Given
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: true,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_wrong_body",
			messageType: .alert,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.error, .error, .error, .error, .error)
		self.servicesSpies.secureUserSettingsSpy.stubbedAccessCode = "11111"
		
		// When
		setupSut(mode: .validation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))
		sut.reduce(.buttonPressed(value: "4"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCode) == nil
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(5))
	}
	
	func test_validation_touch_fiveDigits_accessCodeOk() {
		
		// Given
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: true,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.filled, .filled, .filled, .filled, .filling)
		self.servicesSpies.secureUserSettingsSpy.stubbedAccessCode = "01234"
		
		// When
		setupSut(mode: .validation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))
		sut.reduce(.buttonPressed(value: "4"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == true
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.accessCodeValidated))
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(4))
	}
	
	func test_validation_biometricEnabled_authenticated() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.accessCodeValidated))
	}
	
	func test_validation_biometricKeyPressed_authenticated() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = true
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.biometricKeyPressed)
		
		// Then
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.accessCodeValidated))
	}
	
	func test_validation_biometricEnabled_authenticationFailed() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: false,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.error, .error, .error, .error, .error)
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorAuthenticationFailed() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .authenticationFailed
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: false,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.error, .error, .error, .error, .error)
		
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorFallback() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .userFallback
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: false,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorCancelled() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .canceled
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: false,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorDeclined() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .declined
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: false,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: false
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_validation_biometricEnabled_errorLockout() {
		
		// Given
		servicesSpies.localAuthenticationProviderSpy.stubbedAuthenticated = false
		servicesSpies.localAuthenticationProviderSpy.stubbedLocalAuthenticationError = .lockout
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: false,
			backButtonVisible: false,
			backButtonKey: "",
			forgotCodeButtonVisible: true,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular,
			showLockoutPopup: true
		)
		let expectedBoxState = expectedBoxState(.focus, .empty, .empty, .empty, .empty)
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.onAppear)
		
		// Then
		expect(self.sut.state).toEventually(equal(expectedState))
		expect(self.sut.boxStates).toEventually(equal(expectedBoxState))
		expect(self.servicesSpies.secureUserSettingsSpy.invokedAccessCodeGetter) == false
		expect(self.servicesSpies.localAuthenticationProviderSpy.invokedAuthenticate).toEventually(beTrue())
	}
	
	func test_forgotAccessCode() {
		
		// Given
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		sut.reduce(.forgotAccessCode)
		
		// Then
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.forgotAccessCode))
	}
}
