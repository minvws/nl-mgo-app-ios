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

	// MARK: - Vaccination -
	
	public enum Vaccination {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V6/FHIR_Vaccination-Immunization
		
		public static let serviceID: Int = 63
		
		// MARK: - 1: Vaccination -

		// Patient: GET [base]/Immunization?_include:patient
		public static let patient: DVP.Endpoint = DVP.Endpoint(
			path: "Immunization",
			parameters: RequestParameters(
				[
					(RequestParameterField.include, "patient")
				]
			)
		)
		
		// Location: GET [base]/Immunization?_include:location
		public static let location: DVP.Endpoint = DVP.Endpoint(
			path: "Immunization",
			parameters: RequestParameters(
				[
					(RequestParameterField.include, "location")
				]
			)
		)
		
		// Performer: GET [base]/Immunization?_include:performer
		public static let performer: DVP.Endpoint = DVP.Endpoint(
			path: "Immunization",
			parameters: RequestParameters(
				[
					(RequestParameterField.include, "performer")
				]
			)
		)
	}
}
