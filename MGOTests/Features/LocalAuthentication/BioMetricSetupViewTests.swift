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

class BioMetricSetupViewTests: XCTestCase {
	
	private var coordinatorSpy: AppCoordinatorSpy!
	private var sut: BioMetricSetupView!
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		coordinatorSpy = AppCoordinatorSpy()
		super.setUp()
	}
	
	func createSut(bioMetricType: () -> LocalAuthentication.BiometricType) -> BioMetricSetupView {
		
		let viewModel = BioMetricSetupViewModel(coordinator: coordinatorSpy, bioMetricType: bioMetricType)
		
		return BioMetricSetupView(
			viewModel: viewModel
		)
	}
	
	func test_bioMetricSetup_faceID_ligthMode() {
		
		// Given
		let sut = createSut(bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}

	func test_bioMetricSetup_faceID_darkMode() {
		
		// Given
		let sut = createSut(bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
	}
	
	func test_bioMetricSetup_touchID_ligthMode() {
		
		// Given
		let sut = createSut(bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}

	func test_bioMetricSetup_touchID_darkMode() {
		
		// Given
		let sut = createSut(bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
	}
	
	func test_bioMetricSetup_opticID_ligthMode() {
		
		// Given
		let sut = createSut(bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}

	func test_bioMetricSetup_opticID_darkMode() {
		
		// Given
		let sut = createSut(bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
	}
}
