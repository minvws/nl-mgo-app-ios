/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension ContactPointUse: Comparable {
	
	public static func < (lhs: Models.ContactPointUse, rhs: Models.ContactPointUse) -> Bool {
		lhs.sortOrder < rhs.sortOrder
	}

	public static func == (lhs: Models.ContactPointUse, rhs: Models.ContactPointUse) -> Bool {
		lhs.sortOrder == rhs.sortOrder
	}
	
	private var sortOrder: Int {
		switch self {
			case .home:
				1
			case .work:
				2
			case .temp:
				3
			case .old:
				4
			case .mobile:
				5
		}
	}
}
