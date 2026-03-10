/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Opens and configures the on-disk SQLite database used for organization search.
enum DatabaseSetup {

	/// Opens (or creates) a dataset-specific SQLite database in the Application Support directory.
	///
	/// Each `OrganizationDataset` maps to its own file (e.g. `organizations-full.sqlite`).
	/// Using per-dataset files prevents concurrent `prepare` calls for different datasets
	/// from conflicting on the same file, which is important during parallel test runs.
	///
	/// A `DatabasePool` is used so that concurrent reads can proceed while a
	/// write transaction is in progress (WAL journal mode). This prevents
	/// search queries from stalling during the initial data-population write.
	///
	/// The database file is marked as excluded from iCloud backup immediately
	/// after it is created on disk.
	///
	/// - Parameter dataset: The dataset whose backing file should be opened.
	/// - Returns: A configured `DatabasePool` ready for use.
	/// - Throws: Foundation errors if the Application Support directory cannot
	///   be resolved; GRDB errors if the database file cannot be opened.
	static func openDatabase(for dataset: OrganizationDataset) throws -> DatabasePool {

		let appSupportURL = try FileManager.default.url(
			for: .applicationSupportDirectory,
			in: .userDomainMask,
			appropriateFor: nil,
			create: true
		)
		let dbURL = appSupportURL.appendingPathComponent("\(dataset.resourceName).sqlite")
		let dbPool = try DatabasePool(path: dbURL.path)

		// Exclude from iCloud backup now that the file exists on disk
		var mutableURL = dbURL
		var resourceValues = URLResourceValues()
		resourceValues.isExcludedFromBackup = true
		try mutableURL.setResourceValues(resourceValues)

		return dbPool
	}
}
