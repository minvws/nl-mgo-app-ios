/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Opens and configures the on-disk SQLite database.
enum DatabaseSetup {

	/// The filename used for the on-disk SQLite database.
	static let databaseFileName = "organizations.sqlite"

	/// Opens (or creates) the database in the Application Support directory
	/// and marks it as excluded from iCloud backup.
	///
	/// - Returns: A `DatabaseQueue` ready for use.
	/// - Throws: Errors if the directory cannot be resolved or the database cannot be opened.
	static func openDatabase() throws -> DatabaseQueue {
		let appSupportURL = try FileManager.default.url(
			for: .applicationSupportDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true
		)
		let dbURL = appSupportURL.appendingPathComponent(databaseFileName)
		let dbQueue = try DatabaseQueue(path: dbURL.path)

		// Exclude from iCloud backup now that the file exists on disk
		var mutableURL = dbURL
		var resourceValues = URLResourceValues()
		resourceValues.isExcludedFromBackup = true
		try mutableURL.setResourceValues(resourceValues)

		return dbQueue
	}
}
