/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class PropositionRobot: Robot {
	
	/// Create a Proposition Robot
	init() {
		XCTAssertTrue(titleLabel.waitForExistence(timeout: 5), "Expected 'PropositionRobot' screen, but it didn't appear")
	}
	
	// MARK: - Elements
	
	private var nextButton: XCUIElement {
		Button.next.element
	}
	
	private var titleLabel: XCUIElement {
		Heading.proposition.element
	}

	private var subHeadingLabel: XCUIElement {
		SubHeading.proposition.element
	}
	
	private func proposition(label: String) -> XCUIElement {
		app.staticTexts[label]
	}

	// MARK: - Validations
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	@discardableResult
	func verifyPropositionExists(label: String) -> Self {
		XCTAssertTrue(proposition(label: label).exists)
		return self
	}

    // MARK: - Interactions

//    @discardableResult
//    func tapAddScrumButton() -> AddScrumRobot {
//        addScrumButton.tap()
//        return AddScrumRobot()
//    }
//
//    @discardableResult
//    func tapScrumCard(withTitle title: String) -> DetailScrumRobot {
//        scrumCard(withTitle: title).tap()
//        return DetailScrumRobot()
//    }
}
