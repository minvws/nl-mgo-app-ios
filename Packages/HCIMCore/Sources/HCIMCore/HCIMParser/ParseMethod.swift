/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// The different parse methods for the HCIM parser
public enum ParseMethod: String, Sendable {
	
	/// Split a FHIR Bundle into an array of FHIR Resources
	case splitBundle = "getBundleResourcesJson"
	
	/// Parse a FHIR Resource into a HCIM Resource
	case resource = "getMgoResourceJson"
	
	/// Parse an MGO Resource into a card HealthUISchema
	case card = "getCardJson"
	
	/// Parse an MGO Resource into a details HealthUISchema
	case details = "getDetailsJson"
	
	/// Parse an MGO Resource into a summary HealthUISchema
	case summary = "getSummaryJson"
}
