/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing
import Foundation

class BenchmarksTests {
	
	@Test("Search native ranking: find target organization index for each query")
	func targetRankings() async throws {
		
		// Given
		let client = OrganizationSearchClient()
		try await client.prepare(dataset: .benchmark)
		let queries = OrganizationSearchBenchmarks.queries
		
		// When / Then
		var results: [QueryBenchmarkResult] = []
		
		for searchQuery in queries {
			let hits = try await client.searchHealthcareOrganizations(searchQuery.query).hits
			let index = hits.firstIndex { $0.document.id == searchQuery.targetId }
			let result = QueryBenchmarkResult(index: index, totalHits: hits.count)
			results.append(result)
			
			// print("[\(searchQuery.query)] → '\(searchQuery.targetId)' rank: \(result.rank) mrr: \(result.meanReciprocalRank)")
		}
		
		let meanMRR = results.map(\.meanReciprocalRank).reduce(0, +) / Double(results.count)
		// print("Mean Reciprocal Rank: \(meanMRR)")
		#expect(meanMRR >= 0.70, "JS MRR \(meanMRR) dropped below 0.70")
	}
	
	@Test("Search JS ranking: find target organization index for each query")
	func targetJSRankings() async throws {
		
		// Given
		let client = OrganizationSearchJSClient()
		try await client.prepare(dataset: .benchmark)
		let queries = OrganizationSearchBenchmarks.queries
		
		// When / Then
		var results: [QueryBenchmarkResult] = []
		
		for searchQuery in queries {
			let hits = try await client.searchHealthcareOrganizations(searchQuery.query).hits
			let index = hits.firstIndex { $0.document.id == searchQuery.targetId }
			let result = QueryBenchmarkResult(index: index, totalHits: hits.count)
			results.append(result)
			
			// print("[\(searchQuery.query)] → '\(searchQuery.targetId)' rank: \(result.rank) mrr: \(result.meanReciprocalRank)")
		}
		
		let meanMRR = results.map(\.meanReciprocalRank).reduce(0, +) / Double(results.count)
		// print("Mean Reciprocal Rank: \(meanMRR)")
		#expect(meanMRR >= 0.81, "JS MRR \(meanMRR) dropped below 0.81")
	}
}
