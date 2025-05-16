/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class BioMetricSetupRobot: Robot {
	
	/// The app to test
	var app: XCUIApplication
	
	/// Create an Bio Metrics Robot
	/// - Parameter application: the application to test
	init(_ application: XCUIApplication) {
		
		self.app = application
		XCTAssertTrue(
			titleLabel.waitForExistence(timeout: timeOut),
			"Expected 'BioMetricsRobot' screen, but it didn't appear"
		)
	}
	
	// MARK: - Elements
	
	private var biometricButton: XCUIElement {
		app.buttons["biometric_setup.button.with_biometric"]
	}
	
	private var skipButton: XCUIElement {
		app.buttons["common.skip"]
	}
	
	private var subHeadingLabel: XCUIElement {
		app.staticTexts["biometric_setup.subheading"]
	}
	
	private var titleLabel: XCUIElement {
		app.staticTexts["biometric_setup.heading"]
	}
	
	// MARK: - Validations
	
	@discardableResult
	func verifyBioMetricsButtonExists() -> Self {
		XCTAssertTrue(biometricButton.exists)
		return self
	}
	
	@discardableResult
	func verifySkipButtonExists() -> Self {
		XCTAssertTrue(skipButton.exists)
		return self
	}
	
	@discardableResult
	func verifySubHeadingExists() -> Self {
		XCTAssertTrue(subHeadingLabel.exists)
		return self
	}
	
	// MARK: - Interactions
	
	@discardableResult
	func tapSkipButton() -> LoginRobot {
		skipButton.tap()
		return LoginRobot(app)
	}
}
