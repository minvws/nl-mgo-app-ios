/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import GRDB
import Testing

@Suite("DatabaseSearchQuery")
struct DatabaseSearchQueryTests {

	let queue: DatabaseQueue

	init() async throws {
		queue = try DatabaseQueue()
		try await DatabaseMigrations.ensureMetadataTable(in: queue)
		try await DatabaseMigrations.createSchema(in: queue)
		try await DatabasePopulator.insert(Self.testOrganizations, into: queue)
	}

	// MARK: - Test data

	/// Small set of organizations covering distinct name/city combinations.
	private static let testOrganizations: [Organization] = [
		Organization(
			address: OrganizationAddress(city: "Utrecht"),
			id: "1",
			name: "Huisman Zorg",
			searchBlob: "huisman zorg"
		),
		Organization(
			address: OrganizationAddress(city: "Rotterdam"),
			id: "2",
			name: "De Vries Kliniek",
			searchBlob: "de vries kliniek"
		),
		// id:3 has "Amsterdam" in the name — should rank above id:4 for city-only match
		Organization(
			address: OrganizationAddress(city: "Den Haag"),
			id: "3",
			name: "Amsterdam Kliniek",
			searchBlob: "amsterdam kliniek"
		),
		// id:4 has "Amsterdam" only in city — lower BM25 weight than name column
		Organization(
			address: OrganizationAddress(city: "Amsterdam"),
			id: "4",
			name: "Generieke Zorg",
			searchBlob: "generieke zorg"
		),
	]

	// MARK: - Exact match

	@Test("fetch exact name match returns result")
	func fetch_exactMatch_returnsResult() throws {

		// When
		let rows = try queue.read { db in
			try DatabaseSearchQuery.fetch(matching: "Huisman Zorg", in: db)
		}

		// Then
		let ids: [String] = rows.compactMap { $0["id"] }
		#expect(ids.contains("1"))
	}

	// MARK: - Prefix match

	@Test("fetch partial prefix returns matching result")
	func fetch_prefixMatch_returnsResult() throws {

		// When
		let rows = try queue.read { db in
			try DatabaseSearchQuery.fetch(matching: "Huis", in: db)
		}

		// Then
		let ids: [String] = rows.compactMap { $0["id"] }
		#expect(ids.contains("1"))
	}

	// MARK: - No match

	@Test("fetch non-matching term returns empty array")
	func fetch_nonMatch_returnsEmpty() throws {

		// When
		let rows = try queue.read { db in
			try DatabaseSearchQuery.fetch(matching: "Nonexistent", in: db)
		}

		// Then
		#expect(rows.isEmpty)
	}

	// MARK: - Empty term

	@Test("fetch empty string returns empty array")
	func fetch_emptyTerm_returnsEmpty() throws {

		// When
		let rows = try queue.read { db in
			try DatabaseSearchQuery.fetch(matching: "", in: db)
		}

		// Then
		#expect(rows.isEmpty)
	}

	// MARK: - Fuzzy fallback

	@Test("fetch single-char transposition falls back to fuzzy and returns result")
	func fetch_typo_fallsBackToFuzzy_returnsResult() throws {

		// Given — "Hiusman" is a transposition of "Huisman" — within edit distance 1
		// When
		let rows = try queue.read { db in
			try DatabaseSearchQuery.fetch(matching: "Hiusman", in: db)
		}

		// Then — ED1 fuzzy pass should recover "Huisman Zorg"
		let ids: [String] = rows.compactMap { $0["id"] }
		#expect(ids.contains("1"))
	}

	// MARK: - Relevance ordering

	@Test("fetch orders name match above city-only match")
	func fetch_resultsOrderedByRelevance() throws {

		// Given — "Amsterdam" is in the name of id:3 and only in the city of id:4
		// When
		let rows = try queue.read { db in
			try DatabaseSearchQuery.fetch(matching: "Amsterdam", in: db)
		}

		// Then — name match (id:3) must appear before city-only match (id:4)
		let ids: [String] = rows.compactMap { $0["id"] }
		#expect(ids.contains("3"))
		#expect(ids.contains("4"))
		let index3 = try #require(ids.firstIndex(of: "3"))
		let index4 = try #require(ids.firstIndex(of: "4"))
		#expect(index3 < index4)
	}
}
