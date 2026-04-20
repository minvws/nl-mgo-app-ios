/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
final class OnboardingFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the onboarding flow
	 ✅ Verify the introduction page
	 ✅ Verify the proposition page, verify the privacy page
	 ✅ Verify the login page, verify the mock digid page
	 */
	
	@MainActor
	func testOnboardingFlow_verifyIntroductionScreen() {
		AppRobot()
			.launchApp()
			.verifySubHeadingExists()
	}
	
	@MainActor
	func testOnboardingFlow_verifyPropositionScreen_verifyPrivacy() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.verifySubHeadingExists()
			.verifyPropositionExists(label: "proposition.statement_1")
			.verifyPropositionExists(label: "proposition.statement_2")
			.verifyPropositionExists(label: "proposition.statement_3")
			.verifyPropositionExists(label: "proposition.statement_4")
			.tapPrivacyButton()
			.verifyWebViewExists()
			.verifySafariButtonExists()
			.tapCloseButton()
	}
	
	@MainActor
	func testOnboardingFlow_verifyLoginScreen() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.tapNextButton()
			.verifySubHeadingExists()
			.tapLoginWithDigiDButton()
			.verifySafariIsOpen()
			.verifyMockDigiDWebsite()
	}
}
