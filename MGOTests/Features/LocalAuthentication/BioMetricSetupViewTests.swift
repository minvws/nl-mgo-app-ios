/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	func test_bioMetricSetup_faceID() {
		
		// Given
		let sut = createSut(bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_bioMetricSetup_touchID() {
		
		// Given
		let sut = createSut(bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	func test_bioMetricSetup_opticID() {
		
		// Given
		let sut = createSut(bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
