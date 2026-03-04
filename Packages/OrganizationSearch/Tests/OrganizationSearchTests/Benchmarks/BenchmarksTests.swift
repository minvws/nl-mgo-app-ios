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
		try OrganizationSearchClientTests.deleteDatabase(for: .benchmark)
		let client = OrganizationSearchClient()
		try await client.prepare(dataset: .benchmark)
		let queries = OrganizationSearchBenchmarks.queries
		
		// When
		var reportQueries: [ReportQuery] = []
		
		for searchQuery in queries {
			let hits = try await client.searchHealthcareOrganizations(searchQuery.query).hits
			let index = hits.firstIndex { $0.document.id == searchQuery.targetId }
			let result = QueryBenchmarkResult(index: index, totalHits: hits.count)
			reportQueries.append(ReportQuery(
				query: searchQuery.query,
				targetId: searchQuery.targetId,
				meanReciprocalRank: result.meanReciprocalRank,
				rank: result.rank
			))
		}
		
		// Then
		let meanMRR = reportQueries.map(\.meanReciprocalRank).reduce(0, +) / Double(reportQueries.count)
		let failedQueries = reportQueries.filter { $0.meanReciprocalRank == 0 }.count
		let resultaat = BenchmarkReport(
			name: "native-search-iOS",
			meanReciprocalRank: meanMRR,
			failedQueries: failedQueries,
			totalQueries: reportQueries.count,
			searchConfig: nil,
			queries: reportQueries
		)
		let encoder = JSONEncoder()
		encoder.outputFormatting = [.prettyPrinted]
		if let jsonData = try? encoder.encode(resultaat), let jsonString = String(data: jsonData, encoding: .utf8) {
			print(jsonString)
		}
		#expect(resultaat.meanReciprocalRank >= 0.811, "MRR \(resultaat.meanReciprocalRank) dropped below 0.811")
		
		await client.teardown()
	}
}

// MARK: - ReportQuery
public struct ReportQuery: Codable, Equatable, Sendable {
	public let query: String
	public let targetId: String
	public let meanReciprocalRank: Double
	public let rank: String
	
	public init(
		query: String,
		targetId: String,
		meanReciprocalRank: Double,
		rank: String
	) {
		self.query = query
		self.targetId = targetId
		self.meanReciprocalRank = meanReciprocalRank
		self.rank = rank
	}
}

// MARK: - BenchmarkReport
public struct BenchmarkReport: Codable, Equatable, Sendable {
	public let name: String
	public let meanReciprocalRank: Double
	public let failedQueries: Int
	public let totalQueries: Int
	public var searchConfig: String?
	public let queries: [ReportQuery]
	
	public init(
		name: String,
		meanReciprocalRank: Double,
		failedQueries: Int,
		totalQueries: Int,
		searchConfig: String?,
		queries: [ReportQuery]
	) {
		self.name = name
		self.meanReciprocalRank = meanReciprocalRank
		self.failedQueries = failedQueries
		self.totalQueries = totalQueries
		self.searchConfig = searchConfig
		self.queries = queries
	}
}
