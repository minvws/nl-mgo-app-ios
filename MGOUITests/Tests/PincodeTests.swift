/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class PincodeTests: XCTestCase {
	
	@MainActor
	func testPincodeCreationTooWeak() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists("Je hebt een code van 5 cijfers nodig. Gebruik geen simpele codes zoals 00000 of 12345.")
			.enterPinCode("11111")
			.verifyErrorTextExists("Deze code is te simpel en dus onveilig")
	}
	
	@MainActor
	func testPincodeConfirmationDoesNotMatch() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists("Je hebt een code van 5 cijfers nodig. Gebruik geen simpele codes zoals 00000 of 12345.")
			.enterPinCode("12369")
			.verifySubHeadingExists("Vul je toegangscode in om door te gaan")
			.enterPinCode("11111")
			.verifyErrorTextExists("Deze code is anders dan de vorige")
	}
	
	@MainActor
	func testPincodeConfirmationDoesMatch() {
		
		AppRobot()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists("Je hebt een code van 5 cijfers nodig. Gebruik geen simpele codes zoals 00000 of 12345.")
			.enterPinCode("12369")
			.verifySubHeadingExists("Vul je toegangscode in om door te gaan")
			.enterConfirmationPinCode("12369")
	}
}
