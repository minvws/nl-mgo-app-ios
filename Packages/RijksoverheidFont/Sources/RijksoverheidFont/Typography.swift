/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// The set of named text styles used throughout the MGO app.
///
/// Each case maps to a specific combination of font weight, size, and line
/// spacing that conforms to the Rijksoverheid design system.  Use the
/// ``View/typography(_:with:)`` modifier to apply a style to any SwiftUI view:
///
/// ```swift
/// Text("Welkom")
///     .typography(.headingLarge)
///
/// Text("Disclaimer")
///     .typography(.bodySmall, with: .italic)
/// ```
public enum Typography: CaseIterable {
	
	// MARK: - Heading styles

	/// Extra-large heading. Maps to `Font.TextStyle.largeTitle` (34 pt, 30 pt on iPhone SE).
	case headingExtraLarge

	/// Large heading. Maps to `Font.TextStyle.title` (28 pt, 26 pt on iPhone SE).
	case headingLarge

	/// Medium heading. Maps to `Font.TextStyle.title2` (22 pt).
	case headingMedium

	/// Small heading. Maps to `Font.TextStyle.title3` (20 pt).
	case headingSmall

	/// Extra-small heading. Maps to `Font.TextStyle.subheadline` (18 pt).
	case headingExtraSmall

	// MARK: - Body styles

	/// Large body text. Maps to `Font.TextStyle.headline` (20 pt).
	case bodyLarge

	/// Regular body text. Maps to `Font.TextStyle.body` (18 pt).
	case bodyMedium

	/// Small body text. Maps to `Font.TextStyle.callout` (16 pt).
	case bodySmall
	
	// MARK: - Internal helpers

	/// The default ``RijksoverheidFont`` weight for this style.
	///
	/// Heading styles use `.bold`; body styles use `.regular`.
	/// Pass a different value to ``View/typography(_:with:)`` to override.
	@MainActor func font() -> RijksoverheidFont {
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
	
	/// The additional line spacing (in points) applied below each line of text.
	func lineSpacing() -> CGFloat {
		switch self {
			case .headingExtraLarge: return 3.5
			case .headingLarge, .headingMedium: return 3.0
			case .headingSmall: return 2.5
			case .headingExtraSmall: return 2.0
			case .bodyLarge, .bodyMedium, .bodySmall: return 2.0
		}
	}
	
	/// The `Font.TextStyle` that governs Dynamic Type scaling for this style.
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
