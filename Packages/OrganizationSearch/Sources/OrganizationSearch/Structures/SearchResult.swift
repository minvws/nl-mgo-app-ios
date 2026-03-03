/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
import Foundation

// MARK: - SearchResult
public struct SearchResult: Codable, Hashable, Sendable {
	
	public let document: Organization
	public let id: String
	public let score: Double
	
	public init(document: Organization, id: String, score: Double) {
		self.document = document
		self.id = id
		self.score = score
	}
}
