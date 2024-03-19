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

	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: AccessCodeViewModel!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func createSut(mode: AccessCodeViewModel.AccessCodeMode = .creation, bioMetricType: () -> LocalAuthentication.BiometricType) -> AccessCodeView {
		
		let viewModel = AccessCodeViewModel(coordinator: coordinatorSpy, mode: mode, pinLimit: 5, bioMetricType: bioMetricType)
		
		return AccessCodeView(
			viewModel: viewModel
		)
	}

	func test_creation_touch_lightMode() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
	
	func test_creation_touch_darkMode() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
	}
	
	func test_creation_face_lightMode() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
	
	func test_creation_face_darkMode() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
	}
	
	func test_creation_vision_lightMode() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
	
	func test_creation_vision_darkMode() {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
	}
	
	func test_creation_touch_twoDigits() throws {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "1").tap()
		try sut.inspect().find(button: "2").tap()
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
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
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
	
	func test_creation_touch_fiveDigits_tooWeak() throws {
		
		// Given
		let sut = createSut(mode: .creation, bioMetricType: { .touchID })
		try sut.inspect().find(button: "0").tap()
		try sut.inspect().find(button: "0").tap()
		try sut.inspect().find(button: "0").tap()
		try sut.inspect().find(button: "0").tap()
		try sut.inspect().find(button: "0").tap()
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
	
	func test_confirmation_touch_lightMode() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
	
	func test_confirmation_touch_darkMode() {
		
		// Given
		let sut = createSut(mode: .confirmation, bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
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
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
}
