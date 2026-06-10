/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor class HealthUISchemaRobot: Robot {
	
	/// The app to test
	let app: XCUIApplication
	
	/// Create an Health UI Schema Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
	}
	
	// MARK: - Elements
	
	private func headingLabel(_ heading: String) -> XCUIElement {
		app.staticTexts[String(heading.prefix(128))]
	}
	
	private func row(_ section: String) -> XCUIElement {
		return app.textViews[String(section.prefix(128))]
	}
	
	private func referenceButton(_ identifier: String) -> XCUIElement {
		app.buttons[String(identifier.prefix(128))]
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
		XCTAssertTrue(row(heading).exists, "can't find section heading for \(heading)")
		XCTAssertTrue(row(value).exists, "can't find section value for \(value)")
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
	
	@discardableResult
	func swipeDownToSection(_ name: String) -> Self {
		
		while !app.staticTexts[name].exists {
			app.swipeUp()
		}
		
		return self
	}
	
	@discardableResult
	func swipeDownToRowHeading(_ heading: String) -> Self {
		
		while !app.textViews[String(heading.prefix(128))].exists {
			app.swipeUp()
		}
		
		return self
	}
	
	@discardableResult
	func swipeDownToReferenceButton(_ heading: String, value: String) -> Self {
		
		while !referenceButton("\(heading), \(value)").exists {
			app.swipeUp()
		}
		
		return self
	}
	
	@discardableResult
	func tapExportPdf() -> HealthExportRobot {
		app.buttons["export_pdf.menu"].tap()
		app.buttons["Maak pdf"].tap()
		return HealthExportRobot(app)
	}
}
