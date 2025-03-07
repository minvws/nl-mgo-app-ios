/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

class PropositionTests: XCTestCase {
	
	func testAppLaunchedPropositionScreen() {
		AppRobot()
			.launchApp()
			.tapNextButton()
			.verifySubHeadingExists()
			.verifyPropositionExists(label: "proposition.statement_1")
			.verifyPropositionExists(label: "proposition.statement_2")
			.verifyPropositionExists(label: "proposition.statement_3")
			.verifyPropositionExists(label: "proposition.statement_4")
	}
	
	override func tearDownWithError() throws {
		AppRobot()
			.terminateApp()
	}
}
