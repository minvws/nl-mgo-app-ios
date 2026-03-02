/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB
import MGODebug

/// Loads organization data from the bundled JSON resource and writes it to the database.
enum DatabasePopulator {

	/// Number of organizations inserted per SQLite write transaction.
	///
	/// Keeping transactions small reduces the peak memory held by GRDB's WAL
	/// journal during the insert phase: each committed transaction releases its
	/// internal state before the next one starts.
	static let insertChunkSize = 1_000

	/// Decodes the bundled JSON for the given dataset into an array of `Organization` values.
	///
	/// The file is opened with `.mappedIfSafe` so the OS memory-maps it rather
	/// than copying the bytes into RAM. Pages are brought in on demand and can
	/// be evicted under memory pressure once `JSONDecoder` has consumed them.
	///
	/// - Parameter dataset: Identifies which JSON resource file to load.
	/// - Returns: All organizations decoded from the bundle resource.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the JSON file is
	///   absent from the module bundle; decoding errors if the JSON is malformed.
	static func loadOrganizations(
		from dataset: OrganizationDataset
	) throws -> [Organization] {

		guard let jsonURL = Bundle.module.url(
			forResource: dataset.resourceName,
			withExtension: "json"
		) else {
			logError("DatabasePopulator: \(dataset.resourceName).json not found in bundle")
			throw OrganizationSearchClientError.resourceNotFound
		}
		let data = try Data(contentsOf: jsonURL, options: .mappedIfSafe)
		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode([Organization].self, from: data)
	}

	/// Inserts organizations into the database in chunks of `insertChunkSize` records.
	///
	/// Each chunk is written in its own transaction so GRDB can release the
	/// WAL journal state between batches, reducing peak memory for large datasets.
	///
	/// Each organization's `dataServices` dictionary is JSON-encoded to a text
	/// blob stored in the `dataServicesJSON` column, so it can be decoded back
	/// into `[String: DataService]` at search time by `DatabaseSearchResultFactory`.
	///
	/// - Parameters:
	///   - organizations: The organizations to insert.
	///   - dbQueue: The database to write into (accepts both `DatabasePool` and `DatabaseQueue`).
	/// - Throws: GRDB errors if a write transaction fails; encoding errors if
	///   a `dataServices` value cannot be serialised to JSON.
	static func insert(
		_ organizations: [Organization],
		into dbQueue: any DatabaseWriter
	) async throws {

		for chunkStart in stride(from: 0, to: organizations.count, by: insertChunkSize) {
			let chunk = organizations[chunkStart..<min(chunkStart + insertChunkSize, organizations.count)]
			try await dbQueue.write { db in
				for org in chunk {
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
}
