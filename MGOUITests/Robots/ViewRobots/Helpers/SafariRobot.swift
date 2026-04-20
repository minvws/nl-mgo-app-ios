/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// The Robot for Safari
@MainActor class SafariRobot: Robot {
	
	/// The app to test
	let app: XCUIApplication
	
	/// The default browser
	let safari: XCUIApplication
	
	/// Create an Mock DigiD Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		self.safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifySafariIsOpen() -> Self {
		XCTAssertTrue(
			safari.wait(for: .runningForeground, timeout: timeOut),
			"Expected Safari screen to open, but it didn't"
		)
		return self
	}
}
