/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzTest
import GifzUI
@testable import MDRF

final class AppIntroductionViewTests: XCTestCase {
	
	func createSut() -> AppIntroductionView {
		
		return AppIntroductionView(
			viewModel: AppIntroductionViewModel(
				coordinator: nil
			)
		)
	}
	
	func xx_test_appIntroductionView_lightMode() {
		
		// Given
		let sut = createSut()
		
		// When
		let content = NavigationView { sut }
			.frame(width: 393, height: 852)
		
		// Then
		assertSnapshot(of: sut.colorScheme(.light), as: .image)
	}
	
	func xx_test_appIntroductionView_darkMode() {
		
		// Given
		let sut = createSut()
		
		// When
		let content = NavigationView { sut }
			.frame(width: 393, height: 852)
		
		// Then
		assertSnapshot(of: sut.colorScheme(.dark), as: .image)
	}
}
