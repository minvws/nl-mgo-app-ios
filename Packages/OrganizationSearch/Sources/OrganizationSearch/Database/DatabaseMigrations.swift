/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB

/// Creates and tears down the SQLite schema used for organization search.
///
/// The schema consists of three tables:
/// - `metadata` – a key/value table that persists across repopulations (e.g. the JSON hash).
/// - `organization` – the main content table that stores all organization fields.
/// - `organization_fts` – an FTS5 virtual table synchronised with `organization`,
///   indexed on the `searchBlob` column for full-text search.
enum DatabaseMigrations {

	// MARK: - Metadata

	/// Creates the `metadata` key/value table if it does not already exist.
	///
	/// The metadata table is intentionally **not** cleared by `clearSchema` so that
	/// the JSON hash survives a schema rebuild and can be compared on the next launch.
	///
	/// - Parameter dbQueue: The database to update.
	/// - Throws: GRDB errors if the table cannot be created.
	static func ensureMetadataTable(in dbQueue: any DatabaseWriter) async throws {
		try await dbQueue.write { db in
			try db.create(table: "metadata", ifNotExists: true) { t in
				t.column("key", .text).primaryKey()
				t.column("value", .text).notNull()
			}
		}
	}

	/// Returns the SHA-256 hex digest stored under `"json_hash"`, or `nil` if absent.
	///
	/// - Parameter dbPool: The database to query.
	/// - Throws: GRDB errors if the read fails.
	static func readHash(in dbPool: DatabasePool) async throws -> String? {
		try await dbPool.read { db in
			try String.fetchOne(db, sql: "SELECT value FROM metadata WHERE key = 'json_hash'")
		}
	}

	/// Upserts the SHA-256 hex digest under `"json_hash"` in the metadata table.
	///
	/// - Parameters:
	///   - hash: The hex digest to store.
	///   - dbQueue: The database to update.
	/// - Throws: GRDB errors if the write fails.
	static func writeHash(_ hash: String, in dbQueue: any DatabaseWriter) async throws {
		try await dbQueue.write { db in
			try db.execute(
				sql: "INSERT OR REPLACE INTO metadata (key, value) VALUES ('json_hash', ?)",
				arguments: [hash]
			)
		}
	}

	// MARK: - Schema

	/// Drops the `organization_fts` and `organization` tables if they exist.
	///
	/// The `metadata` table is intentionally preserved so the stored JSON hash
	/// survives a schema rebuild.
	///
	/// - Parameter dbQueue: The database to clear.
	/// - Throws: GRDB errors if the drop operation fails.
	static func clearSchema(in dbQueue: any DatabaseWriter) async throws {
		try await dbQueue.write { db in
			if try db.tableExists("organization_fts") {
				try db.drop(table: "organization_fts")
			}
			if try db.tableExists("organization") {
				try db.drop(table: "organization")
			}
		}
	}

	/// Creates the `organization` table and the `organization_fts` FTS5 virtual table.
	///
	/// `organization_fts` is kept in sync with `organization` via GRDB's
	/// `synchronize(withTable:)`, which uses FTS5 content tables under the hood.
	/// Only the `searchBlob` column is indexed; the other columns are stored in
	/// the main table and joined at query time.
	///
	/// - Parameter dbQueue: The database to migrate.
	/// - Throws: GRDB errors if table creation fails.
	static func createSchema(in dbQueue: any DatabaseWriter) async throws {
		try await dbQueue.write { db in

			// Main organizations table
			try db.create(table: "organization") { tableDefinition in
				tableDefinition.primaryKey("id", .text).indexed()
				tableDefinition.column("displayName", .text)
				tableDefinition.column("careTypeDisplay", .text)
				tableDefinition.column("city", .text)
				tableDefinition.column("postalCode", .text)
				tableDefinition.column("addressLine", .text)
				tableDefinition.column("geoLat", .double)
				tableDefinition.column("geoLng", .double)
				tableDefinition.column("searchBlob", .text)
				tableDefinition.column("dataServicesJSON", .text)
			}

			// FTS5 virtual table synchronized with the main table
			try db.create(virtualTable: "organization_fts", using: FTS5()) { tableDefinition in
				tableDefinition.synchronize(withTable: "organization")
				tableDefinition.column("searchBlob") // search via searchBlob only
			}
		}
	}
}
