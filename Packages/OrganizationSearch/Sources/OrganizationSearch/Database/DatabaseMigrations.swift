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

	/// Creates the `organization` table and the `organization_fts` FTS5 virtual
	/// table in the given database.
	///
	/// - Parameter dbQueue: The database to migrate.
	/// - Throws: GRDB errors if table creation fails.
	static func createSchema(in dbQueue: any DatabaseWriter) async throws {
		try await dbQueue.write { db in

			// Main organizations table
			try db.create(table: "organization") { tableDefinition in
				tableDefinition.primaryKey("id", .text)
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
//				tableDefinition.column("normalizedDisplayName")
//				tableDefinition.column("city")
//				tableDefinition.column("postalCode")
				tableDefinition.column("searchBlob")
			}
		}
	}
}
