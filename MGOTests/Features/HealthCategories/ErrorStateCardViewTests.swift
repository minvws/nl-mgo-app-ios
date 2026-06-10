/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOTest
import MGOFoundation
import MGOUI
@testable import MGO

final class ErrorStateCardViewTests: XCTestCase {
	
	@MainActor
	func test_loading() {
		
		// Given
		let sut = ErrorStateCardView(state: .loading)
		
		// When
		let content = sut.frame(width: 380, height: 200)
			.background(Theme().backgrounds.primary)
		
		// Then
		takeSnapShots(content: content)
	}
	
	@MainActor
	func test_error() throws {
		
		// Given
		let headingText = "Er is een probleem"
		let subHeadingText = "Probeer het later nog een keer."
		let sut = ErrorStateCardView(
			state: .error(
				heading: headingText,
				subHeading: subHeadingText
			)
		)
		
		// When
		let heading = try sut.inspect().find(text: headingText).string()
		let subHeading = try sut.inspect().find(text: subHeadingText).string()
		let callToActionButton = try sut.inspect()
			.find(viewWithAccessibilityIdentifier: "common.try_again")
		let button = try callToActionButton.view(CallToActionButton.self)
			.find(button: "common.try_again")
		
		// Then
		expect(heading) == headingText
		expect(subHeading) == subHeadingText
		expect(button) != nil
	}
}
