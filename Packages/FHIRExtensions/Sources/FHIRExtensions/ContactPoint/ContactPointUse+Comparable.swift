/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - Comparable -

extension ContactPointUse: Comparable {
	
	/// Are two ContactPointUse equal
	/// - Parameters:
	///   - lhs: the first contact point usage
	///   - rhs: the contact point usage to compare with
	/// - Returns: true if the first contact point usage is smaller than the other one.
	public static func < (lhs: ContactPointUse, rhs: ContactPointUse) -> Bool {
		lhs.sortOrder < rhs.sortOrder
	}
	
	/// Are two ContactPointUse equal
	/// - Parameters:
	///   - lhs: the first contact point usage
	///   - rhs: the contact point usage to compare with
	/// - Returns: true if equal
	public static func == (lhs: ContactPointUse, rhs: ContactPointUse) -> Bool {
		lhs.sortOrder == rhs.sortOrder
	}
	
	/// the sort order to compare on
	private var sortOrder: Int {
		switch self {
			case .home: 1
			case .work: 2
			case .temp: 3
			case .old: 4
			case .mobile: 5
		}
	}
}
