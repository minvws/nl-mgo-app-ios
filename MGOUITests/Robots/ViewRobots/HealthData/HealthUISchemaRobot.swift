/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class HealthUISchemaRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Health UI Schema Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
	}
	
	// MARK: - Elements
	
	private func headingLabel(_ heading: String) -> XCUIElement {
		app.staticTexts[heading]
	}

	private func row(_ section: String) -> XCUIElement {
		let predicate = NSPredicate(format: "label LIKE '\(section)'")
		let label = app.staticTexts.element(matching: predicate)
		return label
	}
	
	private func referenceButton(_ identifier: String) -> XCUIElement {
		app.buttons[identifier]
	}
	
	private func detailsButton(_ identifier: String) -> XCUIElement {
		app.buttons[identifier]
	}
	
	private func attachmentButton(_ identifier: String) -> XCUIElement {
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
		XCTAssertTrue(row("\(heading), \(value)").exists, "can't find section row for \(heading) and \(value)")
		return self
	}
	
	@discardableResult
	func verifyReferenceButtonExists(_ heading: String, value: String) -> Self {
		XCTAssertTrue(referenceButton("\(heading), \(value)").exists, "can't find reference button \(heading)")
		return self
	}
	
	@discardableResult
	func verifySectionHeaderExists(_ heading: String) -> Self {
		XCTAssertTrue(headingLabel(heading).exists, "can't find section header \(heading)")
		return self
	}
	
	@discardableResult
	func verifyDetailButton(_ heading: String) -> Self {
		XCTAssertTrue(detailsButton(heading).exists, "can't find details button for \(heading)")
		return self
	}
	
	@discardableResult
	func verifyAttachmentButton(_ heading: String) -> Self {
		XCTAssertTrue(attachmentButton(heading).exists, "can't find attachment button for \(heading)")
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapNavigateToDetailsButton(_ heading: String) -> Self {
		detailsButton(heading).tap()
		return self
	}
	
	@discardableResult
	func tapAttachmentButton(_ heading: String) -> DocumentViewerRobot {
		attachmentButton(heading).tap()
		return DocumentViewerRobot(app)
	}
}
