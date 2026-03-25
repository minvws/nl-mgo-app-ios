/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
import Foundation

// MARK: - SearchResults

/// The top-level response from an organization search query.
public struct SearchResults: Decodable, Hashable, Sendable {
	
	/// The total number of matching organizations in the index.
	public let count: Int

	/// The list of individual search results for the current page.
	public let hits: [SearchResult]

	/// Creates a new `SearchResults`.
	/// - Parameters:
	///   - count: The total number of matching organizations.
	///   - hits: The individual search results for the current page.
	public init(count: Int, hits: [SearchResult]) {
		self.count = count
		self.hits = hits
	}
}
