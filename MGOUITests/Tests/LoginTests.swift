/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class LoginTests: XCTestCase {
	
	@MainActor
	func testLoginScreen() {
		AppRobot()
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.verifySubHeadingExists()
	}
}
