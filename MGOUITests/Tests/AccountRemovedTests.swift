/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AccountRemovedTests: XCTestCase {
	
	@MainActor
	func testAccountRemovedFlow() {
		AppRobot()
			.launchApp(withPincode: "12345")
			.tapForgotButton()
			.tapNewAccountButton()
			.tapAlertOkButton()
			.verifySubHeadingExists()
			.verifyOkButtonExists()
			.tapOkButton()
	}
}
