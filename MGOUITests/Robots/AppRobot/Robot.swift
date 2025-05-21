/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import XCTest

protocol Robot {
	
	/// The application to test
	var app: XCUIApplication { get }
}

extension Robot {
	
	var timeOut: Double {
		return 15
	}
}
