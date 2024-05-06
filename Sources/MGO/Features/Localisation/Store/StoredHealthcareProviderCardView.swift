/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct StoredHealthcareProviderCardView: View {
	
	/// The search result to display
	var element: StoredHealthcareProviderModel
	
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
				
				Text(element.category)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.padding(.bottom, ViewTraits.General.textPadding)
				
				Text(element.name)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.multilineTextAlignment(.leading)
					.padding(.bottom, ViewTraits.General.textPadding)
				
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
			
			Image(ImageResource.Localisation.delete)
				.foregroundStyle(theme.iconsPrimary)
				.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size, alignment: .center)
				.accessibilityHidden(true)
		}
		.accessibilityElement(children: .combine)
		.padding(ViewTraits.General.padding)
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.cornerRadius(ViewTraits.General.cornerRadius)
		.background(theme.backgroundSecondary)
		.shadow(color: theme.contentPrimary.opacity(0.05), radius: 1, x: 0, y: 1)
		.overlay(
			RoundedRectangle(cornerRadius: ViewTraits.General.cornerRadius)
				.inset(by: ViewTraits.Box.inset)
				.stroke(theme.linesPrimary, lineWidth: 1)
		)
	}
}

#Preview {
	
	StoredHealthcareProviderCardView(
		element: StoredHealthcareProviderModel(
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
