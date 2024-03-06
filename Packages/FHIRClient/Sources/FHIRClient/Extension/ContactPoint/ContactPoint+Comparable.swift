/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - Comparable -

extension ContactPoint: Comparable {
	
	/// Are two ContactPoints equal?
	/// - Parameters:
	///   - lhs: the first ContactPoint
	///   - rhs: the other ContactPoint to compare with
	/// - Returns: true if the first ContactPoint is less than the second
	public static func < (lhs: ContactPoint, rhs: ContactPoint) -> Bool {
		
		guard let lhsUseValue = lhs.use?.value else {
			return true
		}
		guard let rhsUseValue = rhs.use?.value else {
			return false
		}
		return lhsUseValue < rhsUseValue
	}
	
	/// Are two ContactPoints equal?
	/// - Parameters:
	///   - lhs: the first ContactPoint
	///   - rhs: the other ContactPoint to compare with
	/// - Returns: true if equal
	public static func == (lhs: ContactPoint, rhs: ContactPoint) -> Bool {
		
		return lhs.use == rhs.use
	}
}
