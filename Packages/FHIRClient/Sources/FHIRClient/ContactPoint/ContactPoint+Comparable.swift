/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension ContactPoint: Comparable {
	
	public static func < (lhs: Models.ContactPoint, rhs: Models.ContactPoint) -> Bool {
		if lhs.use == nil {
			return true
		}
		if rhs.use == nil {
			return false
		}
		return lhs.use! < rhs.use!
	}
	
	public static func == (lhs: Models.ContactPoint, rhs: Models.ContactPoint) -> Bool {
		
		return lhs.use == rhs.use
	}
}
