/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor class HealthExportRobot: Robot {

	/// The app to test
	let app: XCUIApplication

	/// Create a Health Export Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			app.buttons["export_pdf.close"].waitForExistence(timeout: timeOut),
			"Expected 'HealthExportRobot' screen, but it didn't appear"
		)
	}

	// MARK: - Elements

	private var closeButton: XCUIElement {
		app.buttons["export_pdf.close"]
	}

	private var shareButton: XCUIElement {
		app.buttons["export_pdf.share"]
	}

	// MARK: - Validations

	@discardableResult
	func verifyShareButtonExists() -> Self {
		XCTAssertTrue(shareButton.waitForExistence(timeout: timeOut))
		return self
	}

	// MARK: - Interactions

	@discardableResult
	func close() -> HealthCategoryRobot {
		closeButton.tap()
		return HealthCategoryRobot(app)
	}
}
