/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		let decoder = JSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		guard
			let url = Bundle.module.url(forResource: "queries", withExtension: "json"),
			let data = try? Data(contentsOf: url),
			let queries = try? decoder.decode([SearchQuery].self, from: data)
		else {
			fatalError("Benchmarks: failed to load or decode queries.json")
		}
		return queries
	}()
}
