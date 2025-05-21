/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

final class UpdateRequiredFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the update required flow
	 - Verify the existence of the update required page
	 */
	
	@MainActor
	func testUpdateRequiredFlow_verifyScreenExists() {
		AppRobot()
			.launchAppUpdateRequired()
			.verifySubHeadingExists()
			.verifyUpdateButtonExists()
	}
}
