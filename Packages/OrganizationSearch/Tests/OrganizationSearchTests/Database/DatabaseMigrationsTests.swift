/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Foundation
import GRDB
import Testing

@Suite("DatabaseMigrations.clearSchema")
struct DatabaseMigrationsTests {

	// MARK: - Helpers

	/// Opens a fresh in-memory `DatabaseQueue` for isolation between tests.
	///
	/// `DatabasePool` requires WAL mode which is not supported for in-memory databases,
	/// so `DatabaseQueue` is used here instead. Both conform to `DatabaseWriter`.
	private func makeInMemoryQueue() throws -> DatabaseQueue {
		try DatabaseQueue()
	}

	/// Returns the set of table names present in `queue`.
	private func tableNames(in queue: DatabaseQueue) throws -> Set<String> {
		try queue.read { db in
			let names = try String.fetchAll(db, sql: "SELECT name FROM sqlite_master WHERE type='table'")
			return Set(names)
		}
	}

	// MARK: - clearSchema when tables do not exist

	@Test("clearSchema on an empty database does not throw")
	func clearSchema_onEmptyDatabase_doesNotThrow() async throws {

		// Given
		let queue = try makeInMemoryQueue()

		// When / Then — must not throw even though no tables exist
		try await DatabaseMigrations.clearSchema(in: queue)
	}

	@Test("clearSchema on an empty database leaves no schema tables")
	func clearSchema_onEmptyDatabase_leavesNoSchemaTables() async throws {

		// Given
		let queue = try makeInMemoryQueue()

		// When
		try await DatabaseMigrations.clearSchema(in: queue)

		// Then
		let names = try tableNames(in: queue)
		#expect(!names.contains("organization_fts"))
		#expect(!names.contains("organization"))
		#expect(!names.contains("endpoint"))
	}

	// MARK: - clearSchema when all tables exist

	@Test("clearSchema drops all three tables when they exist")
	func clearSchema_withAllTables_dropsAllThree() async throws {

		// Given — build the full schema first
		let queue = try makeInMemoryQueue()
		try await DatabaseMigrations.createSchema(in: queue)

		let tablesBefore = try tableNames(in: queue)
		#expect(tablesBefore.contains("organization_fts"))
		#expect(tablesBefore.contains("organization"))
		#expect(tablesBefore.contains("endpoint"))

		// When
		try await DatabaseMigrations.clearSchema(in: queue)

		// Then
		let tablesAfter = try tableNames(in: queue)
		#expect(!tablesAfter.contains("organization_fts"))
		#expect(!tablesAfter.contains("organization"))
		#expect(!tablesAfter.contains("endpoint"))
	}

	@Test("clearSchema preserves the metadata table")
	func clearSchema_preservesMetadataTable() async throws {

		// Given
		let queue = try makeInMemoryQueue()
		try await DatabaseMigrations.ensureMetadataTable(in: queue)
		try await DatabaseMigrations.createSchema(in: queue)

		// When
		try await DatabaseMigrations.clearSchema(in: queue)

		// Then — metadata must survive the clear
		let tablesAfter = try tableNames(in: queue)
		#expect(tablesAfter.contains("metadata"))
	}

	// MARK: - clearSchema with partial schema

	@Test("clearSchema with only organization table does not throw")
	func clearSchema_withOnlyOrganizationTable_doesNotThrow() async throws {

		// Given — create only the organization table (no FTS or endpoint)
		let queue = try makeInMemoryQueue()
		try await queue.write { db in
			try db.create(table: "organization") { desc in
				desc.primaryKey("id", .text)
			}
		}

		// When / Then
		try await DatabaseMigrations.clearSchema(in: queue)

		let tablesAfter = try tableNames(in: queue)
		#expect(!tablesAfter.contains("organization"))
	}

	@Test("clearSchema with only endpoint table does not throw")
	func clearSchema_withOnlyEndpointTable_doesNotThrow() async throws {

		// Given — create only the endpoint table
		let queue = try makeInMemoryQueue()
		try await queue.write { db in
			try db.create(table: "endpoint") { desc in
				desc.primaryKey("id", .text)
			}
		}

		// When / Then
		try await DatabaseMigrations.clearSchema(in: queue)

		let tablesAfter = try tableNames(in: queue)
		#expect(!tablesAfter.contains("endpoint"))
	}

	// MARK: - clearSchema is idempotent

	@Test("clearSchema called twice does not throw")
	func clearSchema_calledTwice_doesNotThrow() async throws {

		// Given
		let queue = try makeInMemoryQueue()
		try await DatabaseMigrations.createSchema(in: queue)

		// When
		try await DatabaseMigrations.clearSchema(in: queue)

		// Then — second call on already-empty schema must also succeed
		try await DatabaseMigrations.clearSchema(in: queue)
	}
}

