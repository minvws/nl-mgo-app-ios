/*
*  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
extension XCTestCase {
	// Uncomment to enable global snapshot re-recording:
	open override func setUp() {
		super.setUp()
		Nimble.PollingDefaults.pollInterval = .milliseconds(200)
		Nimble.PollingDefaults.timeout = .seconds(5)
	}
}
