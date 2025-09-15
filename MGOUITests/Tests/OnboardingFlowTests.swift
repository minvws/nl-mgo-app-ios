/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
final class OnboardingFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the onboarding flow
	 - Verify the existence of the introduction page
	 - Press the next button on the introduction page, verify the proposition page
	 - Proceed to pin code entry, enter a pin code that is too weak
	 - Proceed to pin code entry, enter a pin code, proceed to pin code confirmation, enter a different pin code
	 - Proceed to pin code entry, enter a pin code, proceed to pin code confirmation, enter the same pin code
	 - Verify the login page
	 - Navigate to the login page, press digid button, verify the website in the browser
	 - Search for a healthcare organization, select the fourth entry
	 - Search for a healthcare organization in demo mode, select the third entry
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
			.verifySubHeadingExists("Je hebt een code van 5 cijfers nodig om de app te beveiligen. Gebruik geen simpele code zoals 00000 of 12345.")
			.enterPinCode("11111")
			.verifyErrorTextExists("Code is te simpel en dus onveilig")
	}
	
	@MainActor
	func testOnboardingFlow_pincodeConfirmation_differentPincode() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists("Je hebt een code van 5 cijfers nodig om de app te beveiligen. Gebruik geen simpele code zoals 00000 of 12345.")
			.enterPinCode("12369")
			.verifySubHeadingExists("Voer je 5-cijferige code nog een keer in.")
			.enterPinCode("11111")
			.verifyErrorTextExists("Code is anders dan de vorige")
	}
	
	@MainActor
	func testOnboardingFlow_pincodeConfirmation_matchingPincode() {
		
		AppRobot()
			.enableFaceID()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists("Je hebt een code van 5 cijfers nodig om de app te beveiligen. Gebruik geen simpele code zoals 00000 of 12345.")
			.enterPinCode("12369")
			.verifySubHeadingExists("Voer je 5-cijferige code nog een keer in.")
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
	
	@MainActor
	func testOnboardingFlow_demoMode_automaticLocalization() {
		
		AppRobot()
			.launchApp(withPincode: "12345", withAutomaticLocalizationEnabled: true, withDemoMode: true)
			.enterConfirmationPinCode("12345")
			.tapLoginWithDigiDButtonWithDemoMode()
			.verifySubHeadingExists()
			.verifyNextButtonExists()
			.tapNextButton()
			.verifyListElementExists(at: 0)
			.tapListElement(at: 0)
			.verifyListElementExists(at: 1)
			.tapListElement(at: 1)
			.verifyListElementExists(at: 2)
			.verifyOverviewButtonExists()
			.tapOverviewButton()
	}
}
