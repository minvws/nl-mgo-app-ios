/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOUI
@testable import MGO

final class PrivacyStatementViewTests: XCTestCase {
	
	var sut: PrivacyStatementView!
	
	override func setUp() {
		
		sut = PrivacyStatementView(
			viewModel: PrivacyStatementViewModel(
				coordinator: nil
			)
		)
	}
	
	func test_showPrivacyStatementView() {
		
		// Given
		
		// When
		let content = NavigationView { sut }
		
		// Then
		takeSnapShots(content: content)
	}
}
