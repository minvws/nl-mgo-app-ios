/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

protocol Robot {
	
	/// The application to test
	var app: XCUIApplication { get }
}

@MainActor
extension Robot {

	var timeOut: Double {
		return 15
	}

	private var screenshotTriggerButton: XCUIElement {
		app.buttons["debug.screenshot.trigger"]
	}

	private var screenshotAlertAction: XCUIElement {
		app.buttons["OK"].buttons["screenshotalert.action"].firstMatch
	}

	@discardableResult
	func triggerScreenshot() -> Self {
		XCTAssertTrue(screenshotTriggerButton.waitForExistence(timeout: timeOut))
		screenshotTriggerButton.tap()
		return self
	}

	@discardableResult
	func verifyScreenshotAlertExists() -> Self {
		XCTAssertTrue(screenshotAlertAction.waitForExistence(timeout: timeOut))
		return self
	}

	@discardableResult
	func tapScreenshotAlertAction() -> Self {
		screenshotAlertAction.tap()
		return self
	}
}
