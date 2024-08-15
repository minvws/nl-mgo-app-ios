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
				
				VStack(alignment: .leading) {
					
					Text("Background").bold()
					
					HStack {
						colorSample(theme.backgroundPrimary, text: "Primary")
						colorSample(theme.backgroundSecondary, text: "Secondary")
						colorSample(theme.backgroundTertiary, text: "Tertiary")
					}
					
					Text("Content").bold()
					
					HStack {
						colorSample(theme.contentPrimary, text: "Primary")
						colorSample(theme.contentSecondary, text: "Secondary")
						colorSample(theme.contentTertiary, text: "Tertiary")
					}
					
					Text("Icons").bold()
					
					HStack {
						colorSample(theme.iconsPrimary, text: "Primary")
						colorSample(theme.iconsSecondary, text: "Secondary")
					}
					
					Text("Strokes").bold()
					
					HStack {
						colorSample(theme.strokesPrimary, text: "Primary")
						colorSample(theme.strokesSecondary, text: "Secondary")
						colorSample(theme.strokesTertiary, text: "Tertiary")
					}
					
					Text("Action Primary Default").bold()
					
					HStack {
						colorSample(theme.actionPrimaryDefaultBackground, text: "Background")
						colorSample(theme.actionPrimaryDefaultBackgroundHover, text: "Background Hover")
						colorSample(theme.actionPrimaryDefaultText, text: "Text")
					}
					
					Text("Action Primary Negative").bold()
					
					HStack {
						colorSample(theme.actionPrimaryNegativeBackground, text: "Background")
						colorSample(theme.actionPrimaryNegativeBackgroundHover, text: "Background Hover")
						colorSample(theme.actionPrimaryNegativeText, text: "Text")
					}
					
					Text("Action Secondary Default").bold()
					
					HStack {
						colorSample(theme.actionSecondaryDefaultBackground, text: "Background")
						colorSample(theme.actionSecondaryDefaultBackgroundHover, text: "Background Hover")
						colorSample(theme.actionSecondaryDefaultText, text: "Text")
					}
					
					Text("Action Secondary Negative").bold()
					
					HStack {
						colorSample(theme.actionSecondaryNegativeBackground, text: "Background")
						colorSample(theme.actionSecondaryNegativeBackgroundHover, text: "Background Hover")
						colorSample(theme.actionSecondaryNegativeText, text: "Text")
					}
					
					Text("Action Tertiary Default").bold()
					
					HStack {
						colorSample(theme.actionTertiaryDefaultText, text: "Text")
						colorSample(theme.actionTertiaryDefaultTextHover, text: "Hover")
					}
					
					Text("Action Tertiary Negative").bold()
					
					HStack {
						colorSample(theme.actionTertiaryNegativeText, text: "Text")
						colorSample(theme.actionTertiaryNegativeTextHover, text: "Hover")
					}
					
					Text("Notification").bold()

					HStack {
						colorSample(theme.notificationInformation, text: "Information")
						colorSample(theme.notificationSuccess, text: "Success")
						colorSample(theme.notificationWarning, text: "Warning")
					}
					
					HStack {
						colorSample(theme.notificationError, text: "Error")
					}
					
					Text("Support").bold()
					
					HStack {
						colorSample(theme.apotheek, text: "Apotheek")
						colorSample(theme.ziekenhuis, text: "Ziekenhuis")
						colorSample(theme.huisarts, text: "Huisarts")
					}
					
					HStack {
						colorSample(theme.tandarts, text: "Tandarts")
						colorSample(theme.ggz, text: "GGZ")
						colorSample(theme.fysiotherapeut, text: "Fysiotherapeut")
					}
					
					HStack {
						colorSample(theme.verpleeghuis, text: "Verpleeghuis")
						colorSample(theme.thuiszorg, text: "Thuiszorg")
						colorSample(theme.kliniek, text: "Kliniek")
					}
					
					HStack {
						colorSample(theme.verloskundige, text: "Verloskundig")
						colorSample(theme.overige, text: "Overige")
						colorSample(theme.rijksLint, text: "Rijkslint")
					}
					
					HStack {
						colorSample(theme.rivm, text: "RIVM")
						colorSample(theme.ggd, text: "GGD")
						colorSample(theme.revalidatie, text: "Revalidatie")
					}
					
					HStack {
						colorSample(theme.gegevens, text: "Gegevens")
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
				.frame(width: 120, height: 60)
			Text(text)
				.font(.footnote)
				.frame(width: 120, height: 40)
		}
		.border(.gray)
	}
}

#Preview {
	ColorSampleView()
}
