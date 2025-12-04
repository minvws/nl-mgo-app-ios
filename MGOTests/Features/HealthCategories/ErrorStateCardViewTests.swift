/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class ErrorStateCardViewTests: XCTestCase {
	
	func test_loading() {
		
		// Given
		let sut = ErrorStateCardView(state: .loading)
		
		// When
		let content = sut.frame(width: 380, height: 200)
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: content, precision: 0.95)
	}
	
	func test_error() {
		
		// Given
		let sut = ErrorStateCardView(
			state: .error(
				heading: "Er is een probleem",
				subHeading: "Probeer het later nog een keer."
			)
		)
		
		// When
		let content = sut.frame(width: 380, height: 200)
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: content)
	}
}
