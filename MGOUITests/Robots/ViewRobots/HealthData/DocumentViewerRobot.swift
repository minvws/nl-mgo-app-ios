/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor class DocumentViewerRobot: Robot {
	
	/// The app to test
	let app: XCUIApplication
	
	/// Create a Document Viewer Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			titleButton.waitForExistence(timeout: timeOut),
			"Expected 'DocumentViewerRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var backButton: XCUIElement {
		app.buttons["Gereed"]
	}
	
	private var titleButton: XCUIElement {
		app.buttons["Example PDF - Anterior Cervical Discectomy Fusion - Discharge Summary, Takenmenu"]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyBackButtonExists() -> Self {
		XCTAssertTrue(backButton.exists)
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapBackButton() -> HealthUISchemaRobot {
		backButton.tap()
		return HealthUISchemaRobot(app)
	}
}
