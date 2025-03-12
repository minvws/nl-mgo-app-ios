/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

/// The Robot for the Mock DigiD scene
class MockDigiDRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// The default browser
	let safari: XCUIApplication
	
	/// Create an Mock DigiD Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		self.safari = XCUIApplication(bundleIdentifier: "com.apple.mobilesafari")
	}
	
	// MARK: - Elements
	
	private var mockDigiDSubmitButton: XCUIElement {
		safari.webViews.staticTexts["Login / Submit"]
	}
	
	private var openAppButton: XCUIElement {
		safari.buttons["Open"]
	}
	
	private var usernameTextField: XCUIElement {
		safari.otherElements["SFDialogView"].textFields.firstMatch
	}
	
	private var passwordTextField: XCUIElement {
		safari.otherElements["SFDialogView"].secureTextFields.firstMatch
	}
	
	private var signInButton: XCUIElement {
		safari.otherElements["SFDialogView"].staticTexts["Sign In"]
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
	
	@discardableResult
	func verifyMockDigiDSubmitButton() -> Self {
		XCTAssertTrue(mockDigiDSubmitButton.waitForExistence(timeout: timeOut))
		return self
	}
	
	@discardableResult
	func verifyOpenButton() -> Self {
		XCTAssertTrue(openAppButton.waitForExistence(timeout: timeOut))
		return self
	}

	// MARK: - Interactions
	
	@discardableResult
	func tapMockDigiDSubmitButton() -> Self {
		mockDigiDSubmitButton.tap()
		return self
	}
	
	@discardableResult
	func enterBasicAuthorizationIfNeeded() -> Self {
		
		guard let authUsername = ProcessInfo.processInfo.environment["MGO_BASIC_AUTH_USERNAME"],
			  let authPassword = ProcessInfo.processInfo.environment["MGO_BASIC_AUTH_PASSWORD"] else {
			return self
		}
		
		guard !openAppButton.exists else { return self }
		
		if usernameTextField.waitForExistence(timeout: timeOut) {
			
			usernameTextField.tap()
			usernameTextField.typeText(authUsername)
			
			passwordTextField.tap()
			passwordTextField.typeText(authPassword)
			
			signInButton.tap()
		}
		return self
	}
	
	@discardableResult
	func tapOpenButton() -> AddOrganizationRobot {
		openAppButton.tap()
		return AddOrganizationRobot(app)
	}
}
