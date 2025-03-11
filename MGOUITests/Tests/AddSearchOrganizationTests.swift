/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class AddSearchOrganizationTests: XCTestCase {
	
	@MainActor
	func testSearchInOnboarding() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.tapDigiDButton()
			.tapMockDigiDSubmitButton()
			.enterBasicAuthorizationIfNeeded()
			.tapOpenButton()
			.verifyNameFieldExists()
			.verifyCityFieldExists()
			.enterSearchFields(name: "test", place: "test")
	}
}
