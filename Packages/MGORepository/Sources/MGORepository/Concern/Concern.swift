/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// Concern
public struct MgoConcern: Codable, Equatable, Hashable {
	
	public var title: String
	
	public var category: String?
	
	public var clinicalStatus: String?
	
	public var startDate: String?
	
	public var endDate: String?
	
	public var bodyLocation: String?
	
	public var comment: String?
	
	public init(
		title: String,
		category: String? = nil,
		clinicalStatus: String? = nil,
		startDate: String? = nil,
		endDate: String? = nil,
		bodyLocation: String? = nil,
		comment: String? = nil) {
		self.title = title
		self.category = category
		self.clinicalStatus = clinicalStatus
		self.startDate = startDate
		self.endDate = endDate
		self.bodyLocation = bodyLocation
		self.comment = comment
	}
}
