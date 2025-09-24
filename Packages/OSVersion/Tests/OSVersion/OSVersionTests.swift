/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Testing
@testable import OSVersion

final class OSVersionTests {
	
	@Test("Check the availability of iOS versions")
	func osVersion() {
		
		// Given
		let checker = OSVersionChecker()
		
		// When
		
		// Then
		// Runner is iPhone 16 Pro with 18.5
		#expect(checker.available(version: .iOS(.v15)) == true)
		#expect(checker.available(version: .iOS(.v16)) == true)
		#expect(checker.available(version: .iOS(.v17)) == true)
		#expect(checker.available(version: .iOS(.v18)) == true)
		#expect(checker.available(version: .iOS(.v26)) == false)
	}
}
