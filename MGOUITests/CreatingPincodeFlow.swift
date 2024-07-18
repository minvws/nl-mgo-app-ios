/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class CreatingPincodeFlow: BaseFlowTest {
	
	func test_creatingPincodeFlow_pincodeTooWeak() {
		
		navigateThroughOnboarding()
		
		// Create
		enterPinCode("11111")
		
		app.textExists("Deze persoonlijke toegangscode is niet veilig genoeg. Gebruik geen cijfers die na elkaar komen.")
	}
	
	func test_creatingPincodeFlow_pincodeDoesNotMatch() {
		
		navigateThroughOnboarding()
		
		// Create
		enterPinCode("12369")
		
		// Confirm
		enterPinCode("11111")
		
		app.textExists("Deze persoonlijke toegangscode is niet dezelfde als de vorige. Voer de juiste code in om door te gaan.")
	}
	
	func test_creatingPincodeFlow_pincodeConfirmed() {
		
		navigateThroughOnboarding()
		
		// Create
		enterPinCode("12369")
		
		// Confirm
		enterPinCode("12369")
		
		assertLoginScreen()
	}
	
	func test_createPincodeFlow_accessibilityAudit() {
		
		navigateThroughOnboarding()
		app.accessibilityAudit()
	}
}

// MARK: - Assertions -

extension BaseFlowTest {
	
	/// Are we on the pincode screen?
	func assertPincodeScreen() {
		
		app.textExists("pincode.heading")
	}
	
	/// Are we on the proposition screen?
	func assertPropositionScreen() {
		
		app.textExists("proposition.heading")
	}
	
	/// Are we on the login screen?
	func assertLoginScreen() {
		
		app.textExists("login.heading")
		app.textExists("login.subheading")
	}
}

// MARK: - Actions - 

extension BaseFlowTest {
	
	/// Enter the pincode
	/// - Parameter code: the pincode
	func enterPinCode(_ code: String) {
		
		for element in Array(code) {
			app.buttons[String(element)].tap()
		}
	}
	
	func navigateThroughOnboarding() {
		
		assertIntroductionScreen()
		app.buttons["common.next"].tap()
		assertPropositionScreen()
		app.buttons["common.next"].tap()
		assertPincodeScreen()
	}
}
