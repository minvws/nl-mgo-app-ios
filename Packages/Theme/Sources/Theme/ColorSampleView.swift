/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

struct ColorSampleView: View {

	let theme = Theme()
	
	private struct Texts {
		static let background = "Background"
		static let backgroundHover = "Background Hover"
		static let border = "Border"
		static let content = "Content"
		static let critical = "Critical"
		static let `default` = "Default"
		static let hover = "Hover"
		static let invert = "Invert"
		static let interactionPrimary = "Interaction Primary"
		static let interactionSecondary = "Interaction Secondary"
		static let interactionTertiary = "Interaction Tertiary"
		static let primary = "Primary"
		static let secondary = "Secondary"
		static let sentiment = "Sentiment"
		static let support = "Support"
		static let symbol = "Symbol"
		static let text = "Text"
		static let tertiary = "Tertiary"
	}

	var body: some View {
		ZStack {
			
			theme.backgroundPrimary
			
			ScrollView {
				
				VStack(alignment: .leading) {
					
					Text(Texts.background).bold()
					
					HStack {
						colorSample(theme.backgroundPrimary, text: Texts.primary)
						colorSample(theme.backgroundSecondary, text: Texts.secondary)
						colorSample(theme.backgroundTertiary, text: Texts.tertiary)
					}
					
					Text(Texts.content).bold()
					
					HStack {
						colorSample(theme.contentPrimary, text: Texts.primary)
						colorSample(theme.contentSecondary, text: Texts.secondary)
						colorSample(theme.contentInvert, text: Texts.invert)
					}
					
					Text(Texts.border).bold()
					
					HStack {
						colorSample(theme.borderPrimary, text: Texts.primary)
						colorSample(theme.borderSecondary, text: Texts.secondary)
					}
					
					Text(Texts.symbol).bold()
					
					HStack {
						colorSample(theme.symbolPrimary, text: Texts.primary)
						colorSample(theme.symbolSecondary, text: Texts.secondary)
						colorSample(theme.symbolTertiary, text: Texts.tertiary)
					}
					
					Text(Texts.sentiment).bold()

					HStack {
						colorSample(theme.sentimentInformation, text: "Information")
						colorSample(theme.sentimentPositive, text: "Positive")
						colorSample(theme.sentimentWarning, text: "Warning")
						colorSample(theme.sentimentCritical, text: "Critical")
					}
					
					Text(Texts.interactionPrimary).bold()
					Text(Texts.default)
					
					HStack {
						colorSample(theme.interactionPrimaryDefaultBackground, text: Texts.background)
						colorSample(theme.interactionPrimaryDefaultBackgroundHover, text: Texts.backgroundHover)
						colorSample(theme.interactionPrimaryDefaultText, text: Texts.text)
					}
					
					Text(Texts.critical)
					
					HStack {
						colorSample(theme.interactionPrimaryCriticalBackground, text: Texts.background)
						colorSample(theme.interactionPrimaryCriticalBackgroundHover, text: Texts.backgroundHover)
						colorSample(theme.interactionPrimaryCriticalText, text: Texts.text)
					}
					
					Text(Texts.interactionSecondary).bold()
					Text(Texts.default)
					
					HStack {
						colorSample(theme.interactionSecondaryDefaultBackground, text: Texts.background)
						colorSample(theme.interactionSecondaryDefaultBackgroundHover, text: Texts.backgroundHover)
						colorSample(theme.interactionSecondaryDefaultText, text: Texts.text)
					}
					
					Text(Texts.critical)
					HStack {
						colorSample(theme.interactionSecondaryCriticalBackground, text: Texts.background)
						colorSample(theme.interactionSecondaryCriticalBackgroundHover, text: Texts.backgroundHover)
						colorSample(theme.interactionSecondaryCriticalText, text: Texts.text)
					}
					
					Text(Texts.interactionTertiary).bold()
					Text(Texts.default)
					HStack {
						colorSample(theme.interactionTertiaryDefaultText, text: Texts.text)
						colorSample(theme.interactionTertiaryDefaultTextHover, text: Texts.hover)
					}
					
					Text(Texts.critical)
					HStack {
						colorSample(theme.interactionTertiaryCriticalText, text: Texts.text)
						colorSample(theme.interactionTertiaryCriticalTextHover, text: Texts.hover)
					}
					
					Text(Texts.support).bold()
					
					HStack {
						colorSample(theme.medication, text: "Medication")
						colorSample(theme.treatment, text: "Treatment")
						colorSample(theme.contacts, text: "Contacts")
						colorSample(theme.laboratory, text: "Laboratory")
					}
					
					HStack {
						colorSample(theme.functional, text: "Functional")
						colorSample(theme.device, text: "Device")
						colorSample(theme.vitals, text: "Vitals")
						colorSample(theme.documents, text: "Thuiszorg")
					}
					
					HStack {
						colorSample(theme.allergies, text: "Allergies")
						colorSample(theme.problems, text: "Problems")
						colorSample(theme.personal, text: "Personal")
						colorSample(theme.rijksLint, text: "Rijkslint")
					}
					
					HStack {
						colorSample(theme.warning, text: "Warning")
						colorSample(theme.payer, text: "Payer")
						colorSample(theme.vaccinations, text: "Vaccinations")
						colorSample(theme.procedures, text: "Procedures")
					}
					
					HStack {
						colorSample(theme.lifestyle, text: "Lifestyle")
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
				.frame(width: 120, height: 40)
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
