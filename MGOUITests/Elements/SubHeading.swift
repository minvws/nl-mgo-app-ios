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
	case login = "Log in met DigiD. Zo kunnen we jouw gegevens veilig ophalen bij je huisarts, ziekenhuis en andere zorgaanbieders."
	
	var element: XCUIElement {
		XCUIApplication().staticTexts[rawValue]
	}
}
