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
	@ViewBuilder func getIcon(_ theme: any Themeable) -> some View {
		
		switch id {
			case "alerts":
				Image(ImageResource.HealthCategory.alert)
					.resizable()
				
			case "allergies":
				Image(ImageResource.HealthCategory.allergies)
					.resizable()
				
			case "appointments":
				Image(ImageResource.HealthCategory.appointment)
					.resizable()
				
			case "documents":
				Image(ImageResource.HealthCategory.folder)
					.resizable()
				
			case "medication":
				Image(ImageResource.HealthCategory.pill)
					.resizable()
				
			case "medical_devices":
				Image(ImageResource.HealthCategory.device)
					.resizable()
				
			case "mental_wellbeing":
				Image(ImageResource.HealthCategory.mentalWellbeing)
					.resizable()
				
			case "measurements":
				Image(ImageResource.HealthCategory.vitalSigns)
					.resizable()
				
			case "lab_results":
				Image(ImageResource.HealthCategory.tube)
					.resizable()
				
			case "lifestyle":
				Image(ImageResource.HealthCategory.lifestyle)
					.resizable()
				
			case "patient":
				Image(ImageResource.HealthCategory.patient)
					.resizable()
				
			case "payment":
				Image(ImageResource.HealthCategory.payment)
					.resizable()
				
			case "plans":
				Image(ImageResource.HealthCategory.plans)
					.resizable()
				
			case "problems":
				Image(ImageResource.HealthCategory.problems)
					.resizable()
				
			case "treatments":
				Image(ImageResource.HealthCategory.case)
					.resizable()
				
			case "vaccinations":
				Image(ImageResource.HealthCategory.syringe)
					.resizable()
				
			default:
				EmptyView()
		}
	}
}
