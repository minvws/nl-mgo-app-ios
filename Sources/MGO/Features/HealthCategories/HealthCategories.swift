/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct HealthCategories {
	
	enum Category: Int, CaseIterable, Codable {
		case medicalComplaints = 1
		case labResults = 2
		case measurements = 3
		case medication = 4
		case treatments = 5
		case appointments = 6
		case vaccinations = 7
		case documents = 8
		case allergies = 9
		case mentalWellbeing = 10
		case lifestyle = 11
		case medicalDevices = 12
		case plans = 13
		case alerts = 14
		case personalDetails = 15
		case payment = 16
		
		/// The category heading
		var heading: LocalizedStringKey {
			
			if let sharedCategory = sharedCategory {
				return LocalizedStringKey(stringLiteral: sharedCategory.heading)
			}
			
			logError("Did not found a heading for", self)
			return "Todo!"
		}
		
		/// Which of the Nictiz profiles do we accept for a category?
		@MainActor var acceptedProfiles: [String] {
			
			if let sharedCategory = sharedCategory {
				return sharedCategory.profiles()
			}
			
			logError("Did not found an acceptedProfiles for", self)
			return []
		}
		
		@MainActor func subCategoryHeading(_ profileDefinition: String) -> String.LocalizationValue? {
			
			if let sharedCategory = sharedCategory,
			   let subcategory = sharedCategory.subcategories.first(where: { $0.profiles.contains(profileDefinition) }) {
				   return String.LocalizationValue(stringLiteral: subcategory.heading)
			}
			logError("Did not found subcategory for \(profileDefinition) in", self)
			return nil
		}
		
		public var sharedCategory: SharedHealthCategories.Category? {
			
			do {
				let sharedCategories = try SharedHealthCategories()
				switch self {
					case .medication:
						return sharedCategories.findCategory(id: "medication")
					case .medicalComplaints:
						return sharedCategories.findCategory(id: "problems")
					case .labResults:
						return sharedCategories.findCategory(id: "lab_results")
					case .measurements:
						return sharedCategories.findCategory(id: "measurements")
					case .treatments:
						return sharedCategories.findCategory(id: "treatments")
					case .appointments:
						return sharedCategories.findCategory(id: "appointments")
					case .vaccinations:
						return sharedCategories.findCategory(id: "vaccinations")
					case .documents:
						return sharedCategories.findCategory(id: "documents")
					case .allergies:
						return sharedCategories.findCategory(id: "allergies")
					case .mentalWellbeing:
						return sharedCategories.findCategory(id: "mental_wellbeing")
					case .lifestyle:
						return sharedCategories.findCategory(id: "lifestyle")
					case .medicalDevices:
						return sharedCategories.findCategory(id: "medical_devices")
					case .plans:
						return sharedCategories.findCategory(id: "plans")
					case .alerts:
						return sharedCategories.findCategory(id: "alerts")
					case .personalDetails:
						return sharedCategories.findCategory(id: "patient")
					case .payment:
						return sharedCategories.findCategory(id: "payment")
				}
			} catch {
				return nil
			}
		}
	}
}
