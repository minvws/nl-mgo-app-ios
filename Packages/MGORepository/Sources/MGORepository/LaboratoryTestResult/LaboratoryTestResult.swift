/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public struct MgoLaboratoryTestResult: Codable, Equatable, Hashable {
	
	public var title: String
	
	public var code: String?

	public var status: String?

	public var dateTime: String?

	public var result: String?

	public var referenceRangeLow: String?

	public var referenceRangeHigh: String?

	public var interpretation: String?
	
	public var specimen: String?
	
	public var collectionDateTime: String?
}
