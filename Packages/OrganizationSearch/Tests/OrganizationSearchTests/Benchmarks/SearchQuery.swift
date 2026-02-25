/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// A single benchmark query loaded from `queries.json`.
///
/// Each entry pairs a natural-language search string with the identifier of the
/// organization that should appear in the results.
struct SearchQuery: Decodable {

	/// The search string to pass to the search engine.
	let query: String

	/// The `id` of the organization expected to be present in the results.
	let targetId: String
}

/// The ranking result for a single benchmark query.
///
/// `meanReciprocalRank` is the standard MRR metric: `1 / rank` when the target
/// is found, `0` when it is absent. Averaging MRR across all queries gives an
/// overall score between 0 (nothing found) and 1 (every target is first).
struct QueryBenchmarkResult {

	/// `1 / rank` when the target is found, `0` otherwise.
	let meanReciprocalRank: Double

	/// Human-readable position string, e.g. `"3/142"` or `"-1/142"` when not found.
	let rank: String

	/// Builds a result from a raw (0-based) index into the hit list.
	///
	/// - Parameters:
	///   - index: The 0-based position of the target in the results, or `nil` if absent.
	///   - totalHits: Total number of results returned for this query.
	init(index: Int?, totalHits: Int) {
		if let index {
			meanReciprocalRank = 1.0 / Double(index + 1)
			rank = "\(index + 1)/\(totalHits)"
		} else {
			meanReciprocalRank = 0
			rank = "-1/\(totalHits)"
		}
	}
}