// MARK: -

@Suite("DatabaseMigrations.ETags")
struct DatabaseMigrationsETagTests {

	// MARK: - Helpers

	/// Creates a temporary DatabasePool backed by a unique file.
	///
	/// `DatabasePool` requires a file-backed database (WAL mode).
	/// The caller is responsible for cleaning up the returned URL.
	private func makePool() throws -> (DatabasePool, URL) {
		let url = FileManager.default.temporaryDirectory
			.appendingPathComponent(UUID().uuidString + ".sqlite")
		return (try DatabasePool(path: url.path), url)
	}

	// MARK: - readETag

	@Test("readETag returns nil when key is absent")
	func readETag_returnsNilWhenAbsent() async throws {

		// Given
		let (pool, url) = try makePool()
		defer { try? FileManager.default.removeItem(at: url) }
		try await DatabaseMigrations.ensureMetadataTable(in: pool)

		// When
		let result = try await DatabaseMigrations.readETag(
			key: DatabaseMigrations.organizationsETagKey, in: pool
		)

		// Then
		#expect(result == nil)
	}

	@Test("writeETag stores value and readETag returns it")
	func writeETag_storesValue() async throws {

		// Given
		let (pool, url) = try makePool()
		defer { try? FileManager.default.removeItem(at: url) }
		try await DatabaseMigrations.ensureMetadataTable(in: pool)

		// When
		try await DatabaseMigrations.writeETag(
			"\"etag-abc\"", key: DatabaseMigrations.organizationsETagKey, in: pool
		)
		let result = try await DatabaseMigrations.readETag(
			key: DatabaseMigrations.organizationsETagKey, in: pool
		)

		// Then
		#expect(result == "\"etag-abc\"")
	}

	@Test("writeETag nil deletes existing row")
	func writeETag_nil_deletesRow() async throws {

		// Given — write a value first, then delete it
		let (pool, url) = try makePool()
		defer { try? FileManager.default.removeItem(at: url) }
		try await DatabaseMigrations.ensureMetadataTable(in: pool)
		try await DatabaseMigrations.writeETag(
			"\"etag-abc\"", key: DatabaseMigrations.organizationsETagKey, in: pool
		)

		// When
		try await DatabaseMigrations.writeETag(
			nil, key: DatabaseMigrations.organizationsETagKey, in: pool
		)

		// Then
		let result = try await DatabaseMigrations.readETag(
			key: DatabaseMigrations.organizationsETagKey, in: pool
		)
		#expect(result == nil)
	}

	@Test("writeETag overwrites existing value")
	func writeETag_overwritesExistingValue() async throws {

		// Given
		let (pool, url) = try makePool()
		defer { try? FileManager.default.removeItem(at: url) }
		try await DatabaseMigrations.ensureMetadataTable(in: pool)
		try await DatabaseMigrations.writeETag(
			"\"etag-v1\"", key: DatabaseMigrations.organizationsETagKey, in: pool
		)

		// When
		try await DatabaseMigrations.writeETag(
			"\"etag-v2\"", key: DatabaseMigrations.organizationsETagKey, in: pool
		)

		// Then
		let result = try await DatabaseMigrations.readETag(
			key: DatabaseMigrations.organizationsETagKey, in: pool
		)
		#expect(result == "\"etag-v2\"")
	}

	// MARK: - readHash / writeHash

	@Test("readHash returns nil when absent")
	func readHash_returnsNilWhenAbsent() async throws {

		// Given
		let (pool, url) = try makePool()
		defer { try? FileManager.default.removeItem(at: url) }
		try await DatabaseMigrations.ensureMetadataTable(in: pool)

		// When
		let result = try await DatabaseMigrations.readHash(in: pool)

		// Then
		#expect(result == nil)
	}

	@Test("writeHash stores value and readHash returns it")
	func writeHash_storesValue() async throws {

		// Given
		let (pool, url) = try makePool()
		defer { try? FileManager.default.removeItem(at: url) }
		try await DatabaseMigrations.ensureMetadataTable(in: pool)

		// When
		try await DatabaseMigrations.writeHash("abc123hash", in: pool)
		let result = try await DatabaseMigrations.readHash(in: pool)

		// Then
		#expect(result == "abc123hash")
	}

	@Test("writeHash overwrites existing value")
	func writeHash_overwritesExistingValue() async throws {

		// Given
		let (pool, url) = try makePool()
		defer { try? FileManager.default.removeItem(at: url) }
		try await DatabaseMigrations.ensureMetadataTable(in: pool)
		try await DatabaseMigrations.writeHash("hash-v1", in: pool)

		// When
		try await DatabaseMigrations.writeHash("hash-v2", in: pool)

		// Then
		let result = try await DatabaseMigrations.readHash(in: pool)
		#expect(result == "hash-v2")
	}
}
