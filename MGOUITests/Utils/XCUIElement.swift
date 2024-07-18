/*
 *  Copyright (c) 2023 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest

extension XCUIElement {
	
	private static let timeout = 15.0
	
	func assertExistence() -> XCUIElement {
		let elementPresent = rapidlyEvaluate(timeout: XCUIElement.timeout) { self.exists }
		XCTAssertTrue(elementPresent, "\(description) could not be found")
		return self
	}
	
	func assertNotExistence() {
		let elementPresent = rapidlyEvaluate(timeout: 1.0) { self.exists }
		XCTAssertFalse(elementPresent, "\(debugDescription) could be found")
	}
	
	func textExists(_ label: String) {
		_ = staticTexts[label].assertExistence()
	}
	
	func textNotExists(_ label: String) {
		staticTexts[label].assertNotExistence()
	}
	
	func typeText(_ label: String, text: String) {
		let textField = textFields[label]
		textField.tap()
		textField.typeText(text)
	}
}

extension XCUIApplication {
	
	func accessibilityAudit() {
		
		if #available(iOS 17.0, *) {
			do {
				try performAccessibilityAudit(for: .all) { issue in
					return issue.auditType == .dynamicType
				}
			} catch {
				XCTFail("The automated accessibility audit fail because [\(error.localizedDescription)]")
			}
		}
	}
}
