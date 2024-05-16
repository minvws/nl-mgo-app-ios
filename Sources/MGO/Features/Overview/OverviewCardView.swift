/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct OverviewCardView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The model of the healthcare provider
	var model: OverviewHealthcareProvider
	
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
				
				VStack(alignment: .leading, spacing: ViewTraits.General.spacing) {
					
					Text(model.name)
						.rijksoverheidStyle(font: .bold, style: .body)
						.multilineTextAlignment(.leading)
						.foregroundColor(theme.contentPrimary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
					Text(model.category)
						.rijksoverheidStyle(font: .regular, style: .body)
						.multilineTextAlignment(.leading)
						.foregroundColor(theme.contentSecondary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				
				Spacer()
				
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
		OverviewCardView(model: OverviewHealthcareProvider(category: "Tandartsen", id: "1", name: "Tandarts Tandje Erbij"))
		OverviewCardView(model: OverviewHealthcareProvider(category: "Tandartsen", id: "2", name: "Tandarts Tandje Erbij"))
		OverviewCardView(model: OverviewHealthcareProvider(category: "Tandartsen", id: "3", name: "Tandarts Tandje Erbij"))
	}
}
