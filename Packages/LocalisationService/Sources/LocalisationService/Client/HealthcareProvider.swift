/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import OpenAPIURLSession

public typealias HealthcareProvider = Components.Schemas.Organization

public extension Components.Schemas.Organization {
	
	/// What is the category of a healthcare provider?
	var category: String? {
		return types.first?.display_name
	}
	
	/// What endpoint should we pass to the proxy?
	var dvaTarget: String? {
		return "https://dva-mock.test.mgo.prolocation.net/48"
	}
}
