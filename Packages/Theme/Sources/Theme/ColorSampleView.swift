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
					
					Text("Lines").bold()
					
					HStack {
						colorSample(theme.linesPrimary, text: "Primary")
						colorSample(theme.linesSecondary, text: "Secondary")
						colorSample(theme.linesTertiary, text: "Tertiary")
					}
					
					HStack {
						colorSample(theme.input, text: "Input")
					}
					
					Text("Action Primary").bold()
					
					HStack {
						colorSample(theme.actionPrimaryBackground, text: "Background")
						colorSample(theme.actionPrimaryText, text: "Text")
						colorSample(theme.actionPrimaryBackgroundHover, text: "Background Hover")
					}
					
					Text("Action Secondary").bold()
					
					HStack {
						colorSample(theme.actionSecondaryBackground, text: "Background")
						colorSample(theme.actionSecondaryText, text: "Text")
						colorSample(theme.actionSecondaryBackgroundHover, text: "Background Hover")
					}
					
					Text("Action Tertiary").bold()
					
					HStack {
						colorSample(theme.actionTertiaryDefault, text: "Default")
						colorSample(theme.actionTertiaryHover, text: "Hover")
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
						colorSample(theme.kliniek, text: "Kliniek")
						colorSample(theme.overige, text: "Overige")
					}
					
					HStack {
						colorSample(theme.rijksLint, text: "Rijkslint")
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
