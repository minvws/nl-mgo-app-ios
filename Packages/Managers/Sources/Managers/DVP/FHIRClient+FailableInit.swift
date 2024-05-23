/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import FHIRClient

extension FHIRClient {
	
	convenience public init?() {
	
		guard let serverURL = URL(string: "https://dva.test.mgo.irealisatie.nl/fhir") else { return nil }
		self.init(baseURL: serverURL)
	}
}
