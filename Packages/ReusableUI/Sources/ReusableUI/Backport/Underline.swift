/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	/// Back ported version of underline
	/// - See: https://developer.apple.com/documentation/swiftui/text/underline(_:pattern:color:)
	/// - Parameters:
	///   - isActive: should the underline be active
	///   - pattern: the pattern of the underline
	///   - color: the color of the underline
	/// - Returns: view
	@MainActor @ViewBuilder func underline(
		_ isActive: Bool = true,
		pattern: Text.LineStyle.Pattern,
		color: Color? = nil
	) -> some View {
		if #available(iOS 16.0, *) {
			content
				.underline(isActive, pattern: pattern, color: color)
		} else {
			content
		}
	}
}
