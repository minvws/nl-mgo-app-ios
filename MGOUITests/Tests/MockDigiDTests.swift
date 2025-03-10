/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class MockDigiDTests: XCTestCase {
	
	@MainActor
	func testDigiD() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.tapDigiDButton()
			.verifySafariIsOpen()
			.verifyMockDigiDSubmitButton()
			.tapMockDigiDSubmitButton()
			.enterBasicAuthorizationIfNeeded()
			.verifyOpenButton()
			.tapOpenButton()
	}
}
