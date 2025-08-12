/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AlertsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.alerts,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_alerts.heading",
				search: "hc_alerts.search",
				noSearchResults: "hc_alerts.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_alerts.heading")
			)
		)
	}
}

class AllergiesHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.allergies,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_allergies.heading",
				search: "hc_allergies.search",
				noSearchResults: "hc_allergies.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_allergies.heading")
			)
		)
	}
}

class AppointmentsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.appointments,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_appointments.heading",
				search: "hc_appointments.search",
				noSearchResults: "hc_appointments.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_appointments.heading")
			)
		)
	}
}

class ComplaintsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.medicalComplaints,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_complaints.heading",
				search: "hc_complaints.search",
				noSearchResults: "hc_complaints.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_complaints.heading")
			)
		)
	}
}

class DevicesHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.medicalDevices,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_devices.heading",
				search: "hc_devices.search",
				noSearchResults: "hc_devices.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_devices.heading")
			)
		)
	}
}

class DocumentsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.documents,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_documents.heading",
				search: "hc_documents.search",
				noSearchResults: "hc_documents.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_documents.heading")
			)
		)
	}
	
	override func sortRecords(records: [MgoResourceRecord]) -> (partial: Bool, subCategories: [HealthSubCategory]) {
		
		let (partial, subCategories) = super.sortRecords(records: records)
		
		guard Container.shared.featureFlagManager().isDemo, let subCategory = subCategories.first else {
			return (partial, subCategories)
		}
		return (
			partial,
			[
				HealthSubCategory(
					heading: subCategory.heading,
					rows: subCategory.rows.filter { row in
						(row.heading == "Consult dermatologie" && row.subHeading == "Ziekenhuis Nieuw Juinen") ||
						(row.heading == "Voorlopig ontslagbericht" && row.subHeading == "Ziekenhuis Nieuw Juinen") ||
						(row.heading == "Ontslagbrief" && row.subHeading == "Ziekenhuis Nieuw Juinen") ||
						(row.heading == "Verwijsbrief" && row.subHeading == "Huisartspraktijk Heideroosje")
					}
				)
			]
		)
	}
}

class LabResultsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.labResults,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_lab_results.heading",
				search: "hc_lab_results.search",
				noSearchResults: "hc_lab_results.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_lab_results.heading")
			)
		)
	}
}

class LifestyleHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.lifestyle,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_lifestyle.heading",
				search: "hc_lifestyle.search",
				noSearchResults: "hc_lifestyle.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_lifestyle.heading")
			)
		)
	}
}

class MeasurementsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.measurements,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_measurements.heading",
				search: "hc_measurements.search",
				noSearchResults: "hc_measurements.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_measurements.heading")
			)
		)
	}
}

class MedicationHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.medication,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_medication.heading",
				search: "hc_medication.search",
				noSearchResults: "hc_medication.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_medication.heading")
			)
		)
	}
}

class MentalStatusHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.mentalWellbeing,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_mental.heading",
				search: "hc_mental.search",
				noSearchResults: "hc_mental.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_mental.heading")
			)
		)
	}
}

class PatientHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.personalDetails,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_patient.heading",
				search: "hc_patient.search",
				noSearchResults: "hc_patient.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_patient.heading")
			)
		)
	}
}

class PaymentHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.payment,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_payment.heading",
				search: "hc_payment.search",
				noSearchResults: "hc_payment.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_payment.heading")
			)
		)
	}
}

class PlansHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.plans,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_plans.heading",
				search: "hc_plans.search",
				noSearchResults: "hc_plans.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_plans.heading")
			)
		)
	}
}

class TreatmentsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.treatments,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_treatments.heading",
				search: "hc_treatments.search",
				noSearchResults: "hc_treatments.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_treatments.heading")
			)
		)
	}
}

class VaccinationsHealthCategoryViewModel: HealthCategoryViewModel {
	
	@MainActor init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.vaccinations,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "hc_vaccinations.heading",
				search: "hc_vaccinations.search",
				noSearchResults: "hc_vaccinations.no_search_results",
				backButtonTitle: String.LocalizationValue(stringLiteral: "hc_vaccinations.heading")
			)
		)
	}
}
