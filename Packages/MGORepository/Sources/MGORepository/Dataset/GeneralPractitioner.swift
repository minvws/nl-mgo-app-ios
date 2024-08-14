/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

extension DVP {
	
	// See https://catalogus.medmij.nl/overzicht/actueel/actuele-gegevensdiensten for serviceIDs

	// MARK: - GeneralPractitioner -
	
	
	/// The settings for the Huisartsgegevens
	public enum GeneralPractitioner {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/FHIR_GP_Data
		
		public static let serviceID: Int = 49
		
		// MARK: - 1: General practitioner -
		
		// See Patient
		// Note: a separate query for General Practitioner/Practice is not required as this data is attached in context to the Patient resource.
		
		// MARK: - 2: Patient Information -
		
		// Note: a separate query for Patient may not be necessary for clients or supported by servers as this data is attached in context to every other (clinical) resource.
		// Patient: GET [base]/Patient?_include=Patient:general-practitioner
		public static let patient: DVP.Endpoint = DVP.Endpoint(
			path: "Patient",
			parameters: RequestParameters(
				[
					(RequestParameterField.include, "Patient:general-practitioner")
				]
			)
		)
		
		// MARK: - 3: Episodes -
		
		/*
		 A server MAY implement inclusion of associated Flag resources indicating that the GP has added an attention value to this episode. The reference from the Flag to the EpisodeOfCare is handled though Flag.extension(ConcernReference). For this reason, it is not possible for clients to request this information explicitly using _include or _revInclude parameters. Note that attention flags on a an episode are aimed at the GP, not at the patient.
		 */
		// Patient: GET [base]/EpisodeOfCare
		public static let episodes: DVP.Endpoint = DVP.Endpoint(
			path: "EpisodeOfCare"
		)
		
		// MARK: - 4: Episodes with alert flag -
		
		// See 3
		
		// MARK: - 5: Open and closed episodes -
		
		// See 3
		
		// MARK: - 6: Treatment -
		
		// TODO: No HCIM. GP systems do not yet export this info.
		
		// MARK: - 7: Prophylaxis en precaution -
		
		// TODO: No HCIM. GP systems do not yet export this info. Unclear if it'll be anything beyond the Table 56 code (id, time, author, text?)
		
		// MARK: - 8: Current Medication -
		// GET [base]/MedicationRequest?periodofuse=ge[today]&category=http://snomed.info/sct|16076005&_include=MedicationRequest:medication
		public static let currentMedication: DVP.Endpoint = DVP.Endpoint(
			path: "MedicationRequest",
			parameters: RequestParameters(
				[
					(RequestParameterField.periodOfUse, "ge[today]"),
					(RequestParameterField.category, "http://snomed.info/sct|16076005"),
					(RequestParameterField.include, "MedicationRequest:medication")
				]
			)
		)
		
		// MARK: - 9: 	Medication intolerance -
		// GET [base]/AllergyIntolerance?category=medication
		public static let allergyIntolerance: DVP.Endpoint = DVP.Endpoint(
			path: "AllergyIntolerance",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "medication")
				]
			)
		)
		
		// MARK: - 10: Correspondence -
		
		// TODO: No HCIM. GP systems do not yet export this info. For PDF(/A) based correspondence it is possible to turn to the relevant information standard for that type of data.
		
		// MARK: - 11: 	Diagnostic and lab results -
		
		// Result GET [base]/Observation?code=https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|&_include=Observation:related-target&_include=Observation:specimen&date=ge2017-01-01
		public static let result: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|"),
					(RequestParameterField.include, "Observation:related-target"),
					(RequestParameterField.include, "Observation:specimen"),
					(RequestParameterField.date, "ge2017-01-01")
				]
			)
		)
		
		// MARK: - 12: SOAP entries -
		
		// Contact: GET [base]/Composition?type=http://loinc.org|67781-5
		public static let soapEntries: DVP.Endpoint = DVP.Endpoint(
			path: "Composition",
			parameters: RequestParameters(
				[
					(RequestParameterField.type, "http://loinc.org|67781-5")
				]
			)
		)
		
		// MARK: - 13: Encounters -
		
		// Contact: GET [base]/Encounter
		public static let encounter: DVP.Endpoint = DVP.Endpoint(
			path: "Encounter"
		)
		
	}
}
