/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

public struct DVP {
	
	public enum BGZ {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/FHIR_BGZ_2017
		
		public static let medicationUse: RequestParameters = RequestParameters(
			[
				(RequestParameterField.category, "urn:oid:2.16.840.1.113883.2.4.3.11.60.20.77.5.3|6"),
				(RequestParameterField.include, "MedicationStatement:medication")
			]
		)
		
		public static let concern: RequestParameters = RequestParameters(
			[(RequestParameterField.format, "json")]
		)
		
		public static let laboratoryTestResult: RequestParameters = RequestParameters(
			[
				(RequestParameterField.category, "http://snomed.info/sct|275711006"),
				(RequestParameterField.include, "Observation:related-target"),
				(RequestParameterField.include, "Observation:specimen")
			]
		)
	}
}
