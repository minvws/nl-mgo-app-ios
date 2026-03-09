/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

@MainActor
final class HealthCategoryViewTranslationsFactory {
	
	// swiftlint: disable function_body_length
	/// Get the Category View Translations for a category
	/// - Parameter category: the shared category
	/// - Returns: HealthCategoryViewTranslations
	static func makeTranslations(
		for category: SharedHealthCategories.Category
	) -> HealthCategoryViewTranslations? {
		
		switch category.id {
			case "alerts":
				return HealthCategoryViewTranslations(
					heading: "hc_alerts.heading",
					search: "hc_alerts.search",
					noSearchResults: "hc_alerts.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_alerts.heading")
				)
			case "allergies":
				return HealthCategoryViewTranslations(
					heading: "hc_allergies.heading",
					search: "hc_allergies.search",
					noSearchResults: "hc_allergies.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_allergies.heading")
				)
			case "appointments":
				return HealthCategoryViewTranslations(
					heading: "hc_appointments.heading",
					search: "hc_appointments.search",
					noSearchResults: "hc_appointments.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_appointments.heading")
				)
			
			case "documents":
				return HealthCategoryViewTranslations(
					heading: "hc_documents.heading",
					search: "hc_documents.search",
					noSearchResults: "hc_documents.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_documents.heading")
				)
				
			case "problems":
				return HealthCategoryViewTranslations(
					heading: "hc_complaints.heading",
					search: "hc_complaints.search",
					noSearchResults: "hc_complaints.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_complaints.heading")
				)
				
			case "medical_devices":
				return HealthCategoryViewTranslations(
					heading: "hc_devices.heading",
					search: "hc_devices.search",
					noSearchResults: "hc_devices.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_devices.heading")
				)
				
			case "lab_results":
				return HealthCategoryViewTranslations(
					heading: "hc_lab_results.heading",
					search: "hc_lab_results.search",
					noSearchResults: "hc_lab_results.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_lab_results.heading")
				)
				
			case "lifestyle":
				return HealthCategoryViewTranslations(
					heading: "hc_lifestyle.heading",
					search: "hc_lifestyle.search",
					noSearchResults: "hc_lifestyle.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_lifestyle.heading")
				)
				
			case  "measurements":
				return HealthCategoryViewTranslations(
					heading: "hc_measurements.heading",
					search: "hc_measurements.search",
					noSearchResults: "hc_measurements.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_measurements.heading")
				)
				
			case "medication":
				return HealthCategoryViewTranslations(
					heading: "hc_medication.heading",
					search: "hc_medication.search",
					noSearchResults: "hc_medication.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_medication.heading")
				)
				
			case "mental_wellbeing":
				return  HealthCategoryViewTranslations(
					heading: "hc_mental.heading",
					search: "hc_mental.search",
					noSearchResults: "hc_mental.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_mental.heading")
				)
				
			case "patient":
				return HealthCategoryViewTranslations(
					heading: "hc_patient.heading",
					search: "hc_patient.search",
					noSearchResults: "hc_patient.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_patient.heading")
				)
				
			case "care_team":
				return HealthCategoryViewTranslations(
					heading: "hc_care_team.heading",
					search: "hc_care_team.search",
					noSearchResults: "hc_care_team.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_care_team.heading")
				)
				
			case "plans":
				return HealthCategoryViewTranslations(
					heading: "hc_plans.heading",
					search: "hc_plans.search",
					noSearchResults: "hc_plans.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_plans.heading")
				)
				
			case "treatments":
				return HealthCategoryViewTranslations(
					heading: "hc_treatments.heading",
					search: "hc_treatments.search",
					noSearchResults: "hc_treatments.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_treatments.heading")
				)
				
			case "vaccinations":
				return HealthCategoryViewTranslations(
					heading: "hc_vaccinations.heading",
					search: "hc_vaccinations.search",
					noSearchResults: "hc_vaccinations.no_search_results",
					backButtonTitle: String.LocalizationValue(stringLiteral: "hc_vaccinations.heading")
				)
				
			default: return nil
		}
	}
	// swiftlint: enable function_body_length
}

class DocumentsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(
		coordinator: (any Coordinator)? = nil,
		category: SharedHealthCategories.Category,
		organization: OrganizationSearch.Organization?
	) {
		super.init(
			coordinator: coordinator,
			category: category,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_documents.heading",
				search: "hc_documents.search",
				noSearchResults: "hc_documents.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_documents.heading")
			)
		)
	}
}
