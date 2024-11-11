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

	// MARK: - Documents -
	
	/// The settings for the Documents PDF/A
	public enum Documents {
		// See https://informatiestandaarden.nictiz.nl/wiki/MedMij:V2020.01/OntwerpPDFA
		
		public static let serviceID: Int = 51
	}
}
