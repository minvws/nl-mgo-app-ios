/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB

/// Creates and manages the database schema (tables and FTS5 index).
enum DatabaseMigrations {

	/// Drops the `organization` and `organization_fts` tables if they exist,
	/// clearing all previously stored data.
	///
	/// - Parameter dbQueue: The database to clear.
	/// - Throws: GRDB errors if the drop fails.
	static func clearSchema(in dbQueue: DatabaseQueue) async throws {
		try await dbQueue.write { db in
			if try db.tableExists("organization_fts") {
				try db.drop(table: "organization_fts")
			}
			if try db.tableExists("organization") {
				try db.drop(table: "organization")
			}
		}
	}

	/// Creates the `organization` table and the `organization_fts` FTS5 virtual
	/// table in the given database.
	///
	/// - Parameter dbQueue: The database to migrate.
	/// - Throws: GRDB errors if table creation fails.
	static func createSchema(in dbQueue: DatabaseQueue) async throws {
		try await dbQueue.write { db in

			// Main organizations table
			try db.create(table: "organization") { t in
				t.primaryKey("id", .text)
				t.column("displayName", .text)
				t.column("normalizedDisplayName", .text)
				t.column("careTypeDisplay", .text)
				t.column("city", .text)
				t.column("postalCode", .text)
				t.column("addressLine", .text)
				t.column("geoLat", .double)
				t.column("geoLng", .double)
				t.column("searchBlob", .text)
				t.column("dataServicesJSON", .text)
			}

			// FTS5 virtual table synchronized with the main table
			try db.create(virtualTable: "organization_fts", using: FTS5()) { t in
				t.synchronize(withTable: "organization")
				t.column("displayName")
				t.column("normalizedDisplayName")
				t.column("city")
				t.column("postalCode")
				t.column("searchBlob")
			}
		}
	}
}
