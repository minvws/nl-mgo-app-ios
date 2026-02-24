/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB
import MGODebug

/// Loads organizations from the bundled JSON and inserts them into the database.
enum DatabasePopulator {

	/// Decodes the bundled `organizations.json` into an array of `Organization` values.
	///
	/// - Returns: All organizations from the JSON resource.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the file is missing,
	///   or decoding errors if the JSON is malformed.
	static func loadOrganizations() throws -> [Organization] {
		guard let jsonURL = Bundle.module.url(forResource: "organizations", withExtension: "json") else {
			logError("DatabasePopulator: organizations.json not found in bundle")
			throw OrganizationSearchClientError.resourceNotFound
		}
		let data = try Data(contentsOf: jsonURL)
		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode([Organization].self, from: data)
	}

	/// Inserts all organizations into the database in a single write transaction.
	///
	/// - Parameters:
	///   - organizations: The organizations to insert.
	///   - dbQueue: The database to write into.
	/// - Throws: GRDB errors if insertion fails.
	static func insert(_ organizations: [Organization], into dbQueue: any DatabaseWriter) async throws {
		try await dbQueue.write { db in
			for org in organizations {
				let dataServicesJSON = try org.dataServices
					.map { try newJSONEncoder().encode($0) }
					.flatMap { String(data: $0, encoding: .utf8) }

				try db.execute(
					sql: """
						INSERT INTO organization
							(id, displayName, normalizedDisplayName, careTypeDisplay,
							 city, postalCode, addressLine, geoLat, geoLng,
							 searchBlob, dataServicesJSON)
						VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
						""",
					arguments: [
						org.id,
						org.displayName,
						org.normalizedDisplayName,
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
