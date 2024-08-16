/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum OrganizationSearchResultCardState {
	case regular
	case selected
	case warning
	
	var accessibilityLabel: String.LocalizationValue {
		switch self {
			case .regular: return "add_organization.add_voiceover"
			case .selected: return "add_organization.view_voiceover"
			case .warning: return "add_organization.view_voiceover"
		}
	}
}

struct OrganizationSearchResultCardView: View {
	
	/// The search result to display
	var model: OrganizationSearchResult
	
	/// The state of the card
	var state: OrganizationSearchResultCardState
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
	/// The action to be performed when the user presses this card
	var perform: (() -> Void)?
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 12
			static let cornerRadius: CGFloat = 8
		}
		enum Title {
			static let padding: CGFloat = 4
		}
		enum Box {
			static let inset: CGFloat = 0.5
		}
		enum Selected {
			static let spacing: CGFloat = 4.0
			static let padding: CGFloat = 8.0
			static let size: CGFloat = 24.0
		}
	}
	
	var body: some View {
		
		HStack {
			
			VStack(alignment: .leading, spacing: 0) {
				
				Text(model.name)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.multilineTextAlignment(.leading)
					.padding(.bottom, ViewTraits.Title.padding)
				
				Group {
					Text(model.address ?? "")
					
					HStack {
						
						Text(model.postalCode ?? "" )
						
						Text(model.city ?? "")
					}
				}
				.rijksoverheidStyle(font: .italic, style: .body)
				.foregroundStyle(theme.contentTertiary)
				
				switch state {
					case .regular: EmptyView()
						
					case .selected:
						HStack(alignment: .top, spacing: ViewTraits.Selected.spacing) {
							Image(ImageResource.Localisation.check)
								.padding(ViewTraits.Selected.padding)
							Text("add_organization.already_added")
								.rijksoverheidStyle(font: .regular, style: .body)
								.multilineTextAlignment(.leading)
								.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
								
						}
						.foregroundStyle(colorScheme == .dark ? theme.actionTertiaryDefaultText : theme.actionPrimaryDefaultBackground)
						.padding(.top, ViewTraits.Selected.padding)
						.accessibilityElement(children: .combine)
						
					case .warning:
						HStack(alignment: .top, spacing: ViewTraits.Selected.spacing) {
							Image(ImageResource.Localisation.warning)
							Text("add_organization.not_participating")
								.rijksoverheidStyle(font: .regular, style: .body)
								.multilineTextAlignment(.leading)
								.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
						}
						.foregroundStyle(colorScheme == .dark ? theme.actionTertiaryDefaultText : theme.actionPrimaryDefaultBackground)
						.padding(.top, ViewTraits.Selected.padding)
						.accessibilityElement(children: .combine)
				}
			}
			
			Spacer()
			
			switch state {
				case .regular:
					Image(systemName: "plus")
						.foregroundStyle(colorScheme == .dark ? theme.actionTertiaryDefaultText : theme.actionPrimaryDefaultBackground)
						.font(Font.title2.bold())
				
				case .selected:
					Image(ImageResource.Localisation.arrowForward)
						.foregroundStyle(theme.iconsPrimary)
						.frame(width: ViewTraits.Selected.size, height: ViewTraits.Selected.size, alignment: .center)
				
				case .warning:
					EmptyView()
			}
		}
		.accessibilityElement(children: .combine)
		.padding(ViewTraits.General.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.when(state == .warning, transform: { view in
			view.background(theme.backgroundTertiary)
		})
		.cornerRadius(ViewTraits.General.cornerRadius)
		.when(state != .warning, transform: { view in
			view
				.background(onHover ? theme.backgroundTertiary : theme.backgroundSecondary)
				.shadow(color: theme.contentPrimary.opacity(0.05), radius: 1, x: 0, y: 1)
				.overlay(
					RoundedRectangle(cornerRadius: ViewTraits.General.cornerRadius)
						.inset(by: ViewTraits.Box.inset)
						.stroke(theme.strokesPrimary, lineWidth: 1)
				)
		})
		._onButtonGesture { pressed in
			self.onHover = pressed
		} perform: {
			perform?()
		}
	}
}

#Preview {

	VStack(spacing: 8) {
		
		OrganizationSearchResultCardView(
			model: OrganizationSearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .regular
		)
	
		OrganizationSearchResultCardView(
			model: OrganizationSearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .selected
		)
		
		OrganizationSearchResultCardView(
			model: OrganizationSearchResult(
				id: "1",
				name: "Tandartsenpraktijk Willem II Roermond B.V.",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .warning
		)
	}
	.padding(.horizontal, 16)
}
