/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public struct MgoMedicationUse: Codable, Equatable, Hashable {
	
	public var title: String
	
	public var instructions: String?
	
	public var prescribedBy: String?
	
	public var startDate: String?
	
	public var status: String?
	
	public init(
		title: String,
		instructions: String? = nil,
		prescribedBy: String? = nil,
		startDate: String? = nil,
		status: String? = nil
	) {
		self.title = title
		self.instructions = instructions
		self.prescribedBy = prescribedBy
		self.startDate = startDate
		self.status = status
	}
}
