/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Configuration {
	
	/// Which domains are considered safe for browsing in-app
	/// - Returns: array fo allowed domains.
	public func getAllowedDomains() -> [String] {
		
		switch getRelease() {
			case .test: return ["web.test.mgo.irealisatie.nl"]
			case .acceptance: return ["web.test.mgo.irealisatie.nl", "web.acc.mgo.irealisatie.nl"]
			case .production: return ["web.mgo.irealisatie.nl"]
			case .development: return ["web.test.mgo.irealisatie.nl", "web.acc.mgo.irealisatie.nl", "web.mgo.irealisatie.nl", "apple.com", "www.apple.com"]
		}
	}
}
