/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	/// The various interactions
	enum Interaction {
		/// The default swipe behaviour for the presentation.
		case automatic
		
		/// A behaviour that prioritises resizing a presentation when swiping, rather than scrolling the content of the presentation.
		case resizes
		
		/// A behaviour that prioritises scrolling the content of a presentation when swiping, rather than resizing the presentation.
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
	
	/// Back ported version of presentationContentInteraction
	/// - See: https://developer.apple.com/documentation/swiftui/view/presentationcontentinteraction(_:)
	/// - Parameter interaction: presentation content interaction (automatic, resizes, scrolls)
	/// - Returns: view with back ported presentationContentInteraction
	@ViewBuilder func presentationContentInteraction(_ interaction: Interaction) -> some View {
		if #available(iOS 16.4, *) {
			content
				.presentationContentInteraction(interaction.cast())
		} else {
			content
		}
	}
}
