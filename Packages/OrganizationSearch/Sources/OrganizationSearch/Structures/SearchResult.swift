/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
import Foundation

// MARK: - SearchResult

/// A single result returned by an organization search query.
public struct SearchResult: Decodable, Hashable, Sendable {
	
	/// The matched organization.
	public let document: Organization

	/// The unique identifier of this search result, matching the organization's id.
	public let id: String

	/// The relevance score assigned by the search index; higher values indicate a closer match.
	public let score: Double
	
	/// Creates a new `SearchResult`.
	/// - Parameters:
	///   - document: The matched organization.
	///   - id: The unique identifier of this result.
	///   - score: The relevance score assigned by the search index.
	public init(document: Organization, id: String, score: Double) {
		self.document = document
		self.id = id
		self.score = score
	}
}
