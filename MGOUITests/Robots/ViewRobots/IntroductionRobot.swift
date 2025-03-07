/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class IntroductionRobot: Robot {
	
	/// Create an Introduction Robot
	init() {
		XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "Expected 'IntroductionRobot' screen, but it didn't appear")
	}
	
	// MARK: - Elements
	
	private var nextButton: XCUIElement {
		Button.next.element
	}
	
	private var titleLabel: XCUIElement {
		Heading.introduction.element
	}
	
	private var subHeadingLabel: XCUIElement {
		SubHeading.introduction.element
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapNextButton() -> PropositionRobot {
		nextButton.tap()
		return PropositionRobot()
	}
}
