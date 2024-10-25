/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class SplashViewTests: XCTestCase {
	
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		super.setUp()
	}
	
	func createSut(state: SplashViewModel.State) -> SplashView {
		
		return SplashView(
			viewModel: SplashViewModel(
				coordinator: nil,
				state: state
			)
		)
	}
	
	func test_launch_stateIdle() {
	
		// Given
		let sut = createSut(state: .idle)
		
		// When
		
		// Then
		takeSnapShots(content: sut)
	}
	
	func test_launch_stateLoadingConfig() {
		
		// Given
		let sut = createSut(state: .loadingConfig)
		
		// When
		
		// Then
		takeSnapShots(content: sut)
	}

	func test_launch_stateConfigLoaded() {
		
		// Given
		let sut = createSut(state: .configLoaded)
		
		// When
		
		// Then
		takeSnapShots(content: sut)
	}
}
