/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

enum SubHeading: String {
	case introduction = "introduction.subheading"
	case proposition = "proposition.subheading"
	
	var element: XCUIElement {
		XCUIApplication().staticTexts[rawValue]
	}
}
