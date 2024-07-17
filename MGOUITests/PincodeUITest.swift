/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class PincodeUITests: BaseUITest {
	
	private func handleOnboarding() {
		
		app.textExists("introduction.heading")
		app.buttons["common.next"].tap()
		app.textExists("proposition.heading")
		app.buttons["common.next"].tap()
	}
	
	private func enterPinCode(code: [String]) {
		
		for element in code {
			app.buttons[element].tap()
		}
	}
	
	func test_pincodeTooWeak() {
		
		// Flow trough Onboarding
		handleOnboarding()
		
		// Create
		enterPinCode(code: ["1", "1", "1", "1", "1"])
		
		app.textExists("Deze persoonlijke toegangscode is niet veilig genoeg. Gebruik geen cijfers die na elkaar komen.")
	}
	
	func test_pincodeDoesNotMatch() {
		
		// Flow trough Onboarding
		handleOnboarding()
		
		// Create
		enterPinCode(code: ["1", "2", "3", "6", "9"])
		
		// Confirm
		enterPinCode(code: ["1", "1", "1", "1", "1"])
		
		app.textExists("Deze persoonlijke toegangscode is niet dezelfde als de vorige. Voer de juiste code in om door te gaan.")
	}
	
	func test_pincodeConfirmed() {
		
		// Flow trough Onboarding
		handleOnboarding()
		
		// Create
		enterPinCode(code: ["1", "2", "3", "6", "9"])
		
		// Confirm
		enterPinCode(code: ["1", "2", "3", "6", "9"])
		
		// Assert Login Page
		app.textExists("login.heading")
		app.textExists("login.subheading")
	}
}
