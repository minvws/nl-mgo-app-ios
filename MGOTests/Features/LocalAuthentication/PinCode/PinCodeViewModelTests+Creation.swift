/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class PinCodeViewModelCreationTests: XCTestCase {
	
	private var strengthMeterSpy: PinCodeStrengthValidationSpy!
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: PinCodeViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		strengthMeterSpy = PinCodeStrengthValidationSpy()
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	private func setupSut(
		mode: PinCodeViewModel.PinCodeMode = .creation,
		backButtonVisible: Bool = true,
		bioMetricType: () -> LocalAuthentication.BiometricType) {
		
		sut = PinCodeViewModel(
			coordinator: coordinatorSpy,
			mode: mode,
			backButtonVisible: backButtonVisible,
			pinLimit: 5,
			bioMetricType: bioMetricType,
			strengthMeter: strengthMeterSpy
		)
	}
	
	// MARK: - Creation Mode =
	
	func test_creation_touch() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "common.previous",
			title: "pincode.create.heading",
			message: "pincode.create.subheading",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .focus),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .empty)
		]
		
		// When
		setupSut(mode: .creation, bioMetricType: { .touchID })
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount) == 0
	}
	
	func test_creation_touch_withoutBackButton() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: false,
			backButtonKey: "common.previous",
			title: "pincode.create.heading",
			message: "pincode.create.subheading",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .focus),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .empty)
		]
		
		// When
		setupSut(mode: .creation, backButtonVisible: false, bioMetricType: { .touchID })
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount) == 0
	}
	
	func test_creation_touch_twoDigits() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "common.previous",
			title: "pincode.create.heading",
			message: "pincode.create.subheading",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .filling),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .focus),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .empty)
		]
		
		// When
		setupSut(mode: .creation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(2), timeout: .seconds(5))
	}
	
	func test_creation_touch_twoDigits_eraseButtonPressed() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "common.previous",
			title: "pincode.create.heading",
			message: "pincode.create.subheading",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .focus),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .empty)
		]
		
		// When
		setupSut(mode: .creation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.erasePressed)

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(3))
	}
	
	func test_creation_touch_fourDigits() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "common.previous",
			title: "pincode.create.heading",
			message: "pincode.create.subheading",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .filling),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .focus)
		]
		
		// When
		setupSut(mode: .creation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(4))
	}
	
	func test_creation_touch_fiveDigits_accessCodeOK() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "common.previous",
			title: "pincode.create.heading",
			message: "pincode.create.subheading",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .focus),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .empty),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .empty)
		]
		strengthMeterSpy.stubbedValidateResult = true
		
		// When
		setupSut(mode: .creation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))
		sut.reduce(.buttonPressed(value: "4"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.secureUserSettingsSpy.invokedTempPinCode) == "01234"
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCode) == nil
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.pinCodeEntered))
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(4))
	}
	
	func test_creation_touch_fiveDigits_accessCodeTooWeak() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "common.previous",
			title: "pincode.create.heading",
			message: "pincode.create.subheading",
			error: "pincode.create.tooweak",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .error),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .error),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .error),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .error),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .error)
		]
		strengthMeterSpy.stubbedValidateResult = false
		
		// When
		setupSut(mode: .creation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))
		sut.reduce(.buttonPressed(value: "4"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.secureUserSettingsSpy.invokedTempPinCode) == nil
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCode) == nil
		expect(self.coordinatorSpy.invokedHandle).toEventually(beFalse())
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(5))
	}
}
