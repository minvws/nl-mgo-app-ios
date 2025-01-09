/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// The different parse methods for the FHIR Parser
public enum ParseMethod: String {
	
	case bundle = "getBundleResourcesJson"
	case resource = "getMgoResourceJson"
	case details = "getUiSchemaJson"
	case summary = "getSummaryUiSchemaJson"
}
