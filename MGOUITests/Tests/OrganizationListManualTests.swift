/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class OrganizationListManualTests: XCTestCase {
	
	@MainActor
	func testOrganizationListManualInOnboarding() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.tapDigiDButton()
			.tapMockDigiDSubmitButton()
			.enterBasicAuthorizationIfNeeded()
			.tapOpenButton()
			.enterSearchFields(name: "test", place: "test")
			.tapSearchButton()
			.verifyListElementExists(at: 4)
			.tapListElement(at: 4)
	}
}
