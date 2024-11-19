/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import Zibs
import MGOTest

final class BinaryTests: XCTestCase {
	
	func test_init_from_data() throws {
		
		// Given
		let data = try getResource("binary")

		// When
		let binary = try Binary(data: data)
		
		// Then
		expect(binary.content.count) == 8
	}
	
	func test_compare() throws {
		
		// Given
		let data = try getResource("binary")
		let fromDisc = try Binary(data: data)

		// When
		let binary = Binary(contentType: "application/pdf", content: "Um9vbA==")
		
		// Then
		expect(binary) == fromDisc
	}
}
