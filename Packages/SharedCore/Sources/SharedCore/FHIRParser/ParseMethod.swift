/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// The different parse methods for the FHIR Parser
public enum ParseMethod: String {
	
	case bundle = "getBundleResourcesJson"
	case resource = "getMgoResourceJson"
	case details = "getDetailsJson"
	case summary = "getSummaryJson"
}
