/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public enum Typography: CaseIterable {
	
	case headingExtraLarge
	case headingLarge
	case headingMedium
	case headingSmall
	case headingExtraSmall
	case bodyLarge
	case bodyMedium
	case bodySmall
	
	/// The font associated with the Typography
	/// - Returns: RijksoverheidSansWebTextFont
	@MainActor func font() -> RijksoverheidSansWebTextFont {
		switch self {
			case .headingExtraLarge,
					.headingLarge,
					.headingMedium,
					.headingSmall,
					.headingExtraSmall:
				return .bold
				
			case .bodyLarge,
					.bodyMedium,
					.bodySmall:
				return .regular
		}
	}
	
	/// What is the line spacing for this typography?
	/// - Returns: the line spacing
	func lineSpacing() -> CGFloat {
		switch self {
			case .headingExtraLarge: return 3.5
			case .headingLarge, .headingMedium: return 3.0
			case .headingSmall: return 2.5
			case .headingExtraSmall: return 2.0
			case .bodyLarge, .bodyMedium, .bodySmall: return 2.0
		}
	}
	
	/// What text style should we use for this typography?
	/// - Returns: Text Style
	func textStyle() -> Font.TextStyle {
		switch self {
			case .headingExtraLarge:
				return .largeTitle
			case .headingLarge:
				return .title
			case .headingMedium:
				return .title2
			case .headingSmall:
				return .title3
			case .headingExtraSmall:
				return .subheadline
			case .bodyLarge:
				return .headline
			case .bodyMedium:
				return .body
			case .bodySmall:
				return .callout
		}
	}
}
