/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB

/// Creates and runs migrations for the stored healthcare organization SQLite schema.
///
/// The schema consists of a single `stored_organization` table that persists the
/// user's list of selected healthcare organizations. `dataServices` is stored as
/// a JSON text blob, matching the encoding pattern used in `DatabasePopulator`.
enum StoreDatabaseMigrations {

	/// Applies all pending migrations to the given database.
	///
	/// - Parameter dbQueue: The database to migrate.
	/// - Throws: GRDB errors if the migration fails.
	static func migrate(_ dbQueue: DatabaseQueue) throws {
		
		var migrator = DatabaseMigrator()
		migrator.registerMigration("v1_createStoredOrganization") { db in
			try db.create(table: "stored_organization", ifNotExists: true) { tableDefinition in
				tableDefinition.primaryKey("id", .text)
				tableDefinition.column("addressLine", .text)
				tableDefinition.column("careType", .text)
				tableDefinition.column("city", .text)
				tableDefinition.column("dataServicesJSON", .text)
				tableDefinition.column("name", .text)
				tableDefinition.column("geoLat", .double)
				tableDefinition.column("geoLng", .double)
				tableDefinition.column("postalCode", .text)
			}
		}
		
		// Wipe and recreate stored_organization with the final schema:
		// - dataServicesJSON now stores a [DataService] array instead of [String: DataService]
		// - columns use their final names (address, careType, name)
		// - medmijId column added
		migrator.registerMigration("v2_rebuildStoredOrganization") { db in
			try db.drop(table: "stored_organization")
			try db.create(table: "stored_organization") { tableDefinition in
				tableDefinition.primaryKey("id", .text)
				tableDefinition.column("address", .text)
				tableDefinition.column("careType", .text)
				tableDefinition.column("city", .text)
				tableDefinition.column("dataServicesJSON", .text)
				tableDefinition.column("medmijId", .text)
				tableDefinition.column("name", .text)
				tableDefinition.column("geoLat", .double)
				tableDefinition.column("geoLng", .double)
				tableDefinition.column("postalCode", .text)
			}
		}
		
		try migrator.migrate(dbQueue)
	}
}
