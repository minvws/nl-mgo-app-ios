/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct DashboardCardView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	var name: String
	
	var category: String
	
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
					
					Text(name)
						.rijksoverheidStyle(font: .bold, style: .body)
						.multilineTextAlignment(.leading)
						.foregroundColor(theme.contentPrimary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
					Text(category)
						.rijksoverheidStyle(font: .regular, style: .body)
						.multilineTextAlignment(.leading)
						.foregroundColor(theme.contentSecondary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				
				Spacer()
				
				Image(ImageResource.Dashboard.chevronRight)
					.foregroundStyle(theme.iconsPrimary)
					.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size, alignment: .center)
				
			}
			.padding(ViewTraits.General.padding)
			.background(theme.backgroundSecondary)
		
			Divider()
				.overlay(theme.linesSecondary)
			
		}
	}
}

#Preview {
	VStack(spacing: 4) {
		DashboardCardView(name: "Tandarts Tandje Erbij", category: "Tandartsen")
		DashboardCardView(name: "Tandarts Tandje Erbij", category: "Tandartsen")
		DashboardCardView(name: "Tandarts Tandje Erbij", category: "Tandartsen")
	}
}
