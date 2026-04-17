/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

@MainActor
final class HealthExportFlowTests: XCTestCase {
	
	/*
	 This e2e test will test the health export flow
	 ✅ Verify the PDF export flow for a BGZ medication category
	 ✅ Verify the PDF export flow for a BGZ medication summary
	 ✅ Verify the PDF export flow for a BGZ medication details
	 */
	
	@MainActor
	func testHealthExportFlow_Medication() {
		
		AppRobot()
			.navigateToOverviewWithBGZ()
			.swipeDownToCategory("medication")
			.tapHealthCategory("medication")
		
		// Category
			.tapExportPdf()
			.verifyShareButtonExists()
			.close()
		
		// Summary
			.verifySectionButtonExists(0, section: 0)
			.tapSectionRow(0, section: 0)
			.tapExportPdf()
			.verifyShareButtonExists()
			.closeHealthUISchema()
		
		// Details
			.swipeDownToRowHeading("Zorgaanbieder")
			.tapNavigateToDetailsButton("Bekijk alle medicijngegevens")
			.tapExportPdf()
			.verifyShareButtonExists()
			.closeHealthUISchema()
	}
}
