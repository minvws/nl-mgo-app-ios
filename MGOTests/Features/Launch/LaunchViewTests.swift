/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class LaunchViewTests: XCTestCase {
	
	private var servicesSpies: ServicesSpies!
	
	override func setUp() {
		
		servicesSpies = setupServicesSpies()
		super.setUp()
	}
	
	func createSut(state: LaunchViewModel.State) -> LaunchView {
		
		return LaunchView(
			viewModel: LaunchViewModel(
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
		assertSnapshot(of: sut.colorScheme(.light), as: .image(precision: 0.90)) // Lower precision due to
		assertSnapshot(of: sut.colorScheme(.dark), as: .image(precision: 0.90)) // random postion of spinner
	}
	
	func test_launch_stateLoadingConfig() {
		
		// Given
		let sut = createSut(state: .loadingConfig)
		
		// When
		
		// Then
		assertSnapshot(of: sut.colorScheme(.light), as: .image(precision: 0.90)) // Lower precision due to
		assertSnapshot(of: sut.colorScheme(.dark), as: .image(precision: 0.90)) // random postion of spinner
	}

	func test_launch_stateConfigLoaded() {
		
		// Given
		let sut = createSut(state: .configLoaded)
		
		// When
		
		// Then
		assertSnapshot(of: sut.colorScheme(.light), as: .image)
		assertSnapshot(of: sut.colorScheme(.dark), as: .image)
	}
}
