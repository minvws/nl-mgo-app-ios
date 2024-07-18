/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class UpdateRequiredFlow: BaseFlowTest {
	
	override func setUpWithError() throws {
		
		app.launchArguments.append("-updateRequired")
		try super.setUpWithError()
	}
	
	func test_updateRequiredFlow_userTapsButton() {
		
		assertUpdateRequiredScreen()
		app.buttons["update_required.download"].tap()
	}
	
	func test_updateRequiredFlow_accessibilityAudit() {
		
		app.accessibilityAudit()
	}
}

// MARK: - Assertions -

extension BaseFlowTest {
	
	/// Are we on the Update Required screen?
	func assertUpdateRequiredScreen() {
		
		app.textExists("update_required.heading")
	}
}
