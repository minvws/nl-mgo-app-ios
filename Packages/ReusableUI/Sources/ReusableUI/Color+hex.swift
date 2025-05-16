/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Color {
	
	// See https://stackoverflow.com/a/56874327/443270
	
	/// Create a color from RGB or ARGB hex
	/// - Parameter hex: the hex value (no leading #)
	init(hex: String) {
		let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
		var int: UInt64 = 0
		Scanner(string: hex).scanHexInt64(&int)
		let alpha: UInt64
		let red: UInt64
		let green: UInt64
		let blue: UInt64
		switch hex.count {
			case 3: // RGB (12-bit)
				(alpha, red, green, blue) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
			case 6: // RGB (24-bit)
				(alpha, red, green, blue) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
			case 8: // ARGB (32-bit)
				(alpha, red, green, blue) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
			default:
				(alpha, red, green, blue) = (1, 1, 1, 0)
		}

		self.init(
			.sRGB,
			red: Double(red) / 255,
			green: Double(green) / 255,
			blue: Double(blue) / 255,
			opacity: Double(alpha) / 255
		)
	}
}
