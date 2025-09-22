/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

struct ColorSampleView: View {

	let theme = Theme()
	
	private struct Texts {
		static let backgrounds = "Backgrounds"
		static let backgroundHover = "Background Hover"
		static let separators = "Separators"
		static let labels = "Labels"
		static let critical = "Critical"
		static let `default` = "Default"
		static let hover = "Hover"
		static let invert = "Invert"
		static let interactionPrimary = "Interaction Primary"
		static let interactionSecondary = "Interaction Secondary"
		static let interactionTertiary = "Interaction Tertiary"
		static let primary = "Primary"
		static let secondary = "Secondary"
		static let states = "States"
		static let categories = "Categories"
		static let symbols = "Symbols"
		static let text = "Text"
		static let tertiary = "Tertiary"
		static let vibrant = "Vibrant"
	}

	var body: some View {
		ZStack {
			
			theme.backgrounds.primary
			
			ScrollView {
				
				VStack(alignment: .leading) {
					
					Text(Texts.backgrounds).bold()
					
					HStack {
						colorSample(theme.backgrounds.primary, text: Texts.primary)
						colorSample(theme.backgrounds.secondary, text: Texts.secondary)
						colorSample(theme.backgrounds.tertiary, text: Texts.tertiary)
					}
					
					Text(Texts.labels).bold()
					
					HStack {
						colorSample(theme.labels.primary, text: Texts.primary)
						colorSample(theme.labels.secondary, text: Texts.secondary)
						colorSample(theme.labels.invert, text: Texts.invert)
						colorSample(theme.labels.vibrant, text: Texts.vibrant)
					}
					
					Text(Texts.separators).bold()
					
					HStack {
						colorSample(theme.separators.primary, text: Texts.primary)
						colorSample(theme.separators.secondary, text: Texts.secondary)
						colorSample(theme.separators.invert, text: Texts.invert)
					}
					
					Text(Texts.symbols).bold()
					
					HStack {
						colorSample(theme.symbols.primary, text: Texts.primary)
						colorSample(theme.symbols.secondary, text: Texts.secondary)
						colorSample(theme.symbols.tertiary, text: Texts.tertiary)
					}
					
					Text(Texts.states).bold()

					HStack {
						colorSample(theme.states.informative, text: "Information")
						colorSample(theme.states.positive, text: "Positive")
						colorSample(theme.states.warning, text: "Warning")
						colorSample(theme.states.critical, text: "Critical")
					}
					
					Text(Texts.interactionPrimary).bold()
					Text(Texts.default)
					
					HStack {
						colorSample(theme.actions.primary.background, text: Texts.backgrounds)
						colorSample(theme.actions.primary.background.opacity(0.75), text: Texts.backgroundHover)
						colorSample(theme.actions.primary.text, text: Texts.text)
					}
					
					Text(Texts.interactionSecondary).bold()
					Text(Texts.default)
					
					HStack {
						colorSample(theme.actions.secondary.background, text: Texts.backgrounds)
						colorSample(theme.actions.secondary.background.opacity(0.75), text: Texts.backgroundHover)
						colorSample(theme.actions.secondary.text, text: Texts.text)
					}
					
					Text(Texts.interactionTertiary).bold()
					Text(Texts.default)
					HStack {
						colorSample(theme.actions.tertiary.text, text: Texts.text)
						colorSample(theme.actions.tertiary.hover, text: Texts.hover)
					}
					
					Text(Texts.categories).bold()
					
					HStack {
						colorSample(theme.categories.medication, text: "Medication")
						colorSample(theme.categories.treatment, text: "Treatment")
						colorSample(theme.categories.contacts, text: "Contacts")
						colorSample(theme.categories.laboratory, text: "Laboratory")
					}
					
					HStack {
						colorSample(theme.categories.functional, text: "Functional")
						colorSample(theme.categories.device, text: "Device")
						colorSample(theme.categories.vitals, text: "Vitals")
						colorSample(theme.categories.documents, text: "Thuiszorg")
					}
					
					HStack {
						colorSample(theme.categories.allergies, text: "Allergies")
						colorSample(theme.categories.problems, text: "Problems")
						colorSample(theme.categories.personal, text: "Personal")
						colorSample(theme.categories.rijkslint, text: "Rijkslint")
					}
					
					HStack {
						colorSample(theme.categories.warning, text: "Warning")
						colorSample(theme.categories.payer, text: "Payer")
						colorSample(theme.categories.vaccinations, text: "Vaccinations")
						colorSample(theme.categories.procedures, text: "Procedures")
					}
					
					HStack {
						colorSample(theme.categories.lifestyle, text: "Lifestyle")
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
