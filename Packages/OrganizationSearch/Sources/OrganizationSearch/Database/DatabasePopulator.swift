/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import CryptoKit
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

	/// Returns the memory-mapped raw JSON data for the given dataset.
	///
	/// The file is opened with `.mappedIfSafe` so the OS pages bytes in on demand
	/// rather than copying the full file into RAM.
	///
	/// - Parameter dataset: Identifies which JSON resource file to load.
	/// - Returns: Memory-mapped `Data` of the bundled JSON file.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the JSON file is
	///   absent from the module bundle; file I/O errors if the file cannot be opened.
	static func loadJSONData(for dataset: OrganizationDataset) throws -> Data {
		guard let jsonURL = Bundle.module.url(
			forResource: dataset.resourceName,
			withExtension: "json"
		) else {
			logError("DatabasePopulator: \(dataset.resourceName).json not found in bundle")
			throw OrganizationSearchClientError.resourceNotFound
		}
		return try Data(contentsOf: jsonURL, options: .mappedIfSafe)
	}

	/// Returns the SHA-256 hex digest of `data`.
	///
	/// Used to detect whether the bundled JSON has changed since the last populate,
	/// so that the database can be skipped when the data is already up to date.
	///
	/// - Parameter data: The raw bytes to hash (typically the mmap'd JSON file).
	/// - Returns: A lowercase hex string of the SHA-256 digest.
	static func computeHash(of data: Data) -> String {
		SHA256.hash(data: data).map { String(format: "%02x", $0) }.joined()
	}

	/// Decodes an array of `Organization` values from raw JSON data.
	///
	/// - Parameter data: JSON data previously loaded via `loadJSONData(for:)`.
	/// - Returns: All organizations decoded from the data.
	/// - Throws: Decoding errors if the JSON is malformed.
	static func decode(_ data: Data) throws -> [Organization] {
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
