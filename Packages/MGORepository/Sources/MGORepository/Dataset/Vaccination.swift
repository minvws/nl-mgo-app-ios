/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

extension DVP {
	
	// See https://catalogus.medmij.nl/overzicht/actueel/actuele-gegevensdiensten for serviceIDs

	// MARK: - Vaccination -
	
	public enum Vaccination {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V6/FHIR_Vaccination-Immunization
		
		public static let serviceID: String = "63"
		
		// MARK: - 1: Vaccination -

		// Patient: GET [base]/Immunization
		public static let patient: DVP.Endpoint = DVP.Endpoint(
			path: "Immunization",
			serviceId: Vaccination.serviceID,
			fhirVersion: .r4
		)
	}
}
