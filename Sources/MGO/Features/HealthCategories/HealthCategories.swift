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
		case functionalOrMentalStatus = 11
		case alerts = 12
		case lifestyle = 13
		case devices = 14
		case plans = 15
		case payment = 16
		
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
					ZibBodyHeightProfile.httpNictizNlFhirStructureDefinitionZibBodyHeight.rawValue,
					GpDiagnosticResultProfile.httpNictizNlFhirStructureDefinitionGpDiagnosticResult.rawValue
				]
				
				case .labresults: [
					ZibLaboratoryTestResultObservationProfile.httpNictizNlFhirStructureDefinitionZibLaboratoryTestResultObservation.rawValue,
					GpLaboratoryResultProfile.httpNictizNlFhirStructureDefinitionGpLaboratoryResult.rawValue
				]
				
				case .allergies: [
					ZibAllergyIntoleranceProfile.httpNictizNlFhirStructureDefinitionZibAllergyIntolerance.rawValue
				]
				
				case .treatments: [
					ZibProcedureProfile.httpNictizNlFhirStructureDefinitionZibProcedure.rawValue,
					ZibProcedureRequestProfile.httpNictizNlFhirStructureDefinitionZibProcedureRequest.rawValue
				]
				
				case .appointments: [
					ZibEncounterProfile.httpNictizNlFhirStructureDefinitionZibEncounter.rawValue,
					EAfspraakAppointmentProfile.httpNictizNlFhirStructureDefinitionEAfspraakAppointment.rawValue,
					GpEncounterProfile.httpNictizNlFhirStructureDefinitionGpEncounter.rawValue,
					GpEncounterReportProfile.httpNictizNlFhirStructureDefinitionGpEncounterReport.rawValue,
					GpJournalEntryProfile.httpNictizNlFhirStructureDefinitionGpJournalEntry.rawValue
				]
				
				case .vaccinations: [
					ZibVaccinationProfile.httpNictizNlFhirStructureDefinitionZibVaccination.rawValue,
					ZibVaccinationRecommendationProfile.httpNictizNlFhirStructureDefinitionZibVaccinationRecommendation.rawValue,
					NlCoreVaccinationEventProfile.httpNictizNlFhirStructureDefinitionNlCoreVaccinationEvent.rawValue
				]
				
				case .documents: [
					IheMhdMinimalDocumentReferenceProfile.httpNictizNlFhirStructureDefinitionIHEMHDMinimalDocumentReference.rawValue
				]
				
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
					ZibMedicalDeviceProfile.httpNictizNlFhirStructureDefinitionZibMedicalDevice.rawValue,
					ZibMedicalDeviceRequestProfile.httpNictizNlFhirStructureDefinitionZibMedicalDeviceRequest.rawValue
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
				case GpDiagnosticResultProfile.httpNictizNlFhirStructureDefinitionGpDiagnosticResult.rawValue:
					"gp_diagnostic_result.heading"
				
				// Labresults
				case ZibLaboratoryTestResultObservationProfile.httpNictizNlFhirStructureDefinitionZibLaboratoryTestResultObservation.rawValue, GpLaboratoryResultProfile.httpNictizNlFhirStructureDefinitionGpLaboratoryResult.rawValue:
					"zip_laboratory_test_result_observation.heading"
				
				// Allergies
				case ZibAllergyIntoleranceProfile.httpNictizNlFhirStructureDefinitionZibAllergyIntolerance.rawValue:
					"zip_allergy_intolerance.heading"
				
				// Treatments
				case ZibProcedureProfile.httpNictizNlFhirStructureDefinitionZibProcedure.rawValue:
					"zib_procedure.heading"
				case ZibProcedureRequestProfile.httpNictizNlFhirStructureDefinitionZibProcedureRequest.rawValue:
					"zib_procedure_request.heading"
				
				// Appointments
				case ZibEncounterProfile.httpNictizNlFhirStructureDefinitionZibEncounter.rawValue:
					"zip_encounter.heading"
				case EAfspraakAppointmentProfile.httpNictizNlFhirStructureDefinitionEAfspraakAppointment.rawValue:
					"eAfspraak_appointment.heading"
				case GpEncounterProfile.httpNictizNlFhirStructureDefinitionGpEncounter.rawValue:
					"gp_encounter.heading"
				case GpEncounterReportProfile.httpNictizNlFhirStructureDefinitionGpEncounterReport.rawValue:
					"gp_encounter_report.heading"
				case GpJournalEntryProfile.httpNictizNlFhirStructureDefinitionGpJournalEntry.rawValue:
					"gp_journal_entry.heading"
				
				// Vaccinations
				case ZibVaccinationProfile.httpNictizNlFhirStructureDefinitionZibVaccination.rawValue,
					NlCoreVaccinationEventProfile.httpNictizNlFhirStructureDefinitionNlCoreVaccinationEvent.rawValue:
					"zip_vaccination.heading"
				case ZibVaccinationRecommendationProfile.httpNictizNlFhirStructureDefinitionZibVaccinationRecommendation.rawValue:
					"zip_vaccination_recommendation.heading"
				
				// Documents
				case IheMhdMinimalDocumentReferenceProfile.httpNictizNlFhirStructureDefinitionIHEMHDMinimalDocumentReference.rawValue:
					"ihe_mhd_minimal_document_reference.heading"
				
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
				case ZibMedicalDeviceProductProfile.httpNictizNlFhirStructureDefinitionZibMedicalDeviceProduct.rawValue:
					"zib_medical_device_product.heading"
				case ZibMedicalDeviceRequestProfile.httpNictizNlFhirStructureDefinitionZibMedicalDeviceRequest.rawValue:
					"zib_medical_device_request.heading"
				
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

		// What endpoints should we use for a category?
		var services: [DVP.Endpoint] {
			guard Current.featureFlagManager.isDemo else { return liveServices }
			return demoServices
		}
		
		// What endpoints should we use for a category for the real world?
		private var liveServices: [DVP.Endpoint] {
			switch self {
				case .medication: [
					DVP.CommonClinicalDataset.medicationUse,
					DVP.CommonClinicalDataset.medicationAgreement,
					DVP.GeneralPractitioner.currentMedication,
					DVP.CommonClinicalDataset.administrationAgreement
				]
				
				case .measurements: [
					DVP.CommonClinicalDataset.bloodPressure,
					DVP.CommonClinicalDataset.bodyWeight,
					DVP.CommonClinicalDataset.bodyHeight,
					DVP.GeneralPractitioner.diagnosticAndLabResults
				]
				
				case .labresults: [
					DVP.CommonClinicalDataset.laboratoryTestResult,
					DVP.GeneralPractitioner.diagnosticAndLabResults
				]
				
				case .allergies: [
					DVP.CommonClinicalDataset.allergyIntolerance,
					DVP.GeneralPractitioner.allergyIntolerance
				]
				
				case .treatments: [
					DVP.CommonClinicalDataset.procedure,
					DVP.CommonClinicalDataset.plannedProcedures
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
				
				case .complaints: [
					DVP.CommonClinicalDataset.problem
				]
				
				case .patient: [
					DVP.CommonClinicalDataset.patient,
					DVP.GeneralPractitioner.patient
				]
				
				case .functionalOrMentalStatus: [
					DVP.CommonClinicalDataset.functionalOrMentalStatus
				]
				
				case .alerts: [
					DVP.CommonClinicalDataset.alert,
					DVP.GeneralPractitioner.episodes
				]
				
				case .lifestyle: [
					DVP.CommonClinicalDataset.livingSituation,
					DVP.CommonClinicalDataset.drugUse,
					DVP.CommonClinicalDataset.alcoholUse,
					DVP.CommonClinicalDataset.tobaccoUse,
					DVP.CommonClinicalDataset.nutritionAdvice
				]
				
				case .devices: [
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
					
				case .labresults: return [
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
	}
}
