/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

enum Heading: String {
	case introduction = "introduction.heading"
	case proposition = "proposition.heading"
	case pincode = "pincode.heading"
	case login = "Bewijs wie je bent"
	
	var element: XCUIElement {
		XCUIApplication().staticTexts[rawValue]
//		XCUIApplication().navigationBars[rawValue]
	}
}
