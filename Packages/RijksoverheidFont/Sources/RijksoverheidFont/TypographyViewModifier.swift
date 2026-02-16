/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// A `ViewModifier` that applies a ``Typography`` style — including the correct
/// Rijksoverheid typeface, point size, and line spacing — to any SwiftUI view.
///
/// Apply it directly via ``View/typography(_:with:)``:
///
/// ```swift
/// Text("Welkom")
///     .typography(.headingLarge)
/// ```
public struct TypographyViewModifier: ViewModifier {
	
	/// The typographic style that determines font weight, size, and line spacing.
	public var typography: Typography
	
	/// An optional font variant that overrides the default weight chosen by
	/// ``Typography/font()``.  When `nil`, the default is used.
	public var font: RijksoverheidFont?
	
	/// Applies the Rijksoverheid font and line spacing to `content`.
	/// - Parameter content: The view being modified.
	/// - Returns: The view with the appropriate font and line spacing applied.
	public func body(content: Content) -> some View {
		
		content
			.font(
				.RijksoverheidSansWebText
					.relative(
						font ?? typography.font(),
						relativeTo: typography.textStyle()
					)
			)
			.lineSpacing(typography.lineSpacing())
	}
}

extension View {
	
	/// Applies a ``Typography`` style to the view.
	///
	/// This is the primary entry point for Rijksoverheid typography in SwiftUI.
	/// It sets the typeface, size (scaled relative to the matching
	/// `Font.TextStyle` for Dynamic Type support), and line spacing in one call.
	///
	/// ```swift
	/// Text("Welkom")
	///     .typography(.headingLarge)
	///
	/// // Override the default weight for a specific style:
	/// Text("Toelichting")
	///     .typography(.bodyMedium, with: .italic)
	/// ```
	///
	/// - Parameters:
	///   - typography: The ``Typography`` style to apply.
	///   - font: An optional ``RijksoverheidFont`` variant that overrides the
	///           default font weight for the given style.  Defaults to `nil`.
	/// - Returns: A view with the Rijksoverheid typography applied.
	public func typography(
		_ typography: Typography,
		with font: RijksoverheidFont? = nil
	) -> some View {
		modifier(
			TypographyViewModifier(
				typography: typography,
				font: font
			)
		)
	}
}
