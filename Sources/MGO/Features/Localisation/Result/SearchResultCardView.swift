/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct SearchResultCardView: View {
	
	/// The search result to display
	var element: SearchResult
	
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
				}
				.rijksoverheidStyle(font: .italic, style: .body)
				.foregroundStyle(theme.contentTertiary)
			}
			
			Spacer()
			
			Image(systemName: "plus")
				.foregroundStyle(theme.actionPrimaryBackground)
				.font(Font.title2.bold())
			
		}
		.padding(ViewTraits.General.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.background(theme.backgroundSecondary)
		.cornerRadius(ViewTraits.General.cornerRadius)
		.shadow(color: theme.contentPrimary.opacity(0.05), radius: 1, x: 0, y: 1)
		.overlay(
			RoundedRectangle(cornerRadius: ViewTraits.General.cornerRadius)
				.inset(by: ViewTraits.Box.inset)
				.stroke(theme.linesPrimary, lineWidth: 1)
		)
	}
}

#Preview {
	
	SearchResultCardView(
		element: SearchResult(
			id: "1",
			name: "Tandarts Tandje Erbij",
			city: "Roermond",
			address: "Boorplatform 5",
			postalCode: "1234AB"
		)
	)
	.padding(16)
}
