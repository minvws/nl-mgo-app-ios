/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

struct ColorSampleView: View {

	let theme = Theme()

	var body: some View {
		ZStack {
			
			theme.backgroundPrimary
			
			ScrollView {
				
				VStack {
					
					HStack {
						colorSample(theme.backgroundPrimary, text: "Background Primary")
						colorSample(theme.backgroundSecondary, text: "Background Secondary")
						colorSample(theme.backgroundTertiary, text: "Background Tertiary")
					}
					
					HStack {
						colorSample(theme.contentPrimary, text: "Content Primary")
						colorSample(theme.contentSecondary, text: "Content Secondary")
						colorSample(theme.contentTertiary, text: "Content Tertiary")
					}
					
					HStack {
						colorSample(theme.iconsPrimary, text: "Icons Primary")
						colorSample(theme.iconsSecondary, text: "Icons Secondary")
						colorSample(theme.linesPrimary, text: "Lines Primary")
					}
					
					HStack {
						colorSample(theme.linesSecondary, text: "Lines Secondary")
						colorSample(theme.actionBorder, text: "Action Border")
						colorSample(theme.actionPrimary, text: "Action Primary")
					}
					
					HStack {
						colorSample(theme.actionSecondary, text: "Action Secondary")
						colorSample(theme.actionTertiary, text: "Action Tertiary")
						colorSample(theme.actionPrimaryText, text: "Action Primary Text")
					}
					
					HStack {
						colorSample(theme.actionSecondaryText, text: "Action Secondary Text")
						colorSample(theme.actionPrimaryHover, text: "Action Primary Hover")
						colorSample(theme.actionSecondaryHover, text: "Action Secondary Hover")
					}
					
					HStack {
						colorSample(theme.rijksLint, text: "Rijkslint")
						colorSample(theme.notificationSuccess, text: "Notification Success")
						colorSample(theme.notificationWarning, text: "Notification Warning")
					}
					
					HStack {
						colorSample(theme.notificationError, text: "Notification Error")
						colorSample(theme.apotheek, text: "Apotheek")
						colorSample(theme.ziekenhuis, text: "Ziekenhuis")
					}
					
					HStack {
						colorSample(theme.huisarts, text: "Huisarts")
						colorSample(theme.tandarts, text: "Tandarts")
						colorSample(theme.ggz, text: "GGZ")
					}
					
					HStack {
						colorSample(theme.fysiotherapeut, text: "Fysiotherapeut")
						colorSample(theme.verpleeghuis, text: "Verpleeghuis")
						colorSample(theme.kliniek, text: "Kliniek")
					}
					
					HStack {
						colorSample(theme.overige, text: "Overige")
					}
				}
			}
			.padding(16)
		}
	}
	
	/// Create a color sample
	/// - Parameters:
	///   - color: the color for the sample
	///   - text: the name of the color as label
	/// - Returns: a color sample
	@ViewBuilder private func colorSample(_ color: Color, text: String) -> some View {
		
		VStack {
			Rectangle()
				.fill(color)
				.border(.gray)
				.frame(height: 60)
			Text(text)
				.font(.footnote)
				.frame(height: 40)
		}
		.border(.gray)
	}
}

#Preview {
	ColorSampleView()
}
