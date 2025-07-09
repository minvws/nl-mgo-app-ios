/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// The different parse methods for the FHIR Parser
public enum ParseMethod: String {
	
	/// Split a FHIR Bundle into an array of FHIR Resources
	case splitBundle = "getBundleResourcesJson"
	
	/// Parse a FHIR Resource into a MGO Resource
	case resource = "getMgoResourceJson"
	
	/// Parse an MGO Resource into a details HealthUISchema
	case details = "getDetailsJson"
	
	/// Parse an MGO Resource into a summary HealthUISchema
	case summary = "getSummaryJson"
}
