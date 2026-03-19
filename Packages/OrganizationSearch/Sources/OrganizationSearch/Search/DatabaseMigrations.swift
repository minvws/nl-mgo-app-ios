/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB

/// Creates and tears down the SQLite schema used for organization search.
///
/// The schema consists of three tables:
/// - `metadata` – a key/value table that persists across repopulations (e.g. the JSON hash).
/// - `organization` – the main content table storing all organization fields, plus
///   pre-normalized columns (`normalizedName`, `normalizedCity`) used
///   as dedicated FTS5 index targets.
/// - `organization_fts` – an FTS5 virtual table synchronised with `organization` via
///   content-table triggers. Three columns are indexed with descending BM25 weights:
///   `normalizedName` (25), `normalizedCity` (5), `searchBlob` (1).
///   The Porter stemmer (wrapping unicode61) is used as the tokenizer.
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
			try db.create(table: "metadata", ifNotExists: true) { tableDefinition in
				tableDefinition.column("key", .text).primaryKey()
				tableDefinition.column("value", .text).notNull()
			}
		}
	}

	/// Returns the effective hash stored under `"json_hash"`, or `nil` if absent.
	///
	/// - Parameter dbPool: The database to query.
	/// - Throws: GRDB errors if the read fails.
	static func readHash(in dbPool: DatabasePool) async throws -> String? {
		try await dbPool.read { db in
			try String.fetchOne(db, sql: "SELECT value FROM metadata WHERE key = 'json_hash'")
		}
	}

	/// Upserts the effective hash under `"json_hash"` in the metadata table.
	///
	/// - Parameters:
	///   - hash: The hash to store (SHA-256 of JSON + schema version suffix).
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
			if try db.tableExists("endpoint") {
				try db.drop(table: "endpoint")
			}
		}
	}

	/// A version token that must change whenever the FTS5 schema or normalization logic changes
	/// (e.g. a different tokenizer, new indexed columns, or updated normalization).
	///
	/// `DatabaseActor` appends this to the JSON hash before storing it, so a
	/// schema change forces a full repopulate even when the bundled JSON file
	/// itself is unchanged.
	static let schemaVersion = "v2"

	/// Creates the `organization` content table and the `organization_fts` FTS5 virtual table.
	///
	/// ## `organization` table
	/// Stores all organization fields. In addition to the raw JSON fields, two
	/// pre-normalized columns are populated at insert time via `DatabasePopulator`:
	/// - `normalizedName` — lowercased, punctuation-stripped name.
	/// - `normalizedCity` — lowercased, punctuation-stripped city.
	///
	/// ## `organization_fts` virtual table
	/// An FTS5 content table synchronised with `organization` via triggers.
	/// Three columns are indexed with BM25 weights applied at query time:
	///
	/// | Column           | Weight | Rationale                                     |
	/// |------------------|--------|-----------------------------------------------|
	/// | `normalizedName` |     25 | Primary search target; name matches dominate  |
	/// | `normalizedCity` |      5 | Key disambiguator for same-name organizations |
	/// | `searchBlob`     |      1 | Supplementary text for broader coverage       |
	///
	/// The Porter stemmer (wrapping unicode61) is used as the tokenizer so that
	/// morphological variants map to the same stem.
	///
	/// - Parameter dbQueue: The database to migrate.
	/// - Throws: GRDB errors if table creation fails.
	static func createSchema(in dbQueue: any DatabaseWriter) async throws {
		try await dbQueue.write { db in
			try createEndpointTable(in: db)
			try createOrganizationTable(in: db)
			try createOrganizationFTSTable(in: db)
		}
	}

	// MARK: - Private

	private static func createEndpointTable(in db: Database) throws {
		try db.create(table: "endpoint") { tableDefinition in
			tableDefinition.primaryKey("id", .text)
			tableDefinition.column("url", .text).notNull()
		}
	}

	private static func createOrganizationTable(in db: Database) throws {
		try db.create(table: "organization") { tableDefinition in
			tableDefinition.primaryKey("id", .text).indexed()
			tableDefinition.column("medmijId", .text)
			tableDefinition.column("name", .text)
			tableDefinition.column("careType", .text)
			tableDefinition.column("city", .text)
			tableDefinition.column("postalCode", .text)
			tableDefinition.column("address", .text)
			tableDefinition.column("geoLat", .double)
			tableDefinition.column("geoLng", .double)
			tableDefinition.column("searchBlob", .text)
			tableDefinition.column("dataServicesJSON", .text)
			tableDefinition.column("normalizedName", .text)
			tableDefinition.column("normalizedCity", .text)
		}
	}

	private static func createOrganizationFTSTable(in db: Database) throws {
		try db.create(virtualTable: "organization_fts", using: FTS5()) { tableDefinition in
			tableDefinition.synchronize(withTable: "organization")
			tableDefinition.tokenizer = .porter(wrapping: .unicode61())
			tableDefinition.column("normalizedName") // weight 25 — name
			tableDefinition.column("normalizedCity") // weight  5 — city
			tableDefinition.column("searchBlob")     // weight  1 — searchblob
		}
	}
}
