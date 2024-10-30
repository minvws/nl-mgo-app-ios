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
				
				case .measurements: [
					ZibBloodPressureProfile.httpNictizNlFhirStructureDefinitionZibBloodPressure.rawValue,
					ZibBodyWeightProfile.httpNictizNlFhirStructureDefinitionZibBodyWeight.rawValue,
					ZibBodyHeightProfile.httpNictizNlFhirStructureDefinitionZibBodyHeight.rawValue
				]
				
				case .labresults: [
					ZibLaboratoryTestResultObservationProfile.httpNictizNlFhirStructureDefinitionZibLaboratoryTestResultObservation.rawValue,
//					ZibLaboratoryTestResultSpecimenProfile.httpNictizNlFhirStructureDefinitionZibLaboratoryTestResultSpecimen.rawValue
					GPLaboratoryResultProfile.httpNictizNlFhirStructureDefinitionGpLaboratoryResult.rawValue
				]
				
				case .allergies: [
					ZibAllergyIntoleranceProfile.httpNictizNlFhirStructureDefinitionZibAllergyIntolerance.rawValue
				]
				
				case .treatments: [
					ZibProcedureProfile.httpNictizNlFhirStructureDefinitionZibProcedure.rawValue
				]
				
				case .appointments: [
					ZibEncounterProfile.httpNictizNlFhirStructureDefinitionZibEncounter.rawValue
				]
				
				case .vaccinations: [
					ZibVaccinationProfile.httpNictizNlFhirStructureDefinitionZibVaccination.rawValue
				]
				
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
					ZibTreatmentDirectiveProfile.httpNictizNlFhirStructureDefinitionZibTreatmentDirective.rawValue,
					ZibAdvanceDirectiveProfile.httpNictizNlFhirStructureDefinitionZibAdvanceDirective.rawValue
				]
				
				case .devices: [
					ZibMedicalDeviceProfile.httpNictizNlFhirStructureDefinitionZibMedicalDevice.rawValue
//					ZibMedicalDeviceProductProfile.httpNictizNlFhirStructureDefinitionZibMedicalDeviceProduct.rawValue
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
		
		func subCategory(_ profileDefinition: String) -> String.LocalizationValue? {
			return switch profileDefinition {
			
				// Medication
				case ZibMedicationUseProfile.httpNictizNlFhirStructureDefinitionZibMedicationUse.rawValue:
					"zib_medication_use.heading"
				case ZibMedicationAgreementProfile.httpNictizNlFhirStructureDefinitionZibMedicationAgreement.rawValue:
					"zib_medication_agreement.heading"
				case ZibAdministrationAgreementProfile.httpNictizNlFhirStructureDefinitionZibAdministrationAgreement.rawValue:
					"zib_administration_agreement.heading"
				
				// Measurements
				case ZibBloodPressureProfile.httpNictizNlFhirStructureDefinitionZibBloodPressure.rawValue:
					"zib_blood_pressure.heading"
				case ZibBodyWeightProfile.httpNictizNlFhirStructureDefinitionZibBodyWeight.rawValue:
					"zip_body_weight.heading"
				case ZibBodyHeightProfile.httpNictizNlFhirStructureDefinitionZibBodyHeight.rawValue:
					"zip_body_height.heading"
				
				// Labresults
				case ZibLaboratoryTestResultObservationProfile.httpNictizNlFhirStructureDefinitionZibLaboratoryTestResultObservation.rawValue:
					"zip_laboratory_test_result_observation.heading"
				
				// Allergies
				case ZibAllergyIntoleranceProfile.httpNictizNlFhirStructureDefinitionZibAllergyIntolerance.rawValue:
					"zip_allergy_intolerance.heading"
				
				// Treatments
				case ZibProcedureProfile.httpNictizNlFhirStructureDefinitionZibProcedure.rawValue:
					"zib_procedure.heading"
				
				// Appointments
				case ZibEncounterProfile.httpNictizNlFhirStructureDefinitionZibEncounter.rawValue:
					"zip_encounter.heading"
				
				// Vaccinations
				case ZibVaccinationProfile.httpNictizNlFhirStructureDefinitionZibVaccination.rawValue:
					"zip_vaccination.heading"
				
				// Documents
				
				// Complaints
				case ZibProblemProfile.httpNictizNlFhirStructureDefinitionZibProblem.rawValue:
					"zib_problem.heading"
				
				// Patient
				case NlCorePatientProfile.httpFhirNlFhirStructureDefinitionNlCorePatient.rawValue:
					"zib_patient.heading"
				
				// Alerts
				case ZibAlertProfile.httpNictizNlFhirStructureDefinitionZibAlert.rawValue:
					"zib_alert.heading"
				
				// Payment
				case ZibPayerProfile.httpNictizNlFhirStructureDefinitionZibPayer.rawValue:
					"zib_payer.heading"
				
				// Plans
				case ZibTreatmentDirectiveProfile.httpNictizNlFhirStructureDefinitionZibTreatmentDirective.rawValue:
					"zib_treatment_directive.heading"
				case ZibAdvanceDirectiveProfile.httpNictizNlFhirStructureDefinitionZibAdvanceDirective.rawValue:
					"zib_advance_directive.heading"
				
				// Devices
				case ZibMedicalDeviceProfile.httpNictizNlFhirStructureDefinitionZibMedicalDevice.rawValue:
					"zib_medical_device.heading"
				
				// FunctionalOrMentalStatus
				case ZibFunctionalOrMentalStatusProfile.httpNictizNlFhirStructureDefinitionZibFunctionalOrMentalStatus.rawValue:
					"zib_functional_or_mental_status.heading"
				
				// Lifestyle
				case ZibLivingSituationProfile.httpNictizNlFhirStructureDefinitionZibLivingSituation.rawValue:
					"zib_living_situation.heading"
				case ZibDrugUseProfile.httpNictizNlFhirStructureDefinitionZibDrugUse.rawValue:
					"zib_drug_use.heading"
				case ZibAlcoholUseProfile.httpNictizNlFhirStructureDefinitionZibAlcoholUse.rawValue:
					"zib_alcohol_use.heading"
				case ZibTobaccoUseProfile.httpNictizNlFhirStructureDefinitionZibTobaccoUse.rawValue:
					"zib_tobacco_use.heading"
				case ZibNutritionAdviceProfile.httpNictizNlFhirStructureDefinitionZibNutritionAdvice.rawValue:
					"zib_nutrition_advice.heading"
				
				default:
					nil
			}
		}
		
		/// What endpoints should we use for a category?
		var services: [(endpoint: DVP.Endpoint, serviceID: String)] {
			switch self {
				case .medication: [
					(DVP.CommonClinicalDataset.medicationUse, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.medicationAgreement, DVP.CommonClinicalDataset.serviceID),
					(DVP.GeneralPractitioner.currentMedication, DVP.GeneralPractitioner.serviceID),
					(DVP.CommonClinicalDataset.administrationAgreement, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .measurements: [
					(DVP.CommonClinicalDataset.bloodPressure, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.bodyWeight, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.bodyHeight, DVP.CommonClinicalDataset.serviceID)
//					(DVP.GeneralPractitioner.diagnosticAndLabResults, DVP.GeneralPractitioner.serviceID)
				]
				
				case .labresults: [
					(DVP.CommonClinicalDataset.laboratoryTestResult, DVP.CommonClinicalDataset.serviceID),
					(DVP.GeneralPractitioner.diagnosticAndLabResults, DVP.GeneralPractitioner.serviceID)
				]
				
				case .allergies: [
					(DVP.CommonClinicalDataset.allergyIntolerance, DVP.CommonClinicalDataset.serviceID),
					(DVP.GeneralPractitioner.allergyIntolerance, DVP.GeneralPractitioner.serviceID)
				]
//				
				case .treatments: [
					(DVP.CommonClinicalDataset.procedure, DVP.CommonClinicalDataset.serviceID)
//					(DVP.CommonClinicalDataset.plannedProcedures, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .appointments: [
					(DVP.CommonClinicalDataset.encounter, DVP.CommonClinicalDataset.serviceID)
//					(DVP.CommonClinicalDataset.plannedEncounters, DVP.CommonClinicalDataset.serviceID)
				]
				
				case .vaccinations: [
					(DVP.CommonClinicalDataset.vaccination, DVP.CommonClinicalDataset.serviceID)
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
					(DVP.CommonClinicalDataset.treatmentDirective, DVP.CommonClinicalDataset.serviceID),
					(DVP.CommonClinicalDataset.advanceDirective, DVP.CommonClinicalDataset.serviceID)
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
