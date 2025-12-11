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
	
	@MainActor func createSut(bioMetricType: () -> LocalAuthentication.BiometricType) -> BioMetricSetupView {
		
		let viewModel = BioMetricSetupViewModel(coordinator: coordinatorSpy, bioMetricType: bioMetricType)
		
		return BioMetricSetupView(
			viewModel: viewModel
		)
	}
	
	@MainActor func test_bioMetricSetup_faceID() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let sut = createSut(bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_bioMetricSetup_faceID_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		let sut = createSut(bioMetricType: { .faceID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_bioMetricSetup_touchID() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let sut = createSut(bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_bioMetricSetup_touchID_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		let sut = createSut(bioMetricType: { .touchID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_bioMetricSetup_opticID() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerTrue() }
		let sut = createSut(bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor func test_bioMetricSetup_opticID_iOS18() {
		
		// Given
		Container.shared.osVersionChecker.register { OSVersionCheckerFalse() }
		let sut = createSut(bioMetricType: { .opticID })
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
