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
	
	// MARK: - Validation Mode =
	
	func test_validation_touch() {
		
		// Given
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: false,
			backButtonVisible: false,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular
		)
		let expectedBoxState = [
			AccessCodeViewModel.AccessCodeBoxState(id: 0, state: .focus),
			AccessCodeViewModel.AccessCodeBoxState(id: 1, state: .empty),
			AccessCodeViewModel.AccessCodeBoxState(id: 2, state: .empty),
			AccessCodeViewModel.AccessCodeBoxState(id: 3, state: .empty),
			AccessCodeViewModel.AccessCodeBoxState(id: 4, state: .empty)
		]
		
		// When
		setupSut(mode: .validation, bioMetricType: { .touchID })
		
		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
	}
	
	func test_validation_touch_twoDigits() {
		
		// Given
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: true,
			backButtonVisible: false,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular
		)
		let expectedBoxState = [
			AccessCodeViewModel.AccessCodeBoxState(id: 0, state: .filled),
			AccessCodeViewModel.AccessCodeBoxState(id: 1, state: .filling),
			AccessCodeViewModel.AccessCodeBoxState(id: 2, state: .focus),
			AccessCodeViewModel.AccessCodeBoxState(id: 3, state: .empty),
			AccessCodeViewModel.AccessCodeBoxState(id: 4, state: .empty)
		]
		
		// When
		setupSut(mode: .validation, bioMetricType: { .touchID })
		sut.reduce(.buttonPressed(value: "0"))
		sut.reduce(.buttonPressed(value: "1"))

		// Then
		expect(self.sut.state) == expectedState
		expect(self.sut.boxStates) == expectedBoxState
	}
	
	func test_validation_touch_fiveDigits_accessCodeMisMatch() {
		
		// Given
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: true,
			backButtonVisible: false,
			title: "accesscode_validation_title",
			message: "accesscode_wrong_body",
			messageType: .alert
		)
		let expectedBoxState = [
			AccessCodeViewModel.AccessCodeBoxState(id: 0, state: .error),
			AccessCodeViewModel.AccessCodeBoxState(id: 1, state: .error),
			AccessCodeViewModel.AccessCodeBoxState(id: 2, state: .error),
			AccessCodeViewModel.AccessCodeBoxState(id: 3, state: .error),
			AccessCodeViewModel.AccessCodeBoxState(id: 4, state: .error)
		]
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
	}
	
	func test_validation_touch_fiveDigits_accessCodeOk() {
		
		// Given
		let expectedState = AccessCodeViewState(
			bioMetricEnabled: true,
			bioMetricType: .touchID,
			eraseEnabled: true,
			backButtonVisible: false,
			title: "accesscode_validation_title",
			message: "accesscode_validation_body",
			messageType: .regular
		)
		let expectedBoxState = [
			AccessCodeViewModel.AccessCodeBoxState(id: 0, state: .filled),
			AccessCodeViewModel.AccessCodeBoxState(id: 1, state: .filled),
			AccessCodeViewModel.AccessCodeBoxState(id: 2, state: .filled),
			AccessCodeViewModel.AccessCodeBoxState(id: 3, state: .filled),
			AccessCodeViewModel.AccessCodeBoxState(id: 4, state: .filling)
		]
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
		expect(self.coordinatorSpy.invokedHandleParameters?.0).toEventually(equal(AppCoordination.Action.accessCodeValidated))
	}
}
