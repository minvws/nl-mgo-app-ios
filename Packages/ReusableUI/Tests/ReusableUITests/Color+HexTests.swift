/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import ReusableUI
import SwiftUI
import MGOTest

final class ColorHexTests: XCTestCase {
	
	func test_init_hex() {
		
		// Given
		
		// When
		
		// Then
		expect(Color(hex: "")) == Color(red: 1 / 255, green: 1 / 255, blue: 1 / 255, opacity: 0)
		expect(Color(hex: "0f0")) == Color(red: 0, green: 1, blue: 0, opacity: 1)
		expect(Color(hex: "00ff00")) == Color(red: 0, green: 1, blue: 0, opacity: 1)
		expect(Color(hex: "cc00ff00")) == Color(red: 0, green: 1, blue: 0, opacity: 204 / 255)
	}
}
