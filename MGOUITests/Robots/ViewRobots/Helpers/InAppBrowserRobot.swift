/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// The Robot for the In App Browser scene
@MainActor class InAppBrowserRobot: Robot {

	/// The app to test
	let app: XCUIApplication

	/// Create a Restricted Browser Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		self.app = application
		XCTAssertTrue(
			webView.waitForExistence(timeout: timeOut),
			"Expected 'InAppBrowserRobot' screen, but it didn't appear"
		)
	}

	// MARK: - Elements

	private var webView: XCUIElement {
		app.webViews["restrictedBrowserView"]
	}

	private var closeButton: XCUIElement {
		app.buttons["common.close"]
	}

	private var safariButton: XCUIElement {
		app.buttons["safariButton"]
	}
	
	private var screenshotTriggerButton: XCUIElement {
		app.navigationBars.buttons["debug.screenshot.trigger"]
	}

	// MARK: - Validations

	@discardableResult
	func verifyWebViewExists() -> Self {
		XCTAssertTrue(webView.exists)
		return self
	}

	@discardableResult
	func verifySafariButtonExists() -> Self {
		XCTAssertTrue(safariButton.exists)
		return self
	}

	// MARK: - Interactions

	@discardableResult
	func tapCloseButton() -> AboutTheAppRobot {
		closeButton.tap()
		return AboutTheAppRobot(app)
	}
	
	@discardableResult
	func tapCloseButtonProposition() -> PropositionRobot {
		closeButton.tap()
		return PropositionRobot(app)
	}

	@discardableResult
	func triggerScreenshot() -> Self {
		XCTAssertTrue(screenshotTriggerButton.waitForExistence(timeout: timeOut))
		screenshotTriggerButton.tap()
		return self
	}

	@discardableResult
	func tapSafariButton() -> SafariRobot {
		safariButton.tap()
		return SafariRobot(app)
	}
}
