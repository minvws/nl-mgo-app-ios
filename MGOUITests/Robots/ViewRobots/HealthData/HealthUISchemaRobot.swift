/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class HealthUISchemaRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Health Categories Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application	}
	
	// MARK: - Elements
	
	private func headingLabel(_ heading: String) -> XCUIElement {
		app.staticTexts[heading]
	}

	private func row(_ section: String) -> XCUIElement {
		app.staticTexts[section]
	}
	
	private func referenceButton(_ identifier: String) -> XCUIElement {
		app.buttons[identifier]
	}
	
	private func detailsButton(_ identifier: String) -> XCUIElement {
		app.buttons[identifier]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyHeadingExists(_ heading: String) -> Self {
		XCTAssertTrue(headingLabel(heading).exists)
		return self
	}
	
	@discardableResult
	func verifySectionRowExists(_ heading: String, value: String) -> Self {
		XCTAssertTrue(row("\(heading), \(value)").exists)
		return self
	}
	
	@discardableResult
	func verifyReferenceButtonExists(_ heading: String, value: String) -> Self {
		XCTAssertTrue(referenceButton("\(heading), \(value)").exists)
		return self
	}
	
	@discardableResult
	func verifySectionHeaderExists(_ heading: String) -> Self {
		XCTAssertTrue(headingLabel(heading).exists)
		return self
	}
	
	@discardableResult
	func verifyDetailButton(_ heading: String) -> Self {
		XCTAssertTrue(detailsButton(heading).exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapNavigateToDetailsButton(_ heading: String) -> Self {
		detailsButton(heading).tap()
		return self
	}
}
