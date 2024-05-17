/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct HealthcareProviderActionCardView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The title of the card
	var title: LocalizedStringKey
	
	/// The body of the card
	var message: LocalizedStringKey
	
	var icon: ImageResource
	
	var iconColor: Color
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
	/// The action to be performed when the user presses this card
	var perform: (() -> Void)?
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 4
		}
		enum Icon {
			static let size: CGFloat = 32.0
		}
	}
	
	var body: some View {
		
		VStack(spacing: 0) {
			
			HStack(alignment: .top, spacing: 0) {
				
				Image(icon)
					.foregroundStyle(theme.backgroundSecondary)
					.background(iconColor)
					.cornerRadius(50)
				
				Spacer(minLength: ViewTraits.General.padding)
				
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
					.foregroundStyle(theme.iconsPrimary)
					.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size, alignment: .center)
					.accessibilityHidden(true)
				
			}
			.accessibilityElement(children: .combine)
			.padding(ViewTraits.General.padding)
			.background(onHover ? theme.backgroundTertiary : theme.backgroundSecondary)
		
			Divider()
				.overlay(theme.linesSecondary)
			
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
		HealthcareProviderActionCardView(
			title: "hpdetails_medication_title",
			message: "hpdetails_medication_body",
			icon: ImageResource.Details.medication,
			iconColor: .cyan
		)
	}
}
