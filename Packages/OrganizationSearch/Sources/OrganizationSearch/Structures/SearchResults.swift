/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
import Foundation

// MARK: - SearchResults
public struct SearchResults: Codable, Hashable, Sendable {
	
	public let count: Double
	public let hits: [SearchResult]
	
	public init(count: Double, hits: [SearchResult]) {
		self.count = count
		self.hits = hits
	}
}
