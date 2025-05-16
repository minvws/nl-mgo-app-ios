/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import SharedCore
import MGOTest

final class BinaryTests: XCTestCase {
	
	func test_init_from_data() throws {
		
		// Given
		let data = try getResource("binary")

		// When
		let binary = try FHIRBinary(data: data)
		
		// Then
		expect(binary.content.count) == 8
	}
	
	func test_compare() throws {
		
		// Given
		let data = try getResource("binary")
		let fromDisc = try FHIRBinary(data: data)

		// When
		let binary = FHIRBinary(contentType: "application/pdf", content: "Um9vbA==")
		
		// Then
		expect(binary) == fromDisc
	}
}
