/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Testing
import Foundation

@Suite(.serialized)
class OrganizationSearchClientTests {

	@Test("Search for an organization")
	func search() async throws {

		// Given
		let sut = OrganizationSearchClient()
		let searchTerm = "Testtest"
		try await sut.prepare(dataset: .test)

		// When
		let searchResult = try? await sut.searchHealthcareOrganizations(searchTerm)

		// Then
		#expect(searchResult != nil)
		#expect(searchResult?.count == 9.0)
	}

	@Test("Search for an organization without indexing")
	func searchWithoutIndexing() async throws {

		// Given
		let sut = OrganizationSearchClient()
		let searchTerm = "Test"

		// When / Then
		await #expect(throws: OrganizationSearchError.notPrepared) {
			try await sut.searchHealthcareOrganizations(searchTerm)
		}
	}

	// MARK: - Hash-based populate skip

	@Test("Second prepare with unchanged data should skip repopulation")
	func prepare_calledTwice_skipsSecondPopulate() async throws {

		// Given - ensure a clean slate so the first prepare always inserts rows
		try OrganizationSearchClientTests.deleteDatabase(for: .test)
		let actor = DatabaseActor()

		// When - first prepare populates the database
		let firstCount = try await actor.prepare(dataset: .test)

		// Then - second prepare with the same JSON returns 0 (skipped)
		let secondCount = try await actor.prepare(dataset: .test)
		#expect(firstCount > 0)
		#expect(secondCount == 0)
	}

	@Test("Search still works after hash-skip on second prepare")
	func prepare_calledTwice_searchStillWorks() async throws {

		// Given
		let sut = OrganizationSearchClient()
		try await sut.prepare(dataset: .test)

		// When - second prepare should be a no-op but leave the database intact
		try await sut.prepare(dataset: .test)
		let result = try? await sut.searchHealthcareOrganizations("Testtest")

		// Then
		#expect(result?.count == 9.0)
	}

	// MARK: - Search text normalization

	@Test("normalizeSearchText collapses whitespace")
	func normalizeSearchText_collapsesWhitespace() {

		// Given
		let input = "Zorg  Instelling   Amsterdam"

		// When
		let result = DatabasePopulator.normalizeSearchText(input)

		// Then
		#expect(result == "zorg instelling amsterdam")
	}

	@Test("normalizeSearchText trims and lowercases")
	func normalizeSearchText_trimsAndLowercases() {

		// Given
		let input = "  Tandarts  "

		// When
		let result = DatabasePopulator.normalizeSearchText(input)

		// Then
		#expect(result == "tandarts")
	}

	@Test("normalizeSearchText keeps dots and commas")
	func normalizeSearchText_keepsPunctuation() {

		// Given
		let input = "J.S. Huisman, Huisarts"

		// When
		let result = DatabasePopulator.normalizeSearchText(input)

		// Then
		#expect(result == "j s huisman huisarts")
	}

	@Test("normalizeSearchText returns nil for nil input")
	func normalizeSearchText_returnsNilForNilInput() {

		// Given
		let input: String? = nil

		// When
		let result = DatabasePopulator.normalizeSearchText(input)

		// Then
		#expect(result == nil)
	}

	// MARK: - Hash computation

	@Test("computeHash returns a non-empty hex string")
	func computeHash_returnsNonEmptyHexString() throws {

		// Given
		let data = Data("hello world".utf8)

		// When
		let hash = DatabasePopulator.computeHash(of: data)

		// Then - SHA-256 produces a 64-character hex string
		#expect(hash.count == 64)
		#expect(hash.allSatisfy { $0.isHexDigit })
	}

	@Test("computeHash is deterministic for the same input")
	func computeHash_isDeterministic() throws {

		// Given
		let data = Data("consistent input".utf8)

		// When
		let hash1 = DatabasePopulator.computeHash(of: data)
		let hash2 = DatabasePopulator.computeHash(of: data)

		// Then
		#expect(hash1 == hash2)
	}

	@Test("computeHash differs for different inputs")
	func computeHash_differsForDifferentInputs() throws {

		// Given
		let data1 = Data("input one".utf8)
		let data2 = Data("input two".utf8)

		// When
		let hash1 = DatabasePopulator.computeHash(of: data1)
		let hash2 = DatabasePopulator.computeHash(of: data2)

		// Then
		#expect(hash1 != hash2)
	}

	// MARK: - Helpers

	/// Removes the on-disk SQLite file (and WAL/SHM sidecars) for `dataset`
	/// so that the next `prepare(dataset:)` always does a full repopulate
	/// rather than hitting the hash-skip path.
	static func deleteDatabase(for dataset: OrganizationDataset) throws {
		let appSupportURL = try FileManager.default.url(
			for: .applicationSupportDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: false
		)
		let dbURL = appSupportURL.appendingPathComponent("\(dataset.resourceName).sqlite")
		try? FileManager.default.removeItem(at: dbURL)
		try? FileManager.default.removeItem(atPath: dbURL.path + "-wal")
		try? FileManager.default.removeItem(atPath: dbURL.path + "-shm")
	}
}
