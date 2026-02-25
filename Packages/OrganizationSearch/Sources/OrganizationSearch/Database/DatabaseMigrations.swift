/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB

/// Creates and tears down the SQLite schema used for organization search.
///
/// The schema consists of two tables:
/// - `organization` – the main content table that stores all organization fields.
/// - `organization_fts` – an FTS5 virtual table synchronised with `organization`,
///   indexed on the `searchBlob` column for full-text search.
enum DatabaseMigrations {

	/// Drops the `organization_fts` and `organization` tables if they exist.
	///
	/// Called at the start of `prepare()` to ensure the database starts from a
	/// clean state on every launch (the data is always reloaded from the bundle).
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
				tableDefinition.column("normalizedDisplayName", .text)
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
//				tableDefinition.column("displayName")
				tableDefinition.column("normalizedDisplayName")
//				tableDefinition.column("city")
//				tableDefinition.column("postalCode")
				tableDefinition.column("searchBlob")
			}
		}
	}
}
