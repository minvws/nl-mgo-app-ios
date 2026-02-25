/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing
import Foundation

/// Benchmark suite for `OrganizationSearchClient`.
///
/// Loads the query fixtures from `queries.json` once and runs them against a
/// fully prepared database so that individual benchmark tests can measure
/// search latency in isolation.
struct OrganizationSearchBenchmarks {

	/// All queries loaded from the `queries.json` resource bundle.
	static let queries: [SearchQuery] = {
		guard let url = Bundle.module.url(forResource: "queries", withExtension: "json") else {
			fatalError("Benchmarks: queries.json not found in bundle")
		}
		guard let data = try? Data(contentsOf: url) else {
			fatalError("Benchmarks: failed to load queries.json")
		}
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		guard let queries = try? decoder.decode([SearchQuery].self, from: data) else {
			fatalError("Benchmarks: failed to decode queries.json")
		}
		return queries
	}()
}
