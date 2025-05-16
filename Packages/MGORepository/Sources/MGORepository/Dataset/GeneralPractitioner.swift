/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		
		public static let serviceID: String = "49"
		
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
			),
			serviceId: GeneralPractitioner.serviceID
		)
		
		// MARK: - 3: Episodes -
		
		/*
		 A server MAY implement inclusion of associated Flag resources indicating that the GP has added an attention value to this episode. The reference from the Flag to the EpisodeOfCare is handled though Flag.extension(ConcernReference). For this reason, it is not possible for clients to request this information explicitly using _include or _revInclude parameters. Note that attention flags on a an episode are aimed at the GP, not at the patient.
		 */
		// Patient: GET [base]/EpisodeOfCare
		public static let episodes: DVP.Endpoint = DVP.Endpoint(
			path: "EpisodeOfCare",
			serviceId: GeneralPractitioner.serviceID
		)
		
		// MARK: - 4: Episodes with alert flag -
		
		// See 3
		
		// MARK: - 5: Open and closed episodes -
		
		// See 3
		
		// MARK: - 6: Treatment -
		
		// TODO: No HCIM. GP systems do not yet export this info.
		// swiftlint:disable:previous todo
		
		// MARK: - 7: Prophylaxis en precaution -
		
		// TODO: No HCIM. GP systems do not yet export this info. Unclear if it'll be anything beyond the Table 56 code (id, time, author, text?)
		// swiftlint:disable:previous todo
		
		// MARK: - 8: Current Medication -
		// GET [base]/MedicationRequest?periodofuse=ge[today]&category=http://snomed.info/sct|16076005&_include=MedicationRequest:medication
		public static func currentMedication(_ date: Date = Date()) -> DVP.Endpoint {
			
			let formater = DateFormatter()
			formater.timeZone = TimeZone(abbreviation: "CET")
			formater.dateFormat = "yyyy-MM-dd"
			
			return DVP.Endpoint(
				path: "MedicationRequest",
				parameters: RequestParameters(
					[
						(RequestParameterField.periodOfUse, "ge\(formater.string(from: date))"),
						(RequestParameterField.category, "http://snomed.info/sct|16076005"),
						(RequestParameterField.include, "MedicationRequest:medication")
					]
				),
				serviceId: GeneralPractitioner.serviceID
			)
		}
		
		// MARK: - 9: 	Medication intolerance -
		// GET [base]/AllergyIntolerance?category=medication
		public static let allergyIntolerance: DVP.Endpoint = DVP.Endpoint(
			path: "AllergyIntolerance",
			parameters: RequestParameters(
				[
					(RequestParameterField.category, "medication")
				]
			),
			serviceId: GeneralPractitioner.serviceID
		)
		
		// MARK: - 10: Correspondence -
		
		// TODO: No HCIM. GP systems do not yet export this info. For PDF(/A) based correspondence it is possible to turn to the relevant information standard for that type of data.
		// swiftlint:disable:previous todo
		
		// MARK: - 11: 	Diagnostic and lab results -
		
		// Result GET [base]/Observation?code=https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|&_include=Observation:related-target&_include=Observation:specimen
		public static let diagnosticAndLabResults: DVP.Endpoint = DVP.Endpoint(
			path: "Observation",
			parameters: RequestParameters(
				[
					(RequestParameterField.code, "https://referentiemodel.nhg.org/tabellen/nhg-tabel-45-diagnostische-bepalingen|"),
					(RequestParameterField.include, "Observation:related-target"),
					(RequestParameterField.include, "Observation:specimen")
				]
			),
			serviceId: GeneralPractitioner.serviceID
		)
		
		// MARK: - 12: SOAP entries -
		
		// Contact: GET [base]/Composition?type=http://loinc.org|67781-5
		public static let soapEntries: DVP.Endpoint = DVP.Endpoint(
			path: "Composition",
			parameters: RequestParameters(
				[
					(RequestParameterField.type, "http://loinc.org|67781-5")
				]
			),
			serviceId: GeneralPractitioner.serviceID
		)
		
		// MARK: - 13: Encounters -
		
		// Contact: GET [base]/Encounter
		public static let encounter: DVP.Endpoint = DVP.Endpoint(
			path: "Encounter",
			serviceId: GeneralPractitioner.serviceID
		)
	}
}
