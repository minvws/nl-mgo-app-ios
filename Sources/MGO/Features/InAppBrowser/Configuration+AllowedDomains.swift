/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Configuration {
	
	/// Which domains are considered safe for browsing in-app
	/// - Returns: array of allowed domains.
	public func getAllowedDomains(for release: Release) -> [String] {

		let testDomain = "web.test.mgo.irealisatie.nl"
		let acceptationDomain = "web.acc.mgo.irealisatie.nl"
		let productionDomain = "web.mgo.irealisatie.nl"
		
		switch release {
			case .test, .demo: return [testDomain]
			case .acceptance: return [testDomain, acceptationDomain]
			case .production: return [productionDomain]
			case .development: return [testDomain, acceptationDomain, productionDomain]
		}
	}
}
