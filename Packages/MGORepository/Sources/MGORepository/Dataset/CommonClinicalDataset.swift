/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

extension DVP {
	
	// See https://catalogus.medmij.nl/overzicht/actueel/actuele-gegevensdiensten for serviceIDs

	// MARK: - CommonClinicalDataset (Bgz) -
	
	// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/FHIR_BGZ_2017
	public enum CommonClinicalDataset {
				
		public static let serviceID: String = "48"
		
		public static let lastn = "$lastn"
 
		// MARK: - 1: Patient Information -
		
		// Patient: GET [base]/Patient?_include=Patient:general-practitioner
		public static let patient: DVP.Endpoint = DVP.Endpoint(
			path: "Patient",
			parameters: RequestParameters(
				[
					(RequestParameterField.include, "Patient:general-practitioner")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 2: Payment Details -
		
		// Payer: GET [base]/Coverage?_include=Coverage:payor:Patient&_include=Coverage:payor:Organization
		public static let payer: DVP.Endpoint = DVP.Endpoint(
			path: "Coverage",
			parameters: RequestParameters(
				[
					(RequestParameterField.include, "Coverage:payor:Patient"),
					(RequestParameterField.include, "Coverage:payor:Organization")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 3: Treatment Directives -
		
		// TreatmentDirective: GET [base]/Consent?category=http://snomed.info/sct|11291000146105
		public static let treatmentDirective: DVP.Endpoint = DVP.Endpoint(
			path: "Consent",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "http://snomed.info/sct|11291000146105")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// AdvanceDirective: GET [base]/Consent?category=http://snomed.info/sct|11341000146107
		public static let advanceDirective: DVP.Endpoint = DVP.Endpoint(
			path: "Consent",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "http://snomed.info/sct|11341000146107")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 4: Contact Persons -
		
		// See Patient
		
		// MARK: - 5: Functional Status -
		
		// FunctionalOrMentalStatus: GET [base]/Observation/$lastn?category=http://snomed.info/sct|118228005,http://snomed.info/sct|384821006
		public static let functionalOrMentalStatus: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "http://snomed.info/sct|118228005,http://snomed.info/sct|384821006")
				]
			),
			directory: lastn,
			serviceId: CommonClinicalDataset.serviceID
			
		)
		
		// MARK: - 6: Problems -
		
		// GET [base]/Condition
		public static let problem: DVP.Endpoint = DVP.Endpoint(
			path: "Condition",
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 7: Social history -
		
		// LivingSituation: GET [base]/Observation/$lastn?code=http://snomed.info/sct|365508006
		public static let livingSituation: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "http://snomed.info/sct|365508006")
				]
			),
			directory: lastn,
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// DrugUse: GET [base]/Observation?code=http://snomed.info/sct|228366006
		public static let drugUse: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "http://snomed.info/sct|228366006")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// AlcoholUse: GET [base]/Observation?code=http://snomed.info/sct|228273003
		public static let alcoholUse: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "http://snomed.info/sct|228273003")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// TobaccoUse: GET [base]/Observation?code=http://snomed.info/sct|365980008
		public static let tobaccoUse: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "http://snomed.info/sct|365980008")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// NutritionAdvice: GET [base]/NutritionOrder
		public static let nutritionAdvice: DVP.Endpoint = DVP.Endpoint(
			path: "NutritionOrder",
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 8: Alerts -
		
		// Alert: GET [base]/Flag
		public static let alert: DVP.Endpoint = DVP.Endpoint(
			path: "Flag",
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 9: Allergies -
		
		// AllergyIntolerance: GET [base]/AllergyIntolerance
		public static let allergyIntolerance: DVP.Endpoint = DVP.Endpoint(
			path: "AllergyIntolerance",
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 10: Medication -
		
		// MedicationUse: GET [base]/MedicationStatement?category=urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6&_include=MedicationStatement:medication
		public static let medicationUse: DVP.Endpoint = DVP.Endpoint(
			path: "MedicationStatement",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6"),
					(RequestParameterField.include, "MedicationStatement:medication")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MedicationAgreement: GET [base]/MedicationRequest?category=http://snomed.info/sct|16076005&_include=MedicationRequest:medication
		public static let medicationAgreement: DVP.Endpoint = DVP.Endpoint(
			path: "MedicationRequest",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "http://snomed.info/sct|16076005"),
					(RequestParameterField.include, "MedicationRequest:medication")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// AdministrationAgreement: GET [base]/MedicationDispense?category=http://snomed.info/sct|422037009&_include=MedicationDispense:medication
		public static let administrationAgreement: DVP.Endpoint = DVP.Endpoint(
			path: "MedicationDispense",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "http://snomed.info/sct|422037009"),
					(RequestParameterField.include, "MedicationDispense:medication")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 11: Medical aids -
		
		// MedicalDevice: GET [base]/DeviceUseStatement?_include=DeviceUseStatement:device
		public static let medicalDevice: DVP.Endpoint = DVP.Endpoint(
			path: "DeviceUseStatement",
			parameters: RequestParameters(
				[
					(RequestParameterField.include, "DeviceUseStatement:device")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)

		// MARK: - 12: Vaccinations -
		
		// Vaccination: GET [base]/Immunization?status=completed
		public static let vaccination: DVP.Endpoint = DVP.Endpoint(
			path: "Immunization",
			parameters: RequestParameters(
				[
					(RequestParameterField.status, "completed")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 13: Vital signs -
		
		// BloodPressure: GET [base]/Observation/$lastn?code=http://loinc.org|85354-9
		public static let bloodPressure: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "http://loinc.org|85354-9")
				]
			),
			directory: lastn,
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// BodyWeight: GET [base]/Observation/$lastn?code=http://loinc.org|29463-7
		public static let bodyWeight: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "http://loinc.org|29463-7")
				]
			),
			directory: lastn,
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// BodyHeight: GET [base]/Observation/$lastn?code=http://loinc.org|8302-2,http://loinc.org|8306-3,http://loinc.org|8308-9
		public static let bodyHeight: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "http://loinc.org|8302-2,http://loinc.org|8306-3,http://loinc.org|8308-9")
				]
			),
			directory: lastn,
			serviceId: CommonClinicalDataset.serviceID
		)

		// MARK: - 14: Results -
		
		// LaboratoryTestResult: GET [base]/Observation/$lastn?category=http://snomed.info/sct|275711006&_include=Observation:related-target&_include=Observation:specimen
		public static let laboratoryTestResult: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "http://snomed.info/sct|275711006"),
					(RequestParameterField.include, "Observation:related-target"),
					(RequestParameterField.include, "Observation:specimen")
				]
			),
			directory: lastn,
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 15: Procedures -
		
		// Procedure: GET [base]/Procedure?category=http://snomed.info/sct|387713003
		public static let procedure: DVP.Endpoint = DVP.Endpoint(
			path: "Procedure",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "http://snomed.info/sct|387713003")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 16: Encounters -
		
		// Contact: GET [base]/Encounter?class=http://hl7.org/fhir/v3/ActCode|IMP,http://hl7.org/fhir/v3/ActCode|ACUTE,http://hl7.org/fhir/v3/ActCode|NONAC
		public static let encounter: DVP.Endpoint = DVP.Endpoint(
			path: "Encounter",
			parameters: RequestParameters(
				[
					(RequestParameterField.classParam, "http://hl7.org/fhir/v3/ActCode|IMP,http://hl7.org/fhir/v3/ActCode|ACUTE,http://hl7.org/fhir/v3/ActCode|NONAC")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 17: Planned Care -
		
		// PlannedProcedures: GET [base]/ProcedureRequest?status=active
		public static let plannedProcedures: DVP.Endpoint = DVP.Endpoint(
			path: "ProcedureRequest",
			parameters: RequestParameters(
				[
					(RequestParameterField.status, "active")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// PlannedImmunization: GET [base]/ImmunizationRecommendation
		public static let plannedImmunization: DVP.Endpoint = DVP.Endpoint(
			path: "ImmunizationRecommendation",
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// PlannedMedicalDevices: GET [base]/DeviceRequest?status=active&_include=DeviceRequest:device
		public static let plannedMedicalDevices: DVP.Endpoint = DVP.Endpoint(
			path: "DeviceRequest",
			parameters: RequestParameters(
				[
					(RequestParameterField.status, "active"),
					(RequestParameterField.include, "DeviceRequest:device")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// PlannedEncounters: GET [base]/Appointment?status=booked,pending,proposed
		public static let plannedEncounters: DVP.Endpoint = DVP.Endpoint(
			path: "Appointment",
			parameters: RequestParameters(
				[
					(RequestParameterField.status, "booked,pending,proposed")
				]
			),
			serviceId: CommonClinicalDataset.serviceID
		)
		
		// MARK: - 18: General Practitioner -
		
		// See Patient
	}
}
