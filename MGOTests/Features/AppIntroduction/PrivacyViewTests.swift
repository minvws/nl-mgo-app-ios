/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzTest
import GifzUI
@testable import MGO

final class PrivacyViewTests: XCTestCase {
	
	func createSut() -> PrivacyView {
		
		return PrivacyView(
			viewModel: PrivacyViewModel(
				coordinator: nil
			)
		)
	}
	
	func test_showPrivacyView_lightMode() {
		
		// Given
		let sut = createSut()
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
	
	func test_showPrivacyView_darkMode() {
		
		// Given
		let sut = createSut()
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
	}
}
