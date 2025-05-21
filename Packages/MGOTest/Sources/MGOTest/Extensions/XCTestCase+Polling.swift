/*
*  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/

import XCTest
extension XCTestCase {
	
	open override func setUp() {
		super.setUp()
		setupPollingDefaults()
		recordSnapshots()
	}
	
	open override func setUpWithError() throws {
		
		try super.setUpWithError()
		setupPollingDefaults()
		recordSnapshots()
	}
	
	private func setupPollingDefaults() {
		Nimble.PollingDefaults.pollInterval = .milliseconds(200)
		Nimble.PollingDefaults.timeout = .seconds(5)
	}
	
	private func recordSnapshots() {
		// Uncomment to enable global snapshot re-recording:
//		isRecording = true
	}
}
