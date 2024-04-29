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
}

struct SearchResultCardView: View {
	
	/// The search result to display
	var element: SearchResult
	
	var state: SearchResultCardState
	
	/// The Theme
	@Environment(\.theme) var theme
	
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
			static let warningWidth: CGFloat = 32.0
		}
	}
	
	var body: some View {
		
		HStack {
			
			VStack(alignment: .leading, spacing: 0) {
				
				Text(element.name)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.padding(.bottom, ViewTraits.Title.padding)
				
				Group {
					Text(element.address ?? "")
					
					HStack {
						
						Text(element.postalCode ?? "" )
						
						Text(element.city ?? "")
					}
					
					switch state {
						case .regular:
							EmptyView()
						case .selected:
							HStack(alignment: .top, spacing: ViewTraits.Selected.spacing) {
								Image(ImageResource.check)
									.padding(ViewTraits.Selected.padding)
								Text("searchresults_provider_selected")
									.rijksoverheidStyle(font: .regular, style: .body)
							}
							.foregroundStyle(theme.actionPrimaryBackground)
							.padding(.top, ViewTraits.Selected.padding)
							.accessibilityElement(children: .combine)
						case .warning:
							HStack(alignment: .top, spacing: ViewTraits.Selected.spacing) {
								Image(ImageResource.warning)
//									.padding(ViewTraits.Selected.padding)
								Text("searchresults_provider_warning")
									.rijksoverheidStyle(font: .regular, style: .body)
							}
							.foregroundStyle(theme.actionPrimaryBackground)
							.padding(.top, ViewTraits.Selected.padding)
							.accessibilityElement(children: .combine)
					}
				}
				.rijksoverheidStyle(font: .italic, style: .body)
				.foregroundStyle(theme.contentTertiary)
			}
			
			Spacer()
			
			switch state {
				case .regular:
					Image(systemName: "plus")
						.foregroundStyle(theme.actionPrimaryBackground)
						.font(Font.title2.bold())
				case .selected:
					Image(ImageResource.arrowForward)
						.foregroundStyle(theme.iconsPrimary)
						.frame(width: ViewTraits.Selected.size, height: ViewTraits.Selected.size, alignment: .center)
				case .warning:
					EmptyView()
			}

		}
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
				name: "Tandarts Tandje Erbij",
				city: "Roermond",
				address: "Boorplatform 5",
				postalCode: "1234AB"
			),
			state: .warning
		)
	}
	.padding(.horizontal, 16)
}
