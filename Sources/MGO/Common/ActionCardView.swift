/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct ActionCardView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The title of the card
	var title: LocalizedStringKey
	
	/// The body of the card
	var message: LocalizedStringKey
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
	/// The action to be performed when the user presses this card
	var perform: (() -> Void)?
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 8
		}
		enum Chevron {
			static let size: CGFloat = 32.0
		}
	}
	
	var body: some View {
		
		VStack(spacing: 0) {
			
			HStack(alignment: .center, spacing: 0) {
				
				VStack(alignment: .leading, spacing: ViewTraits.General.spacing) {
					
					Text(title)
						.rijksoverheidStyle(font: .bold, style: .body)
						.multilineTextAlignment(.leading)
						.foregroundColor(theme.contentPrimary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
					Text(message)
						.rijksoverheidStyle(font: .regular, style: .body)
						.multilineTextAlignment(.leading)
						.foregroundColor(theme.contentSecondary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				
				Image(ImageResource.Overview.chevronRight)
					.foregroundStyle(theme.symbolPrimary)
					.frame(width: ViewTraits.Chevron.size, height: ViewTraits.Chevron.size, alignment: .center)
					.accessibilityHidden(true)
				
			}
			.accessibilityElement(children: .combine)
			.padding(ViewTraits.General.padding)
			.background(onHover ? theme.backgroundTertiary : theme.backgroundSecondary)
			
		}
		._onButtonGesture { pressed in
			self.onHover = pressed
		} perform: {
			perform?()
		}
	}
}

#Preview {
	VStack(spacing: 4) {
		ActionCardView(
			title: "hc_medication.heading",
			message: "hc_medication.heading_detail"
		)
	}
}
