/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Make a view look like a card
public struct Cardify: ViewModifier {
	
	/// The general padding around the card
	public var padding: CGFloat
	
	/// The line color
	public var lineColor: Color
	
	/// Should we set a background
	public var setBackground: Bool
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Card {
			static let radius: CGFloat = 10
			static let inset: CGFloat = 0.5
		}
	}
	
	// The Theme
	@Environment(\.theme) var theme
	
	public func body(content: Content) -> some View {
		
		content
			.padding(padding)
			.when(setBackground, transform: { view in
				view.background(theme.backgroundSecondary)
			})
			.shadow(color: theme.contentPrimary.opacity(0.05), radius: 1, x: 0, y: 1)
			.clipShape(RoundedRectangle(cornerRadius: ViewTraits.Card.radius))
	}
}

extension View {
	
	/// Make the view look like a card
	/// - Returns: card like view.
	public func cardify(padding: CGFloat = 16, lineColor: Color = Theme().borderPrimary, setBackground: Bool = true) -> some View {
		modifier(Cardify(padding: padding, lineColor: lineColor, setBackground: setBackground))
	}
}
