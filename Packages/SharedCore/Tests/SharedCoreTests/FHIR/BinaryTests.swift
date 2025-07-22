/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import SharedCore
import Testing

struct BinaryTests {

	@Test
	func initFromData_shouldResultInValidBinary() throws {
		
		// Given
		let data = try ResourceLoader().getResource("binary")
		
		// When
		let binary = try FHIRBinary(data: data)
		
		// Then
		#expect(binary.content.count == 8)
	}
	
	@Test
	func compare_binaryFromData_binaryFromContent_shouldBeTheSame() throws {
		
		// Given
		let data = try ResourceLoader().getResource("binary")
		let fromDisc = try FHIRBinary(data: data)
		
		// When
		let binary = FHIRBinary(contentType: "application/pdf", content: "Um9vbA==")
		
		// Then
		#expect(binary == fromDisc)
	}
}
