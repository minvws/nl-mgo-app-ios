/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
@testable import MGO

final class PinCodeViewModelConfirmationTests: XCTestCase {
	
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
	
	func setupSut(mode: PinCodeViewModel.PinCodeMode = .creation, bioMetricType: () -> LocalAuthentication.BiometricType) {
		
		sut = PinCodeViewModel(
			coordinator: coordinatorSpy,
			mode: mode,
			pinLimit: 5,
			bioMetricType: bioMetricType,
			strengthMeter: strengthMeterSpy
		)
	}
	
	// MARK: - Confirmation Mode =
	
	func test_confirmation_touch() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "pincode.confirm.backbutton",
			title: "pincode.confirm.heading",
			message: "pincode.confirm.subheading",
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
		setupSut(mode: .confirmation, bioMetricType: { .touchID })
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount) == 0
	}
	
	func test_confirmation_touch_twoDigits() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "pincode.confirm.backbutton",
			title: "pincode.confirm.heading",
			message: "pincode.confirm.subheading",
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
		setupSut(mode: .confirmation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(2))
	}
	
	func test_confirmation_touch_fiveDigits_accessCodeMisMatch() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "pincode.confirm.backbutton",
			title: "pincode.confirm.heading",
			message: "pincode.confirm.subheading",
			error: "pincode.confirm.mismatch",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .error),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .error),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .error),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .error),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .error)
		]
		self.servicesSpies.secureUserSettingsSpy.stubbedTempPinCode = "11111"
		
		// When
		setupSut(mode: .confirmation, bioMetricType: { .touchID })
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
	
	func test_confirmation_touch_fiveDigits_accessCodeOk() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "pincode.confirm.backbutton",
			title: "pincode.confirm.heading",
			message: "pincode.confirm.subheading",
			showLockoutPopup: false
		)
		let expectedBoxState = [
			PinCodeViewModel.PinCodeBoxState(id: 0, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 1, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 2, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 3, state: .filled),
			PinCodeViewModel.PinCodeBoxState(id: 4, state: .filling)
		]
		self.servicesSpies.secureUserSettingsSpy.stubbedTempPinCode = "01234"
		
		// When
		setupSut(mode: .confirmation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))
		sut.reduce(.buttonPressed(value: "2"))
		sut.reduce(.buttonPressed(value: "3"))
		sut.reduce(.buttonPressed(value: "4"))
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.servicesSpies.secureUserSettingsSpy.invokedPinCode) == "01234"
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.pinCodeConfirmed))
		expect(self.servicesSpies.notificationCenterSpy.invokedPostNotificationCount).toEventually(beGreaterThanOrEqualTo(4))
	}
	
	func test_confirmation_touch_backButtonPressed() {
		
		// Given
		let expectedState = PinCodeViewState(
			bioMetricEnabled: false,
			bioMetricType: .touchID,
			backButtonVisible: true,
			backButtonKey: "pincode.confirm.backbutton",
			title: "pincode.confirm.heading",
			message: "pincode.confirm.subheading",
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
		setupSut(mode: .confirmation, bioMetricType: { .touchID })
		sut.reduce(.backButtonPressed)
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
		expect(self.coordinatorSpy.invokedHandle).toEventually(beTrue())
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(Coordination.Action.backButtonPressed))
	}
}
