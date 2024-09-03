/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// The state of a category button
enum CategoryButtonState: String, CaseIterable {
	
	/// There is data from the server that is available for display
	case loaded
	
	/// Loading the data from the server
	case loading
	
	/// No data available. (could be a network failure, could just be no data in this category)
	case empty
	
	/// This category is not yet implemented.
	case notAvailabe
}

/// Struct for holding the business logic for the health category buttons
struct CategoryButton: Identifiable {
	
	/// The identifier of the the category
	var id: Int
	
	/// The language key for the title
	var title: LocalizedStringKey
	
	/// The state of the category (loading, loaded, empty)
	var state: CategoryButtonState
	
	@ViewBuilder func getIcon(_ theme: any Themeable) -> some View {
		
		switch id {
			case HealthCategories.medication.id:
				// Medication
				Image(ImageResource.OrganizationDetails.pill)
					.resizable()
					.foregroundStyle(theme.huisarts)
				
			case HealthCategories.allergies.id:
				// Allergies
				Image(ImageResource.OrganizationDetails.allergies)
					.resizable()
					.foregroundStyle(theme.kliniek)
				
			case HealthCategories.measurements.id:
				// Measurements
				Image(ImageResource.OrganizationDetails.vitalSigns)
					.resizable()
					.foregroundStyle(theme.apotheek)
				
			case HealthCategories.vaccinations.id:
				// Vaccinations
				Image(ImageResource.OrganizationDetails.syringe)
					.resizable()
					.foregroundStyle(theme.tandarts)
				
			case HealthCategories.complaints.id:
				// Complaints
				Image(ImageResource.OrganizationDetails.complaint)
					.resizable()
					.foregroundStyle(theme.verpleeghuis)
				
			case HealthCategories.treatments.id:
				// Treatments
				Image(ImageResource.OrganizationDetails.case)
					.resizable()
					.foregroundStyle(theme.ggz)
				
			case HealthCategories.labresults.id:
				// Lab results
				Image(ImageResource.OrganizationDetails.tube)
					.resizable()
					.foregroundStyle(theme.ziekenhuis)
				
			case HealthCategories.reports.id:
				// Reports
				Image(ImageResource.OrganizationDetails.report)
					.resizable()
					.foregroundStyle(theme.fysiotherapeut)
				
			case HealthCategories.documents.id:
				// Documents
				Image(ImageResource.OrganizationDetails.folder)
					.resizable()
					.foregroundStyle(theme.thuiszorg)
				
			default:
				EmptyView()
		}
	}
}
