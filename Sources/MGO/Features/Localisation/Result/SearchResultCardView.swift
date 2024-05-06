/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum SearchResultCardState {
	case regular
	case selected
	case warning
	
	var localizedStringKey: LocalizedStringKey {
		switch self {
			case .regular: return "searchresults_add_voiceover"
			case .selected: return "searchresults_view_voiceover"
			case .warning: return "searchresults_view_voiceover"
		}
	}
}

struct SearchResultCardView: View {
	
	/// The search result to display
	var element: SearchResult
	
	/// The state of the card
	var state: SearchResultCardState
	
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
				
				Text(element.name)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.multilineTextAlignment(.leading)
					.padding(.bottom, ViewTraits.Title.padding)
				
				Group {
					Text(element.address ?? "")
					
					HStack {
						
						Text(element.postalCode ?? "" )
						
						Text(element.city ?? "")
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
							Text("searchresults_provider_selected")
								.rijksoverheidStyle(font: .regular, style: .body)
								.multilineTextAlignment(.leading)
								.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
								
						}
						.foregroundStyle(colorScheme == .dark ? theme.actionTertiaryDefault : theme.actionPrimaryBackground)
						.padding(.top, ViewTraits.Selected.padding)
						.accessibilityElement(children: .combine)
						
					case .warning:
						HStack(alignment: .top, spacing: ViewTraits.Selected.spacing) {
							Image(ImageResource.Localisation.warning)
							Text("searchresults_provider_warning")
								.rijksoverheidStyle(font: .regular, style: .body)
								.multilineTextAlignment(.leading)
								.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
						}
						.foregroundStyle(colorScheme == .dark ? theme.actionTertiaryDefault : theme.actionPrimaryBackground)
						.padding(.top, ViewTraits.Selected.padding)
						.accessibilityElement(children: .combine)
				}
			}
			
			Spacer()
			
			switch state {
				case .regular:
					Image(systemName: "plus")
						.foregroundStyle(colorScheme == .dark ? theme.actionTertiaryDefault : theme.actionPrimaryBackground)
						.font(Font.title2.bold())
						.accessibilityLabel(state.localizedStringKey)
				
				case .selected:
					Image(ImageResource.Localisation.arrowForward)
						.foregroundStyle(theme.iconsPrimary)
						.frame(width: ViewTraits.Selected.size, height: ViewTraits.Selected.size, alignment: .center)
						.accessibilityLabel(state.localizedStringKey)
				
				case .warning:
					Spacer()
					.accessibilityHidden(false)
					.accessibilityLabel(state.localizedStringKey)
			}
		}
		.accessibilityElement(children: .combine)
		.padding(ViewTraits.General.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.if(state == .warning, transform: { view in
			view.background(theme.backgroundTertiary)
		})
		.cornerRadius(ViewTraits.General.cornerRadius)
		.if(state != .warning, transform: { view in
			view
				.background(theme.backgroundSecondary)
				.shadow(color: theme.contentPrimary.opacity(0.05), radius: 1, x: 0, y: 1)
				.overlay(
					RoundedRectangle(cornerRadius: ViewTraits.General.cornerRadius)
						.inset(by: ViewTraits.Box.inset)
						.stroke(theme.linesPrimary, lineWidth: 1)
				)
		})
	}
}

#Preview {

	VStack(spacing: 8) {
		
		SearchResultCardView(
			element: SearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .regular
		)
	
		SearchResultCardView(
			element: SearchResult(
				id: "1",
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .selected
		)
		
		SearchResultCardView(
			element: SearchResult(
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
