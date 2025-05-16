/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

final class OnboardingFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the onboarding flow
	 - Verify the existence of the introduction page
	 - Press the next button on the introduction page, verify the proposition page
	 - Proceed to pincode entry, enter a pincode that is too weak
	 - Proceed to pincode entry, enter a pincode, proceed to pincode confirmation, enter a different pincode
	 - Proceed to pincode entry, enter a pincode, proceed to pincode confirmation, enter the same pincode
	 - Verify the login page
	 - Navigate to the login page, press digid button, verify the website in the browser
	 - Search for a healthcare organization, select the fourth entry
	 
	 */
	
	@MainActor
	func testOnboardingFlow_verifyIntroductionScreenExists() {
		AppRobot()
			.launchApp()
			.verifySubHeadingExists()
	}
	
	@MainActor
	func testOnboardingFlow_verifyPropositionScreenExists() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.verifySubHeadingExists()
			.verifyPropositionExists(label: "proposition.statement_1")
			.verifyPropositionExists(label: "proposition.statement_2")
			.verifyPropositionExists(label: "proposition.statement_3")
			.verifyPropositionExists(label: "proposition.statement_4")
	}
	
	@MainActor
	func testOnboardingFlow_pincodeEntry_tooWeak() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists("Je hebt een code van 5 cijfers nodig. Gebruik geen simpele codes zoals 00000 of 12345.")
			.enterPinCode("11111")
			.verifyErrorTextExists("Deze code is te simpel en dus onveilig")
	}
	
	@MainActor
	func testOnboardingFlow_pincodeConfirmation_differentPincode() {
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
	func testOnboardingFlow_pincodeConfirmation_matchingPincode() {
		
		AppRobot()
			.enableFaceID()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists("Je hebt een code van 5 cijfers nodig. Gebruik geen simpele codes zoals 00000 of 12345.")
			.enterPinCode("12369")
			.verifySubHeadingExists("Vul je toegangscode in om door te gaan")
			.enterConfirmationPinCodeWithBioMetric("12369")
			.verifySubHeadingExists()
			.verifyBioMetricsButtonExists()
			.verifySkipButtonExists()
			.tapSkipButton()
	}
	
	@MainActor
	func testOnboardingFlow_verifyLoginScreen() {
		AppRobot()
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.verifySubHeadingExists()
	}
	
	@MainActor
	func testOnboardingFlow_verifyMockDigiD() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.tapLoginWithDigiDButton()
			.verifySafariIsOpen()
			.verifyMockDigiDWebsite()
	}
	
	@MainActor
	func testOnboardingFlow_searchForHealthcareOrganization() {
		
		AppRobot()
			.launchApp(withPincode: "12345")
			.enterConfirmationPinCode("12345")
			.tapLoginWithDigiDButton()
			.performCompleteDigiDLogin()
			.verifyNameFieldExists()
			.verifyCityFieldExists()
			.enterSearchFields(name: "test", place: "test")
			.verifySearchButtonExists()
			.tapSearchButton()
			.swipeToListElement(at: 4)
			.verifyListElementExists(at: 4)
			.tapListElement(at: 4)
	}
}
