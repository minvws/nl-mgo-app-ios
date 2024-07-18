/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

class BaseFlowTest: XCTestCase {
	
	let app = XCUIApplication()
	let loginTimeout = 15.0
	
	override func setUpWithError() throws {
		
		try super.setUpWithError()
		app.launchArguments.append("-resetOnStart")
		app.launchArguments.append("-disableTransitions")
		app.launch()
		expect(self.app.waitForExistence(timeout: self.loginTimeout)) == true
		continueAfterFailure = false
	}
}
