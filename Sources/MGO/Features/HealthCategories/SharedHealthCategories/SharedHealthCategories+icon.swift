/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

extension SharedHealthCategories.Category {
	
	/// Get the display icon for the category
	/// - Parameter theme: the theme
	/// - Returns: a view witch the right themed icon
	@ViewBuilder func getIconWithBackground(theme: any Themeable) -> some View {
		
		let color = getColor(theme: theme)
		
		HStack(alignment: .center, spacing: 0) {
			getIcon()
				.resizable()
				.tint(color)
		}
		.padding(4)
		.frame(width: 32, height: 32, alignment: .center)
		.background(color.opacity(0.15))
		.cornerRadius(8)
	}
	
	/// Get the empty icon for the category
	/// - Parameter theme: the theme
	/// - Returns: a view witch the right themed icon
	func getIcon() -> Image {
		
		switch id {
			case "alerts":
				Image(ImageResource.HealthCategory.Icon.alert)
				
			case "allergies":
				Image(ImageResource.HealthCategory.Icon.allergy)
				
			case "appointments":
				Image(ImageResource.HealthCategory.Icon.appointment)
				
			case "documents":
				Image(ImageResource.HealthCategory.Icon.folder)
				
			case "medication":
				Image(ImageResource.HealthCategory.Icon.pill)
				
			case "medical_devices":
				Image(ImageResource.HealthCategory.Icon.device)
				
			case "mental_wellbeing":
				Image(ImageResource.HealthCategory.Icon.mentalWellbeing)
				
			case "measurements":
				Image(ImageResource.HealthCategory.Icon.vitalSigns)
				
			case "lab_results":
				Image(ImageResource.HealthCategory.Icon.tube)
				
			case "lifestyle":
				Image(ImageResource.HealthCategory.Icon.lifestyle)
				
			case "patient":
				Image(ImageResource.HealthCategory.Icon.administration)
				
			case "care_team":
				Image(ImageResource.HealthCategory.Icon.careTeam)
				
			case "plans":
				Image(ImageResource.HealthCategory.Icon.plans)
				
			case "problems":
				Image(ImageResource.HealthCategory.Icon.problems)
				
			case "treatments":
				Image(ImageResource.HealthCategory.Icon.case)
				
			case "vaccinations":
				Image(ImageResource.HealthCategory.Icon.syringe)
				
			default:
				Image(systemName: "stethoscope")
		}
	}
	
	/// Get the color for the category
	/// - Parameter theme: the theme
	/// - Returns: a color
	func getColor(theme: any Themeable) -> Color {
		
		switch id {
			case "alerts":
				theme.categories.warning
				
			case "allergies":
				theme.categories.allergies
				
			case "appointments":
				theme.categories.contacts
				
			case "documents":
				theme.categories.documents
				
			case "medication":
				theme.categories.medication
				
			case "medical_devices":
				theme.categories.device
				
			case "mental_wellbeing":
				theme.categories.functional
				
			case "measurements":
				theme.categories.vitals
				
			case "lab_results":
				theme.categories.laboratory
				
			case "lifestyle":
				theme.categories.lifestyle
				
			case "patient":
				theme.categories.personal
				
			case "care_team":
				theme.categories.providers
				
			case "plans":
				theme.categories.contacts
				
			case "problems":
				theme.categories.problems
				
			case "treatments":
				theme.categories.treatment
				
			case "vaccinations":
				theme.categories.vaccinations
				
			default:
				theme.categories.rijkslint
		}
	}
}
