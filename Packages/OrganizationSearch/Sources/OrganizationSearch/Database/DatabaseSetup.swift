/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Opens and configures the on-disk SQLite database used for organization search.
enum DatabaseSetup {

	/// The filename used for the on-disk SQLite database.
	static let databaseFileName = "organizations.sqlite"

	/// Opens (or creates) the SQLite database in the Application Support directory.
	///
	/// A `DatabasePool` is used so that concurrent reads can proceed while a
	/// write transaction is in progress (WAL journal mode). This prevents
	/// search queries from stalling during the initial data-population write.
	///
	/// The database file is marked as excluded from iCloud backup immediately
	/// after it is created on disk.
	///
	/// - Returns: A configured `DatabasePool` ready for use.
	/// - Throws: Foundation errors if the Application Support directory cannot
	///   be resolved; GRDB errors if the database file cannot be opened.
	static func openDatabase() throws -> DatabasePool {
		let appSupportURL = try FileManager.default.url(
			for: .applicationSupportDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true
		)
		let dbURL = appSupportURL.appendingPathComponent(databaseFileName)
		let dbPool = try DatabasePool(path: dbURL.path)

		// Exclude from iCloud backup now that the file exists on disk
		var mutableURL = dbURL
		var resourceValues = URLResourceValues()
		resourceValues.isExcludedFromBackup = true
		try mutableURL.setResourceValues(resourceValues)

		return dbPool
	}
}
