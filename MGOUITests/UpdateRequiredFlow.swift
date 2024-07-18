/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

final class UpdateRequiredFlow: BaseUITest {
	
	override func setUpWithError() throws {
		
		app.launchArguments.append("-updateRequired")
		try super.setUpWithError()
	}
	
	func test_updateRequiredFlow_userTapsButton() {
		
		assertUpdateRequiredScreen()
		app.buttons["update_required.download"].tap()
	}
	
	@available(iOS 17.0, *)
	func test_updateRequiredFlow_accessibilityAudit() {
		
		guard accessibilityAuditEnabled else { return }
		do {
			try app.performAccessibilityAudit()
		} catch {
			XCTFail("The automated accessibility audit fail because [\(error.localizedDescription)]")
		}
	}
}

// MARK: - Assertions -

extension BaseUITest {
	
	/// Are we on the Update Required screen?
	func assertUpdateRequiredScreen() {
		
		app.textExists("update_required.heading")
	}
}
