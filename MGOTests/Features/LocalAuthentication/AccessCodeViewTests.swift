/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class AccessCodeViewTests: XCTestCase {

	private var strengthMeterSpy: AccessCodeStrengthValidationSpy!
	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		strengthMeterSpy = AccessCodeStrengthValidationSpy()
		servicesSpies = setupServicesSpies()
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = true
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func createSut(mode: AccessCodeViewModel.AccessCodeMode = .creation, bioMetricType: () -> LocalAuthentication.BiometricType) -> AccessCodeView {
		
		let viewModel = AccessCodeViewModel(
			coordinator: coordinatorSpy,
			mode: mode,
			pinLimit: 5,
			bioMetricType: bioMetricType,
			strengthMeter: strengthMeterSpy
		)
		
		return AccessCodeView(
			viewModel: viewModel
		)
	}

	// MARK: - Creation Mode -
	
	func test_creation_noBioMetric_lightMode() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .none })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_creation_noBioMetric")
	}
	
	func test_creation_touch() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_creation_touch")
	}
	
	func test_creation_face() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_creation_face")
	}
	
	func test_creation_vision() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_creation_vision")
	}
	
	func test_creation_touch_twoDigits() throws {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "2").tap()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_creation_touch_twoDigits")
	}
	
	func test_creation_touch_fourDigits() throws {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "2").tap()
		try sut.inspect().find(button: "2").tap()
		try sut.inspect().find(button: "2").tap()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_creation_touch_fourDigits")
	}
	
	func test_creation_touch_fiveDigits_tooWeak() throws {
		
		// Given
		strengthMeterSpy.stubbedValidateResult = false
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "0").tap()
		try sut.inspect().find(button: "0").tap()
		try sut.inspect().find(button: "0").tap()
		try sut.inspect().find(button: "0").tap()
		try sut.inspect().find(button: "0").tap()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_creation_touch_fiveDigits_tooWeak")
	}
	
	// MARK: - Confirmation Mode -
	
	func test_confirmation_noBioMetric() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .none })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_confirmation_noBioMetric")
	}
	
	func test_confirmation_touch() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_confirmation_touch")
	}
	
	func test_confirmation_face_lightMode() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_confirmation_face")
	}
	
	func test_confirmation_vison() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_confirmation_vison")
	}
	
	func test_confirmation_touch_fiveDigits_different() throws {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedTempAccessCode = "12345"
		let sut = createSut(mode: .confirmation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_confirmation_touch_fiveDigits_different")
	}
	
	// MARK: - Validation Mode -
	
	func test_validation_noBioMetric() {
		
		// Given
		let sut = createSut(mode: .validation, bioMetricType: { .none })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_validation_noBioMetric")
	}
	
	func test_validation_touch() {
		
		// Given
		let sut = createSut(mode: .validation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_validation_touch")
	}
	
	func test_validation_face() {
		
		// Given
		let sut = createSut(mode: .validation, bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_validation_face")
	}
	
	func test_validation_vison() {
		
		// Given
		let sut = createSut(mode: .validation, bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_validation_vison")
	}
	
	func test_validation_touch_fiveDigits_different() throws {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedAccessCode = "12345"
		let sut = createSut(mode: .validation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: sut, name: "test_validation_touch_fiveDigits_different")
	}
}
