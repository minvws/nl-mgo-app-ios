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
					logInfo("found subcategory for \(profileDefinition) in", self)
				   return String.LocalizationValue(stringLiteral: subcategory.heading)
			}
			logError("Did not found subcategory for \(profileDefinition) in", self)
			return nil
		}

		// What endpoints should we use for a category?
		@MainActor var services: [DVP.Endpoint] {
			guard Container.shared.featureFlagManager().isDemo else { return liveServices }
			return demoServices
		}
		
		// What endpoints should we use for a category for the real world?
		private var liveServices: [DVP.Endpoint] {
			switch self {
				
				case .medication: [
					DVP.CommonClinicalDataset.medicationUse,
					DVP.CommonClinicalDataset.medicationAgreement,
					DVP.GeneralPractitioner.currentMedication(Container.shared.now()()),
					DVP.CommonClinicalDataset.administrationAgreement
				]
				
				case .measurements: [
					DVP.CommonClinicalDataset.bloodPressure,
					DVP.CommonClinicalDataset.bodyWeight,
					DVP.CommonClinicalDataset.bodyHeight,
					DVP.GeneralPractitioner.diagnosticAndLabResults
				]
				
				case .labResults: [
					DVP.CommonClinicalDataset.laboratoryTestResult,
					DVP.GeneralPractitioner.diagnosticAndLabResults
				]
				
				case .allergies: [
					DVP.CommonClinicalDataset.allergyIntolerance,
					DVP.GeneralPractitioner.allergyIntolerance
				]
				
				case .treatments: [
					DVP.CommonClinicalDataset.procedure,
					DVP.CommonClinicalDataset.plannedProcedures,
					DVP.GeneralPractitioner.episodes
				]
				
				case .appointments: [
					DVP.CommonClinicalDataset.encounter,
					DVP.CommonClinicalDataset.plannedEncounters,
					DVP.GeneralPractitioner.encounter,
					DVP.GeneralPractitioner.soapEntries
				]
				
				case .vaccinations: [
					DVP.CommonClinicalDataset.vaccination,
					DVP.CommonClinicalDataset.plannedImmunization,
					DVP.Vaccination.patient
				]
				
				case .documents: [
					DVP.Documents.documentReference
				]
				
				case .medicalComplaints: [
					DVP.CommonClinicalDataset.problem
				]
				
				case .personalDetails: [
					DVP.CommonClinicalDataset.patient,
					DVP.GeneralPractitioner.patient
				]
				
				case .mentalWellbeing: [
					DVP.CommonClinicalDataset.functionalOrMentalStatus
				]
				
				case .alerts: [
					DVP.CommonClinicalDataset.alert
				]
				
				case .lifestyle: [
					DVP.CommonClinicalDataset.livingSituation,
					DVP.CommonClinicalDataset.drugUse,
					DVP.CommonClinicalDataset.alcoholUse,
					DVP.CommonClinicalDataset.tobaccoUse,
					DVP.CommonClinicalDataset.nutritionAdvice
				]
				
				case .medicalDevices: [
					DVP.CommonClinicalDataset.medicalDevice,
					DVP.CommonClinicalDataset.plannedMedicalDevices
				]
				
				case .plans: [
					DVP.CommonClinicalDataset.treatmentDirective,
					DVP.CommonClinicalDataset.advanceDirective
				]
				
				case .payment: [
					DVP.CommonClinicalDataset.payer
				]
			}
		}
		
		// What endpoints should we use for a category for a demo?
		private var demoServices: [DVP.Endpoint] {
			switch self {
				case .medication: return [
					DVP.CommonClinicalDataset.medicationUse
				]
					
				case .labResults: return [
					DVP.CommonClinicalDataset.laboratoryTestResult,
					DVP.GeneralPractitioner.diagnosticAndLabResults
				]
					
				case .vaccinations: return [
					DVP.Vaccination.patient
				]
					
				case .documents: return [
					DVP.Documents.documentReference
				]
					
				default:
					return []
			}
		}
		
		private var sharedCategory: SharedHealthCategories.Category? {
			
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
