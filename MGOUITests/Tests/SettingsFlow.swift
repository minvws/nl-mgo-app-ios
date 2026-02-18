/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
final class SettingsFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the settings flow
	 - Verify the existence of the settings tab
	 - Verify the display settings
	 - Verify the security settings (investigate)
	 - Verify the advanced settings
	 - Verify the about the app page and its sub pages (version, safety tips, open source libraries, accessibility and privacy)
	 - Verify the lock option
	 - Verify the reset option
	 */
	
	@MainActor
	func testSettingsFlow_verifySettingsTab() {
		
		AppRobot()
			.navigateToOverview()
			.tapSettingsTab()
			.verifyDisplayButtonExists()
			.verifyAdvancedButtonExists()
			.verifyAboutTheAppButtonExists()
			.verifyResetApplicationButtonExists()
	}
	
	@MainActor
	func testSettingsFlow_displaySettings() {
		
		AppRobot()
			.navigateToOverview()
			.tapSettingsTab()
			.verifyDisplayButtonExists()
			.tapDisplayButton()
			.verifyDarkButtonExists()
			.tapDarkButton()
			.verifyLightButtonExists()
			.tapLightButton()
			.verifySystemButtonExists()
			.tapSystemButton()
			.verifyPreviousButtonExists()
			.tapPreviousButton()
	}
	
	@MainActor
	func testSettingsFlow_advancedSettings() {
		
		AppRobot()
			.navigateToOverview()
			.tapSettingsTab()
			.verifyAdvancedButtonExists()
			.tapAdvancedButton()
			.verifyAutomaticLocalizationSwitchExists()
			.verifyPincodeSwitchExists()
			.verifyPreviousButtonExists()
			.tapPreviousButton()
	}
	
	@MainActor
	func testSettingsFlow_aboutTheApp() {
		
		AppRobot()
			.navigateToOverview()
			.tapSettingsTab()
			.verifyAboutTheAppButtonExists()
			.tapAboutTheAppButton()
			.verifyLogoExists()
			.verifyAboutTheAppTitleExists()
			.verifyVersionButtonExists()
			.tapVersionButton()
			.verifyPreviousButtonExists()
			.tapPreviousButton()
			.verifySafetyTipsButtonExists()
			.tapAboutSafetyTipsButton()
			.verifySubHeadingExists()
			.verifySafetyTips()
			.verifyPreviousButtonExists()
			.tapPreviousButton()
			.tapAboutOpenSourceButton()
			.verifySubHeadingExists()
			.verifyPreviousButtonExists()
			.tapPreviousButton()
			.verifyAccessibilityButtonExists()
			.tapAboutAccessibilityButton()
			.verifySubHeadingExists()
			.verifyPreviousButtonExists()
			.tapPreviousButton()
			.verifyPrivacyButtonExists()
			.tapAboutPrivacyButton()
			.verifySafariButtonExists()
			.tapCloseButton()
			.verifyPreviousButtonExists()
			.tapPreviousButton()
	}
	
	@MainActor
	func testSettingsFlow_reset() {
		
		AppRobot()
			.navigateToOverview()
			.tapSettingsTab()
			.verifyResetApplicationButtonExists()
			.tapResetApplicationButton()
			.verifyAlertCancelButtonExists()
			.tapAlertCancelButton()
			.tapResetApplicationButton()
			.verifyAlertOkButtonExists()
			.tapAlertOkButton()
			.verifySubHeadingExists()
	}
}
