/*
* Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import GifzTest
import GifzUI
@testable import MDRF

final class LaunchViewTests: XCTestCase {
	
	func createSut(state: LaunchViewModel.State) -> LaunchView {
		
		return LaunchView(
			viewModel: LaunchViewModel(
				coordinator: nil,
				state: state
			)
		)
	}
	
	func test_launch_stateIdle_lightMode() {
		
		// Given
		let sut = createSut(state: .idle)
		
		// When
		
		// Then
		assertSnapshot(of: sut.colorScheme(.light), as: .image)
	}
	
	func test_launch_stateIdle_darkMode() {
		
		// Given
		let sut = createSut(state: .idle)
		
		// When
		
		// Then
		assertSnapshot(of: sut.colorScheme(.dark), as: .image)
	}
	
	func test_launch_stateLoadingConfig_lightMode() {
		
		// Given
		let sut = createSut(state: .loadingConfig)
		
		// When
		
		// Then
		assertSnapshot(of: sut.colorScheme(.light), as: .image)
	}
	
	func test_launch_stateLoadingConfig_darkMode() {
		
		// Given
		let sut = createSut(state: .loadingConfig)
		
		// When
		
		// Then
		assertSnapshot(of: sut.colorScheme(.dark), as: .image)
	}

	func test_launch_stateConfigLoaded_lightMode() {
		
		// Given
		let sut = createSut(state: .configLoaded)
		
		// When
		
		// Then
		assertSnapshot(of: sut.colorScheme(.light), as: .image)
	}
	
	func test_launch_stateConfigLoaded_darkMode() {
		
		// Given
		let sut = createSut(state: .configLoaded)
		
		// When
		
		// Then
		assertSnapshot(of: sut.colorScheme(.dark), as: .image)
	}

}
