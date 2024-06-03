/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Medication Use
public struct MgoMedicationUse: Codable, Equatable, Hashable {
	
	/// The title of the medication
	public var title: String
	
	/// The instructions how to take this medication
	public var instructions: String?
	
	/// Who prescribed this medication
	public var prescribedBy: String?
	
	/// When should we start with this medication
	public var startDate: String?
	
	/// What is the status of this medication
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
