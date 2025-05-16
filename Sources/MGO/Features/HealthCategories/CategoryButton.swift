/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	case notAvailable
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
					.foregroundStyle(theme.medication)
				
			case HealthCategories.Category.measurements.rawValue:
				// Measurements
				Image(ImageResource.HealthCategory.vitalSigns)
					.resizable()
					.foregroundStyle(theme.vitals)
			
			case HealthCategories.Category.labResults.rawValue:
				// Lab results
				Image(ImageResource.HealthCategory.tube)
					.resizable()
					.foregroundStyle(theme.laboratory)
			
			case HealthCategories.Category.allergies.rawValue:
				// Allergies
				Image(ImageResource.HealthCategory.allergies)
						.resizable()
						.foregroundStyle(theme.allergies)
					
			case HealthCategories.Category.treatments.rawValue:
				// Treatments
				Image(ImageResource.HealthCategory.case)
					.resizable()
					.foregroundStyle(theme.treatment)
			
			case HealthCategories.Category.appointments.rawValue:
				// Appointments
				Image(ImageResource.HealthCategory.appointment)
					.resizable()
					.foregroundStyle(theme.contacts)

			case HealthCategories.Category.vaccinations.rawValue:
				// Vaccinations
				Image(ImageResource.HealthCategory.syringe)
					.resizable()
					.foregroundStyle(theme.vaccinations)
				
			case HealthCategories.Category.documents.rawValue:
				// Documents
				Image(ImageResource.HealthCategory.folder)
					.resizable()
					.foregroundStyle(theme.documents)
			
			case HealthCategories.Category.medicalComplaints.rawValue:
				// Complaints
				Image(ImageResource.HealthCategory.complaint)
					.resizable()
					.foregroundStyle(theme.problems)
			
			case HealthCategories.Category.personalDetails.rawValue:
				// Patient
				Image(ImageResource.HealthCategory.patient)
					.resizable()
					.foregroundStyle(theme.personal)

			case HealthCategories.Category.alerts.rawValue:
				// Alert
				Image(ImageResource.HealthCategory.alert)
					.resizable()
					.foregroundStyle(theme.warning)
			
			case HealthCategories.Category.payment.rawValue:
				// Payment
				Image(ImageResource.HealthCategory.payment)
					.resizable()
					.foregroundStyle(theme.payer)
			
			case HealthCategories.Category.plans.rawValue:
				// Plans
				Image(ImageResource.HealthCategory.plans)
					.resizable()
					.foregroundStyle(theme.procedures)
			
			case HealthCategories.Category.medicalDevices.rawValue:
				// Device
				Image(ImageResource.HealthCategory.device)
					.resizable()
					.foregroundStyle(theme.device)

			case HealthCategories.Category.mentalWellbeing.rawValue:
				// Mental wellbeing
				Image(ImageResource.HealthCategory.mentalWellbeing)
					.resizable()
					.foregroundStyle(theme.functional)
		
			case HealthCategories.Category.lifestyle.rawValue:
				// Lifestyle
				Image(ImageResource.HealthCategory.lifestyle)
					.resizable()
					.foregroundStyle(theme.lifestyle)
			
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
