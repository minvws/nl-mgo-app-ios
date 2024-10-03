/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AlertsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.alerts,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.alerts",
				search: "health_category.alerts.search",
				noSearchResults: "health_category.alerts.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.alerts.details_heading")
			)
		)
	}
}

class AllergiesHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.allergies,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.allergies",
				search: "health_category.allergies.search",
				noSearchResults: "health_category.allergies.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.allergies.details_heading")
			)
		)
	}
}

class AppointmentsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.appointments,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.appointments",
				search: "health_category.appointments.search",
				noSearchResults: "health_category.appointments.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.appointments.details_heading")
			)
		)
	}
}

class ComplaintsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.complaints,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.complaints",
				search: "health_category.complaints.search",
				noSearchResults: "health_category.complaints.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.complaints.details_heading")
			)
		)
	}
}

class DevicesHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.devices,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.devices",
				search: "health_category.devices.search",
				noSearchResults: "health_category.devices.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.devices.details_heading")
			)
		)
	}
}

class DocumentsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.documents,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.documents",
				search: "health_category.documents.search",
				noSearchResults: "health_category.documents.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.documents.details_heading")
			)
		)
	}
}

class LabResultsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.labresults,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.labresults",
				search: "health_category.labresults.search",
				noSearchResults: "health_category.labresults.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.labresults.details_heading")
			)
		)
	}
}

class LifestyleHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.lifestyle,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.lifestyle",
				search: "health_category.lifestyle.search",
				noSearchResults: "health_category.lifestyle.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.lifestyle.details_heading")
			)
		)
	}
}

class MeasurementsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.measurements,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.measurements",
				search: "health_category.measurements.search",
				noSearchResults: "health_category.measurements.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.measurements.details_heading")
			)
		)
	}
}

class MedicationHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.medication,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.medication",
				search: "health_category.medication.search",
				noSearchResults: "health_category.medication.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.medication.details_heading")
			)
		)
	}
}

class MentalStatusHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.functionalOrMentalStatus,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.mental",
				search: "health_category.mental.search",
				noSearchResults: "health_category.mental.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.mental.details_heading")
			)
		)
	}
}

class PatientHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.patient,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.patient",
				search: "health_category.patient.search",
				noSearchResults: "health_category.patient.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.patient.details_heading")
			)
		)
	}
}

class PaymentHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.payment,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.payment",
				search: "health_category.payment.search",
				noSearchResults: "health_category.payment.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.payment.details_heading")
			)
		)
	}
}

class PlansHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.plans,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.plans",
				search: "health_category.plans.search",
				noSearchResults: "health_category.plans.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.plans.details_heading")
			)
		)
	}
}

class TreatmentsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.treatments,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.treatments",
				search: "health_category.treatments.search",
				noSearchResults: "health_category.treatments.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.treatments.details_heading")
			)
		)
	}
}

class VaccinationsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organization: MgoOrganization?) {
		super.init(
			coordinator: coordinator,
			category: HealthCategories.Category.vaccinations,
			organization: organization,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.vaccinations",
				search: "health_category.vaccinations.search",
				noSearchResults: "health_category.vaccinations.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.vaccinations.details_heading")
			)
		)
	}
}
