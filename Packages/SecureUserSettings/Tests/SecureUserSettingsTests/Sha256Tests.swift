/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
@testable import SecureUserSettings

final class Sha256Tests: XCTestCase {

	func test_string_sha256() {
		
		// Given
		let string = "test_string_sha256"
		
		// When
		let sha256 = string.sha256
		
		// Then
		expect(sha256) == "b39dc4c3d9eedc35b66703dd90bb1cdb9b73eb563ba25ab55e6f0714f8a4f849"
	}
	
	func test_data_sha256() {
		
		// Given
		let string = "test_data_sha256"
		let data = Data(string.utf8)
		
		// When
		let sha256 = data.sha256
		let sha256String = sha256.compactMap { String(format: "%02x", $0) }.joined()
		
		// Then
		expect(sha256String) == "a2aee26c63bb88e0c3cab3fc0d20f01f634c814b7757f2dccb1090a796aba1a7"
	}
}
