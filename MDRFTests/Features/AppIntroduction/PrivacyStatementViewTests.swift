/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzTest
import GifzUI
@testable import MDRF

final class PrivacyStatementViewTests: XCTestCase {
	
	func test_showPrivacyStatementView_lightMode() {
		
		// Given
		let sut = PrivacyStatementView()
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.light), as: .image)
	}
	
	func test_showPrivacyStatmentView_darkMode() {
		
		// Given
		let sut = PrivacyStatementView()
		
		// When
		let content = NavigationView { sut }
			.frameAsiPhone15Pro()
		
		// Then
		assertSnapshot(of: content.colorScheme(.dark), as: .image)
	}
}
