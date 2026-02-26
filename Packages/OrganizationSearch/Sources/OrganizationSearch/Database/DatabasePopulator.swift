/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB
import MGODebug

/// Loads organization data from the bundled JSON resource and writes it to the database.
enum DatabasePopulator {

	/// Decodes the bundled JSON for the given dataset into an array of `Organization` values.
	///
	/// - Parameter dataset: Identifies which JSON resource file to load.
	/// - Returns: All organizations decoded from the bundle resource.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the JSON file is
	///   absent from the module bundle; decoding errors if the JSON is malformed.
	static func loadOrganizations(from dataset: OrganizationDataset) throws -> [Organization] {
		guard let jsonURL = Bundle.module.url(forResource: dataset.resourceName, withExtension: "json") else {
			logError("DatabasePopulator: \(dataset.resourceName).json not found in bundle")
			throw OrganizationSearchClientError.resourceNotFound
		}
		let data = try Data(contentsOf: jsonURL)
		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode([Organization].self, from: data)
	}

	/// Inserts all organizations into the database in a single write transaction.
	///
	/// Each organization's `dataServices` dictionary is JSON-encoded to a text
	/// blob stored in the `dataServicesJSON` column, so it can be decoded back
	/// into `[String: DataService]` at search time by `DatabaseSearchResultFactory`.
	///
	/// - Parameters:
	///   - organizations: The organizations to insert.
	///   - dbQueue: The database to write into (accepts both `DatabasePool` and `DatabaseQueue`).
	/// - Throws: GRDB errors if the write transaction fails; encoding errors if
	///   a `dataServices` value cannot be serialised to JSON.
	static func insert(_ organizations: [Organization], into dbQueue: any DatabaseWriter) async throws {
		try await dbQueue.write { db in
			for org in organizations {
				let dataServicesJSON = try org.dataServices
					.map { try newJSONEncoder().encode($0) }
					.flatMap { String(data: $0, encoding: .utf8) }

				try db.execute(
					sql: """
						INSERT INTO organization
							(id, displayName, careTypeDisplay,
							 city, postalCode, addressLine, geoLat, geoLng,
							 searchBlob, dataServicesJSON)
						VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
						""",
					arguments: [
						org.id,
						org.displayName,
						org.careTypeDisplay,
						org.city,
						org.postalCode,
						org.addressLine,
						org.geoLat,
						org.geoLng,
						org.searchBlob,
						dataServicesJSON
					]
				)
			}
		}
	}
}
