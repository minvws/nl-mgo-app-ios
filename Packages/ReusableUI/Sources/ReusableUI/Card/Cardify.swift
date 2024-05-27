/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Make a view look like a card
public struct Cardify: ViewModifier {
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Card {
			static let spacing: CGFloat = 16
			static let radius: CGFloat = 8
			static let inset: CGFloat = 0.5
		}
	}
	
	// The Theme
	@Environment(\.theme) var theme
	
	public func body(content: Content) -> some View {
		
		content
			.padding(ViewTraits.Card.spacing)
			.background(theme.backgroundSecondary)
			.shadow(color: theme.contentPrimary.opacity(0.05), radius: 1, x: 0, y: 1)
			.overlay(
				RoundedRectangle(cornerRadius: ViewTraits.Card.radius)
					.inset(by: ViewTraits.Card.inset)
					.stroke(theme.linesPrimary, lineWidth: 1)
			)
	}
}

extension View {
	
	/// Make the view look like a card
	/// - Returns: card like view.
	public func cardify() -> some View {
		modifier(Cardify())
	}
}
