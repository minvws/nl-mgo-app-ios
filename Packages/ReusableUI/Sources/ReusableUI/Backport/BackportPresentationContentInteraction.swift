/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Back ported version of PresentationContentInteraction
///  - See: https://developer.apple.com/documentation/swiftui/presentationcontentinteraction
public struct BackportPresentationContentInteraction: ViewModifier {
	
	/// The various interactions
	public enum Interaction {
		/// The default swipe behavior for the presentation.
		case automatic
		
		/// A behavior that prioritizes resizing a presentation when swiping, rather than scrolling the content of the presentation.
		case resizes
		
		/// A behavior that prioritizes scrolling the content of a presentation when swiping, rather than resizing the presentation.
		case scrolls
		
		/// Cast the interaction to a PresentationContentInteraction
		/// - Returns: PresentationContentInteraction
		@available(iOS 16.4, *)
		public func cast() -> PresentationContentInteraction {
			switch self {
				case .automatic:
					return .automatic
				case .resizes:
					return .resizes
				case .scrolls:
					return .scrolls
			}
		}
	}
	
	/// The desired interaction, defaults to automatic
	public var interaction: Interaction = .automatic
	
	/// Get the view for this modifier
	/// - Parameter content: content
	/// - Returns: View
	public func body(content: Content) -> some View {
		
		if #available(iOS 16.4, *) {
			content
				.presentationContentInteraction(interaction.cast())
		} else {
			content
		}
	}
}

extension View {
	
	/// Back ported version of presentationContentInteraction
	/// - See: https://developer.apple.com/documentation/swiftui/view/presentationcontentinteraction(_:)
	/// - Parameter interaction: presentation content interaction (automatic, resizes, scrolls)
	/// - Returns: view with back ported presentationContentInteraction
	public func backportPresentationContentInteraction(
		_ interaction: BackportPresentationContentInteraction.Interaction) -> some View {
		modifier(BackportPresentationContentInteraction(interaction: interaction))
	}
}
