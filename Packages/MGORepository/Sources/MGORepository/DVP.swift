/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public struct DVP {
	
	/// The settings for the Basisgegevensset Zorg
	public enum CommonClinicalDataset {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/FHIR_BGZ_2017
		
		public static let serviceID: Int = 48
		
		public static let medicationUse: RequestParameters = RequestParameters(
			[
				(RequestParameterField.category, "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6"),
				(RequestParameterField.include, "MedicationStatement:medication")
			]
		)
		
		public static let concern: RequestParameters = RequestParameters(
			[
				(RequestParameterField.format, "json")
			]
		)
		
		public static let laboratoryTestResult: RequestParameters = RequestParameters(
			[
				(RequestParameterField.category, "http://snomed.info/sct|275711006"),
				(RequestParameterField.include, "Observation:related-target"),
				(RequestParameterField.include, "Observation:specimen")
			]
		)
	}
	
	/// The settings for the Huisartsgegevens
	public enum GeneralPractitioner {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/OntwerpHuisartsgegevens
		
		public static let serviceID: Int = 49
	}
	
	/// The settings for the Documenten PDF/A
	public enum Documents {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/OntwerpPDFA
		
		public static let serviceID: Int = 51
	}
}
