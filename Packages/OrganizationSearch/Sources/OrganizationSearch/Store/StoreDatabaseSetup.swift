/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Opens and configures the on-disk SQLite database used for the stored healthcare organization list.
enum StoreDatabaseSetup {

	/// Opens (or creates) the repository SQLite file in the Application Support directory.
	///
	/// A `DatabaseQueue` is used because the stored list is small and serial
	/// access is sufficient — no concurrent reads are needed.
	///
	/// WAL journal mode is enabled so that reads and writes don't block each
	/// other unnecessarily. The database file is marked as excluded from
	/// iCloud backup.
	///
	/// - Returns: A configured `DatabaseQueue` ready for use.
	/// - Throws: Foundation errors if the Application Support directory cannot
	///   be resolved; GRDB errors if the database file cannot be opened.
	static func openDatabase() throws -> DatabaseQueue {
		var url = try FileManager.default
			.url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
			.appendingPathComponent(fileName)
		var config = Configuration()
		config.label = "HealthcareOrganizationRepository"
		config.prepareDatabase { db in
			try db.execute(sql: "PRAGMA journal_mode=WAL")
		}
		let queue = try DatabaseQueue(path: url.path, configuration: config)
		var resourceValues = URLResourceValues()
		resourceValues.isExcludedFromBackup = true
		try? url.setResourceValues(resourceValues) // non-fatal if this fails
		return queue
	}

	/// The SQLite file name for the current runtime context.
	///
	/// Returns a dedicated test file name when `XCTestCase` is present in the
	/// Objective-C runtime — i.e. when the app is running inside an XCTest bundle.
	/// This prevents tests from reading or polluting the real user's stored data.
	private static var fileName: String {
		NSClassFromString("XCTestCase") == nil
			? "mgo_hco_v3.sqlite"
			: "mgo_hco_test_v3.sqlite"
	}
}
