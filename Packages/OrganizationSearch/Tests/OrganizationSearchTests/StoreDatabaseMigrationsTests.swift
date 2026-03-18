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

	// MARK: - Full migration from scratch (v1 → v4)

	@Test("migrate creates stored_organization with all expected columns")
	func migrate_onFreshDatabase_createsTableWithAllColumns() throws {

		// Given
		let queue = try makeInMemoryQueue()

		// When
		try StoreDatabaseMigrations.migrate(queue)

		// Then
		let columns = try columnNames(of: "stored_organization", in: queue)
		#expect(columns.contains("id"))
		#expect(columns.contains("addressLine"))
		#expect(columns.contains("careType"))
		#expect(columns.contains("city"))
		#expect(columns.contains("dataServicesJSON"))
		#expect(columns.contains("name"))
		#expect(columns.contains("geoLat"))
		#expect(columns.contains("geoLng"))
		#expect(columns.contains("postalCode"))
		#expect(columns.contains("medmijId"))
	}

	@Test("migrate is idempotent when called twice")
	func migrate_calledTwice_doesNotThrow() throws {

		// Given
		let queue = try makeInMemoryQueue()
		try StoreDatabaseMigrations.migrate(queue)

		// When / Then — pending-migration check skips already-applied migrations
		try StoreDatabaseMigrations.migrate(queue)
	}

	// MARK: - v3: rename careTypeDisplay → careType and displayName → name

	@Test("v3 renames careTypeDisplay to careType when old column is present")
	func v3_renamesCareTypeDisplayToCareType() throws {

		// Given — simulate a pre-v3 database with the old column names
		let queue = try makeInMemoryQueue()
		try queue.write { db in
			try db.create(table: "stored_organization") { desc in
				desc.primaryKey("id", .text)
				desc.column("addressLine", .text)
				desc.column("careTypeDisplay", .text)  // old name
				desc.column("city", .text)
				desc.column("dataServicesJSON", .text)
				desc.column("displayName", .text)       // old name
				desc.column("geoLat", .double)
				desc.column("geoLng", .double)
				desc.column("postalCode", .text)
			}
			// Mark v1 and v2 as already applied so the migrator only runs v3 onwards
			try db.execute(sql: "CREATE TABLE IF NOT EXISTS grdb_migrations (identifier TEXT NOT NULL PRIMARY KEY)")
			try db.execute(sql: "INSERT INTO grdb_migrations VALUES ('v1_createStoredOrganization')")
			try db.execute(sql: "INSERT INTO grdb_migrations VALUES ('v2_wipeStoredOrganization')")
		}

		// When
		try StoreDatabaseMigrations.migrate(queue)

		// Then — columns are renamed
		let columns = try columnNames(of: "stored_organization", in: queue)
		#expect(columns.contains("careType"))
		#expect(columns.contains("name"))
		#expect(!columns.contains("careTypeDisplay"))
		#expect(!columns.contains("displayName"))
	}

	@Test("v3 is a no-op when columns are already on new names")
	func v3_isNoOp_whenColumnsAlreadyRenamed() throws {

		// Given — simulate a database that already has the new column names
		let queue = try makeInMemoryQueue()
		try queue.write { db in
			try db.create(table: "stored_organization") { desc in
				desc.primaryKey("id", .text)
				desc.column("addressLine", .text)
				desc.column("careType", .text)         // already renamed
				desc.column("city", .text)
				desc.column("dataServicesJSON", .text)
				desc.column("name", .text)             // already renamed
				desc.column("geoLat", .double)
				desc.column("geoLng", .double)
				desc.column("postalCode", .text)
			}
			try db.execute(sql: "CREATE TABLE IF NOT EXISTS grdb_migrations (identifier TEXT NOT NULL PRIMARY KEY)")
			try db.execute(sql: "INSERT INTO grdb_migrations VALUES ('v1_createStoredOrganization')")
			try db.execute(sql: "INSERT INTO grdb_migrations VALUES ('v2_wipeStoredOrganization')")
		}

		// When / Then — must not throw
		try StoreDatabaseMigrations.migrate(queue)

		let columns = try columnNames(of: "stored_organization", in: queue)
		#expect(columns.contains("careType"))
		#expect(columns.contains("name"))
	}

	// MARK: - v4: adds medmijId column

	@Test("v4 adds medmijId column to stored_organization")
	func v4_addsMedmijIdColumn() throws {

		// Given — apply only v1–v3, then run the full migrator to trigger v4
		let queue = try makeInMemoryQueue()
		try queue.write { db in
			try db.create(table: "stored_organization") { desc in
				desc.primaryKey("id", .text)
				desc.column("addressLine", .text)
				desc.column("careType", .text)
				desc.column("city", .text)
				desc.column("dataServicesJSON", .text)
				desc.column("name", .text)
				desc.column("geoLat", .double)
				desc.column("geoLng", .double)
				desc.column("postalCode", .text)
				// medmijId intentionally absent — v4 should add it
			}
			try db.execute(sql: "CREATE TABLE IF NOT EXISTS grdb_migrations (identifier TEXT NOT NULL PRIMARY KEY)")
			try db.execute(sql: "INSERT INTO grdb_migrations VALUES ('v1_createStoredOrganization')")
			try db.execute(sql: "INSERT INTO grdb_migrations VALUES ('v2_wipeStoredOrganization')")
			try db.execute(sql: "INSERT INTO grdb_migrations VALUES ('v3_renameStoredOrganizationColumns')")
		}

		// When
		try StoreDatabaseMigrations.migrate(queue)

		// Then
		let columns = try columnNames(of: "stored_organization", in: queue)
		#expect(columns.contains("medmijId"))
	}
}
