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
				heading: "hc_alerts.heading",
				search: "hc_alerts.search",
				noSearchResults: "hc_alerts.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_alerts.heading_detail")
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
				heading: "hc_allergies.heading",
				search: "hc_allergies.search",
				noSearchResults: "hc_allergies.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_allergies.heading_detail")
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
				heading: "hc_appointments.heading",
				search: "hc_appointments.search",
				noSearchResults: "hc_appointments.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_appointments.heading_detail")
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
				heading: "hc_complaints.heading",
				search: "hc_complaints.search",
				noSearchResults: "hc_complaints.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_complaints.heading_detail")
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
				heading: "hc_devices.heading",
				search: "hc_devices.search",
				noSearchResults: "hc_devices.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_devices.heading_detail")
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
				heading: "hc_documents.heading",
				search: "hc_documents.search",
				noSearchResults: "hc_documents.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_documents.heading_detail")
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
				heading: "hc_lab_results.heading",
				search: "hc_lab_results.search",
				noSearchResults: "hc_lab_results.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_lab_results.heading_detail")
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
				heading: "hc_lifestyle.heading",
				search: "hc_lifestyle.search",
				noSearchResults: "hc_lifestyle.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_lifestyle.heading_detail")
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
				heading: "hc_measurements.heading",
				search: "hc_measurements.search",
				noSearchResults: "hc_measurements.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_measurements.heading_detail")
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
				heading: "hc_medication.heading",
				search: "hc_medication.search",
				noSearchResults: "hc_medication.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_medication.heading_detail")
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
				heading: "hc_mental.heading",
				search: "hc_mental.search",
				noSearchResults: "hc_mental.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_mental.heading_detail")
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
				heading: "hc_patient.heading",
				search: "hc_patient.search",
				noSearchResults: "hc_patient.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_patient.heading_detail")
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
				heading: "hc_payment.heading",
				search: "hc_payment.search",
				noSearchResults: "hc_payment.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_payment.heading_detail")
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
				heading: "hc_plans.heading",
				search: "hc_plans.search",
				noSearchResults: "hc_plans.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_plans.heading_detail")
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
				heading: "hc_treatments.heading",
				search: "hc_treatments.search",
				noSearchResults: "hc_treatments.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_treatments.heading_detail")
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
				heading: "hc_vaccinations.heading",
				search: "hc_vaccinations.search",
				noSearchResults: "hc_vaccinations.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "hc_vaccinations.heading_detail")
			)
		)
	}
}
