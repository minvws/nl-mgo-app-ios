/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class PrivacyOverviewViewTests: XCTestCase {
	
	func createSut() -> PrivacyOverviewView {
		
		return PrivacyOverviewView(
			viewModel: PrivacyOverviewViewModel(
				coordinator: nil
			)
		)
	}
	
	func test_showPrivacyOverviewView() {
		
		// Given
		let sut = createSut()
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content, name: "test_showPrivacyOverviewView")
	}
}
