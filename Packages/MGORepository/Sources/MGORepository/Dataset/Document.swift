/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

extension DVP {
	
	// See https://catalogus.medmij.nl/overzicht/actueel/actuele-gegevensdiensten for serviceIDs

	// MARK: - Documents -
	
	/// The settings for the Documents PDF/A
	public enum Documents {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/OntwerpPDFA
		
		public static let serviceID: String = "51"
		
		// MARK: - 1: Document -
		
		/*
		 Discovery of PDF/A documents is done with the MHD defined transaction 'Find Document Reference' or 'Find Document Manifest.' The Find Document Reference retrieves FHIR DocumentReference Resources that represents a single reference to document per resource, for example, one PDF/A file. The Find Document Manifest retrieves FHIR DocumentManifest Resources. A DocumentManifest Resource gathers a set of DocumentReference Resources into a single package together with metadata that applies to the collection.
		 */
		
		// Note: a separate query for Patient may not be necessary for clients or supported by servers as this data is attached in context to every other (clinical) resource.
		// GET [base]/DocumentReference
		public static let documentReference: DVP.Endpoint = DVP.Endpoint(
			path: "DocumentReference",
			serviceId: Documents.serviceID
		)
	}
}
