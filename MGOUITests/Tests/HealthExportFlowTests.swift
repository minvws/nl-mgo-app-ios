/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
final class HealthExportFlowTests: XCTestCase {

	/*
	 This e2e test will test the health export flow
	 ✅ Verify the PDF export flow for a BGZ medication category
	 */

	@MainActor
	func testHealthExportFlow_Medication() {

		AppRobot()
			.navigateToOverviewWithBGZ()
			.swipeDownToCategory("medication")
			.tapHealthCategory("medication")
			.tapExportPdf()
			.verifyShareButtonExists()
			.close()
	}
}
