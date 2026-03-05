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
	func testOnboardingFlow_verifyLoginScreen() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists()
	}
	
	@MainActor
	func testOnboardingFlow_verifyMockDigiD() {
		
		AppRobot()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.tapLoginWithDigiDButton()
			.verifySafariIsOpen()
			.verifyMockDigiDWebsite()
	}
}
