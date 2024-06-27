/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct OrganizationListCardView: View {
	
	/// The search result to display
	var model: OrganizationListModel
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
	/// The action to be performed when the user presses this card
	var perform: (() -> Void)?
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 12
			static let cornerRadius: CGFloat = 8
			static let textPadding: CGFloat = 4
		}
		enum Box {
			static let inset: CGFloat = 0.5
		}
		enum Icon {
			static let size: CGFloat = 24.0
		}
	}
	
	var body: some View {
		
		HStack(alignment: .top) {
			
			VStack(alignment: .leading, spacing: 0) {
				
				Text(model.category)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.padding(.bottom, ViewTraits.General.textPadding)
				
				Text(model.name)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.multilineTextAlignment(.leading)
					.padding(.bottom, ViewTraits.General.textPadding)
				
				Group {
					Text(model.address ?? "")
					
					HStack {
						
						Text(model.postalCode ?? "" )
						
						Text(model.city ?? "")
					}
				}
				.rijksoverheidStyle(font: .italic, style: .body)
				.foregroundStyle(theme.contentTertiary)
			}
			
			Spacer()
			
			Image(ImageResource.Localisation.delete)
				.foregroundStyle(theme.iconsPrimary)
				.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size, alignment: .center)
				.accessibilityHidden(true)
		}
		.accessibilityElement(children: .combine)
		.padding(ViewTraits.General.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.cornerRadius(ViewTraits.General.cornerRadius)
		.background(onHover ? theme.backgroundTertiary : theme.backgroundSecondary)
		.shadow(color: theme.contentPrimary.opacity(0.05), radius: 1, x: 0, y: 1)
		.overlay(
			RoundedRectangle(cornerRadius: ViewTraits.General.cornerRadius)
				.inset(by: ViewTraits.Box.inset)
				.stroke(theme.linesPrimary, lineWidth: 1)
		)
		._onButtonGesture { pressed in
			self.onHover = pressed
		} perform: {
			perform?()
		}
	}
}

#Preview {
	
	OrganizationListCardView(
		model: OrganizationListModel(
			category: "Tandarts",
			id: "1",
			name: "Tandarts Tandje Erbij",
			city: "Roermond",
			address: "Boorplatform 5",
			postalCode: "1234AB"
		)
	)
	.padding(.horizontal, 16)
}
