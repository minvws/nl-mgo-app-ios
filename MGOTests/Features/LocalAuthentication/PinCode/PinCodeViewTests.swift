/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOTest
import MGOUI
@testable import MGO

final class PinCodeViewTests: XCTestCase {

	private var strengthMeterSpy: PinCodeStrengthValidationSpy!
	private var coordinatorSpy: AppCoordinatorSpy!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		strengthMeterSpy = PinCodeStrengthValidationSpy()
		servicesSpies = setupServicesSpies()
		servicesSpies.secureUserSettingsSpy.stubbedBioMetricAuthenticationEnabled = true
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func createSut(mode: PinCodeViewModel.PinCodeMode = .creation, bioMetricType: () -> LocalAuthentication.BiometricType) -> PinCodeView {
		
		let viewModel = PinCodeViewModel(
			coordinator: coordinatorSpy,
			mode: mode,
			pinLimit: 5,
			bioMetricType: bioMetricType,
			strengthMeter: strengthMeterSpy
		)
		
		return PinCodeView(
			viewModel: viewModel
		)
	}

	// MARK: - Creation Mode -
	
	func test_creation_noBioMetric() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .none })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_creation_touch() throws {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
		for index in 1...5 {
			let label = try sut.inspect().find(viewWithAccessibilityIdentifier: "box \(index)").accessibilityLabel().string()
			if index == 1 {
				expect(label) == "Veld \(index) van 5, Actief"
			} else {
				expect(label) == "Veld \(index) van 5, Leeg"
			}
		}
	}
	
	func test_creation_face() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_creation_vision() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_creation_touch_twoDigits() throws {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "2").tap()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
		for index in 1...5 {
			let label = try sut.inspect().find(viewWithAccessibilityIdentifier: "box \(index)").accessibilityLabel().string()
			if index < 3 {
				expect(label) == "Veld \(index) van 5, Gevuld"
			} else if index == 3 {
				expect(label) == "Veld \(index) van 5, Actief"
			} else {
				expect(label) == "Veld \(index) van 5, Leeg"
			}
		}
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
		takeSnapShots(content: content)
		for index in 1...5 {
			let label = try sut.inspect().find(viewWithAccessibilityIdentifier: "box \(index)").accessibilityLabel().string()
			if index == 5 {
				expect(label) == "Veld \(index) van 5, Actief"
			} else {
				expect(label) == "Veld \(index) van 5, Gevuld"
			}
		}
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
		takeSnapShots(content: content)
		for index in 1...5 {
			let label = try sut.inspect().find(viewWithAccessibilityIdentifier: "box \(index)").accessibilityLabel().string()
			expect(label) == "Veld \(index) van 5, Foutief"
		}
	}
	
	// MARK: - Confirmation Mode -
	
	func test_confirmation_noBioMetric() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .none })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_confirmation_touch() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_confirmation_face_lightMode() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_confirmation_vison() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_confirmation_touch_fiveDigits_different() throws {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedTempPinCode = "12345"
		let sut = createSut(mode: .confirmation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	// MARK: - Validation Mode -
	
	func test_validation_noBioMetric() {
		
		// Given
		let sut = createSut(mode: .validation(lockOut: false), bioMetricType: { .none })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_validation_touch() {
		
		// Given
		let sut = createSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_validation_face() {
		
		// Given
		let sut = createSut(mode: .validation(lockOut: false), bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_validation_vison() {
		
		// Given
		let sut = createSut(mode: .validation(lockOut: false), bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_validation_touch_fiveDigits_different() throws {
		
		// Given
		servicesSpies.secureUserSettingsSpy.stubbedPinCode = "12345"
		let sut = createSut(mode: .validation(lockOut: false), bioMetricType: { .touchID })
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "1").tap()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
