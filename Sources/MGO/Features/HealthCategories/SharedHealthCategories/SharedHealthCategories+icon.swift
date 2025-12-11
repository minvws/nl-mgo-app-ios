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
	@ViewBuilder func getIconWithBackground() -> some View {
		
		switch id {
			case "alerts":
				Image(ImageResource.HealthCategory.Overview.alert)
					.resizable()
				
			case "allergies":
				Image(ImageResource.HealthCategory.Overview.allergy)
					.resizable()
				
			case "appointments":
				Image(ImageResource.HealthCategory.Overview.appointment)
					.resizable()
				
			case "documents":
				Image(ImageResource.HealthCategory.Overview.folder)
					.resizable()
				
			case "medication":
				Image(ImageResource.HealthCategory.Overview.pill)
					.resizable()
				
			case "medical_devices":
				Image(ImageResource.HealthCategory.Overview.device)
					.resizable()
				
			case "mental_wellbeing":
				Image(ImageResource.HealthCategory.Overview.mentalWellbeing)
					.resizable()
				
			case "measurements":
				Image(ImageResource.HealthCategory.Overview.vitalSigns)
					.resizable()
				
			case "lab_results":
				Image(ImageResource.HealthCategory.Overview.tube)
					.resizable()
				
			case "lifestyle":
				Image(ImageResource.HealthCategory.Overview.lifestyle)
					.resizable()
				
			case "patient":
				Image(ImageResource.HealthCategory.Overview.administration)
					.resizable()
				
			case "care_team":
				Image(ImageResource.HealthCategory.Overview.careTeam)
					.resizable()
				
			case "plans":
				Image(ImageResource.HealthCategory.Overview.plans)
					.resizable()
				
			case "problems":
				Image(ImageResource.HealthCategory.Overview.problems)
					.resizable()
				
			case "treatments":
				Image(ImageResource.HealthCategory.Overview.case)
					.resizable()
				
			case "vaccinations":
				Image(ImageResource.HealthCategory.Overview.syringe)
					.resizable()
				
			default:
				EmptyView()
		}
	}
	
	/// Get the empty icon for the category
	/// - Parameter theme: the theme
	/// - Returns: a view witch the right themed icon
	func getEmptyIcon() -> Image {
		
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
}
