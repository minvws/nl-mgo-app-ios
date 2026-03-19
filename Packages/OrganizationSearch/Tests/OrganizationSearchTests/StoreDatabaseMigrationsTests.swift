/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import GRDB
import Testing

@Suite("StoreDatabaseMigrations")
struct StoreDatabaseMigrationsTests {

	// MARK: - Helpers

	/// Opens a fresh in-memory `DatabaseQueue` for isolation between tests.
	private func makeInMemoryQueue() throws -> DatabaseQueue {
		try DatabaseQueue()
	}

	/// Returns the column names of `table` in `queue`.
	private func columnNames(of table: String, in queue: DatabaseQueue) throws -> Set<String> {
		try queue.read { db in
			Set(try db.columns(in: table).map(\.name))
		}
	}

	// MARK: - Full migration from scratch (v1 → v2)

	@Test("migrate creates stored_organization with all expected columns")
	func migrate_onFreshDatabase_createsTableWithAllColumns() throws {

		// Given
		let queue = try makeInMemoryQueue()

		// When
		try StoreDatabaseMigrations.migrate(queue)

		// Then
		let columns = try columnNames(of: "stored_organization", in: queue)
		#expect(columns.contains("id"))
		#expect(columns.contains("address"))
		#expect(columns.contains("careType"))
		#expect(columns.contains("city"))
		#expect(columns.contains("dataServicesJSON"))
		#expect(columns.contains("medmijId"))
		#expect(columns.contains("name"))
		#expect(columns.contains("geoLat"))
		#expect(columns.contains("geoLng"))
		#expect(columns.contains("postalCode"))
	}

	@Test("migrate is idempotent when called twice")
	func migrate_calledTwice_doesNotThrow() throws {

		// Given
		let queue = try makeInMemoryQueue()
		try StoreDatabaseMigrations.migrate(queue)

		// When / Then — pending-migration check skips already-applied migrations
		try StoreDatabaseMigrations.migrate(queue)
	}

	// MARK: - v2: upgrade from v1 schema

	@Test("v2 wipes and rebuilds stored_organization from a v1 database")
	func v2_rebuildsTable_fromV1Schema() throws {

		// Given — simulate a v1 database (old column names, no medmijId)
		let queue = try makeInMemoryQueue()
		try queue.write { db in
			try db.create(table: "stored_organization") { desc in
				desc.primaryKey("id", .text)
				desc.column("addressLine", .text)   // old name
				desc.column("careType", .text)
				desc.column("city", .text)
				desc.column("dataServicesJSON", .text)
				desc.column("name", .text)
				desc.column("geoLat", .double)
				desc.column("geoLng", .double)
				desc.column("postalCode", .text)
				// medmijId absent
			}
			try db.execute(sql: "CREATE TABLE IF NOT EXISTS grdb_migrations (identifier TEXT NOT NULL PRIMARY KEY)")
			try db.execute(sql: "INSERT INTO grdb_migrations VALUES ('v1_createStoredOrganization')")
		}

		// When
		try StoreDatabaseMigrations.migrate(queue)

		// Then — table rebuilt with final schema
		let columns = try columnNames(of: "stored_organization", in: queue)
		#expect(columns.contains("address"))
		#expect(columns.contains("medmijId"))
		#expect(!columns.contains("addressLine"))
	}
}
