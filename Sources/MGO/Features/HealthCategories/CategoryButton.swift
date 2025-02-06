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
	
	/// Which box should the category be in?
	var box: Int
		
	/// Get the display icon for the category
	/// - Parameter theme: the theme
	/// - Returns: a view witch the right themed icon
	@ViewBuilder func getIcon(_ theme: any Themeable) -> some View {
		
		switch id {
			case HealthCategories.Category.medication.rawValue:
				// Medication
			Image(ImageResource.HealthCategory.pill)
					.resizable()
					.foregroundStyle(theme.huisarts)
				
			case HealthCategories.Category.measurements.rawValue:
				// Measurements
				Image(ImageResource.HealthCategory.vitalSigns)
					.resizable()
					.foregroundStyle(theme.apotheek)
			
			case HealthCategories.Category.labResults.rawValue:
				// Lab results
				Image(ImageResource.HealthCategory.tube)
					.resizable()
					.foregroundStyle(theme.ziekenhuis)
			
			case HealthCategories.Category.allergies.rawValue:
				// Allergies
				Image(ImageResource.HealthCategory.allergies)
						.resizable()
						.foregroundStyle(theme.kliniek)
					
			case HealthCategories.Category.treatments.rawValue:
				// Treatments
				Image(ImageResource.HealthCategory.case)
					.resizable()
					.foregroundStyle(theme.ggz)
			
			case HealthCategories.Category.appointments.rawValue:
				// Appointments
				Image(ImageResource.HealthCategory.appointment)
					.resizable()
					.foregroundStyle(theme.ggd)

			case HealthCategories.Category.vaccinations.rawValue:
				// Vaccinations
				Image(ImageResource.HealthCategory.syringe)
					.resizable()
					.foregroundStyle(theme.tandarts)
				
			case HealthCategories.Category.documents.rawValue:
				// Documents
				Image(ImageResource.HealthCategory.folder)
					.resizable()
					.foregroundStyle(theme.thuiszorg)
			
			case HealthCategories.Category.complaints.rawValue:
				// Complaints
				Image(ImageResource.HealthCategory.complaint)
					.resizable()
					.foregroundStyle(theme.verpleeghuis)
			
			case HealthCategories.Category.patient.rawValue:
				// Patient
				Image(ImageResource.HealthCategory.patient)
					.resizable()
					.foregroundStyle(theme.overige)

			case HealthCategories.Category.alerts.rawValue:
				// Alert
				Image(ImageResource.HealthCategory.alert)
					.resizable()
					.foregroundStyle(theme.rivm)
			
			case HealthCategories.Category.payment.rawValue:
				// Payment
				Image(ImageResource.HealthCategory.payment)
					.resizable()
					.foregroundStyle(theme.verloskundige)
			
			case HealthCategories.Category.plans.rawValue:
				// Plans
				Image(ImageResource.HealthCategory.plans)
					.resizable()
					.foregroundStyle(theme.revalidatie)
			
			case HealthCategories.Category.devices.rawValue:
				// Device
				Image(ImageResource.HealthCategory.device)
					.resizable()
					.foregroundStyle(theme.rijksLint)

			case HealthCategories.Category.functionalOrMentalStatus.rawValue:
				// Mental wellbeing
				Image(ImageResource.HealthCategory.smile)
					.resizable()
					.foregroundStyle(theme.notificationInformation)
		
			case HealthCategories.Category.lifestyle.rawValue:
				// Lifestyle
				Image(ImageResource.HealthCategory.lifestyle)
					.resizable()
					.foregroundStyle(theme.gegevens)
			
			default:
				EmptyView()
		}
	}
}

extension CategoryButton {
	
	/// Create a Category Button
	/// - Parameters:
	///   - category:The  category
	///   - title: The language key for the title
	///   - state: The state of the category (loading, loaded, empty)
	///   - box: Which box should the category be in?
	init(category: HealthCategories.Category, title: LocalizedStringKey, state: CategoryButtonState = .loading, box: Int = 1) {
		self.id = category.rawValue
		self.title = title
		self.state = state
		self.box = box
	}
}
