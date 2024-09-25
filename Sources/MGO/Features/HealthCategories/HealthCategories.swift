/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import Zibs

struct HealthCategories {
	
	enum Category: Int, CaseIterable, Codable {
		case medication = 1
		case measurements = 2
		case labresults = 3
		case allergies = 4
		case treatments = 5
		case appointments = 6
		case vaccinations = 7
		case documents = 8
		case complaints = 9
		case patient = 10
		case alerts = 11
		case payment = 12
		case plans = 13
		case devices = 14
		case functionalOrMentalStatus = 15
		case lifestyle = 16
		
		/// Which of the Nictiz profiles do we accept for a category?
		var acceptedProfiles: [String] {
			switch self {
				
				case .medication: [
					ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse.rawValue,
					ZibMedicationAgreementProfile.httpNictizNlFhirStructureDefinitionZibMedicationAgreement.rawValue,
					ZibAdministrationAgreementProfile.httpNictizNlFhirStructureDefinitionZibAdministrationAgreement.rawValue
				]
				
				case .measurements: []
				case .labresults: []
				
				case .allergies: [
					ZibAllergyIntoleranceProfile.httpNictizNlFhirStructureDefinitionZibAllergyIntolerance.rawValue
				]
				case .treatments: []
				case .appointments: []
				case .vaccinations: []
				case .documents: []
				
				case .complaints: [
					ZibProblemProfile.httpNictizNlFhirStructureDefinitionZibProblem.rawValue
				]
				
				case .patient: [
					NlCorePatientProfile.httpFhirNlFhirStructureDefinitionNlCorePatient.rawValue
				]
				
				case .alerts: [
					ZibAlertProfile.httpNictizNlFhirStructureDefinitionZibAlert.rawValue
				]
				case .payment:  [
					ZibPayerProfile.httpNictizNlFhirStructureDefinitionZibPayer.rawValue
				]
				
				case .plans: [
					ZibTreatmentDirectiveProfile.httpNictizNlFhirStructureDefinitionZibTreatmentDirective.rawValue
				]
				case .devices: [
					ZibMedicalDeviceProfile.httpNictizNlFhirStructureDefinitionZibMedicalDevice.rawValue,
					ZibMedicalDeviceProductProfile.httpNictizNlFhirStructureDefinitionZibMedicalDeviceProduct.rawValue
				]
				case .functionalOrMentalStatus: [
					ZibFunctionalOrMentalStatusProfile.httpNictizNlFhirStructureDefinitionZibFunctionalOrMentalStatus.rawValue
				]
				case .lifestyle: [
					ZibLivingSituationProfile.httpNictizNlFhirStructureDefinitionZibLivingSituation.rawValue,
					ZibDrugUseProfile.httpNictizNlFhirStructureDefinitionZibDrugUse.rawValue,
					ZibAlcoholUseProfile.httpNictizNlFhirStructureDefinitionZibAlcoholUse.rawValue,
					ZibTobaccoUseProfile.httpNictizNlFhirStructureDefinitionZibTobaccoUse.rawValue,
					ZibNutritionAdviceProfile.httpNictizNlFhirStructureDefinitionZibNutritionAdvice.rawValue
				]
			}
		}
		
		/// What endpoints should we use for a category?
		var endPoint: [(DVP.Endpoint, Int)] {
			switch self {
				case .medication: [
					(DVP.CommonClinicalDataset.medicationUse, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.medicationAgreement, DVP.CommonClinicalDataset.serviceID),
					(DVP.GeneralPractitioner.currentMedication, DVP.GeneralPractitioner.serviceID),
					(DVP.CommonClinicalDataset.administrationAgreement, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .measurements: [
//					(DVP.CommonClinicalDataset.bloodPressure, DVP.CommonClinicalDataset.serviceID),
//					(DVP.CommonClinicalDataset.bodyWeight, DVP.CommonClinicalDataset.serviceID),
//					(DVP.CommonClinicalDataset.bodyHeight, DVP.CommonClinicalDataset.serviceID),
//					(DVP.GeneralPractitioner.diagnosticAndLabResults, DVP.GeneralPractitioner.serviceID)
				]
				
				case .labresults: [
//					(DVP.CommonClinicalDataset.laboratoryTestResult, DVP.CommonClinicalDataset.serviceID),
//					(DVP.GeneralPractitioner.diagnosticAndLabResults, DVP.GeneralPractitioner.serviceID)
				]
				
				case .allergies: [
					(DVP.CommonClinicalDataset.allergyIntolerance, DVP.CommonClinicalDataset.serviceID),
					(DVP.GeneralPractitioner.allergyIntolerance, DVP.GeneralPractitioner.serviceID)
				]
//				
				case .treatments: [
//					(DVP.CommonClinicalDataset.procedure, DVP.CommonClinicalDataset.serviceID),
//					(DVP.CommonClinicalDataset.plannedProcedures, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .appointments: [
//					(DVP.CommonClinicalDataset.encounter, DVP.CommonClinicalDataset.serviceID),
//					(DVP.CommonClinicalDataset.plannedEncounters, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .vaccinations: [
//					(DVP.CommonClinicalDataset.vaccination, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .documents: []
				
				case .complaints: [
					(DVP.CommonClinicalDataset.problem, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .patient: [
//					(DVP.CommonClinicalDataset.patient, DVP.CommonClinicalDataset.serviceID),
//					(DVP.GeneralPractitioner.patient, DVP.GeneralPractitioner.serviceID)
				]
				
				case .alerts: [
					(DVP.CommonClinicalDataset.alert, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .payment: [
//					(DVP.CommonClinicalDataset.payer, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .plans: [
//					(DVP.CommonClinicalDataset.treatmentDirective, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .devices: [
					(DVP.CommonClinicalDataset.medicalDevice, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .functionalOrMentalStatus: [
					(DVP.CommonClinicalDataset.functionalOrMentalStatus, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .lifestyle: [
					(DVP.CommonClinicalDataset.livingSituation, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.drugUse, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.alcoholUse, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.tobaccoUse, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.nutritionAdvice, DVP.CommonClinicalDataset.serviceID)
				]
			}
		}
	}
}
