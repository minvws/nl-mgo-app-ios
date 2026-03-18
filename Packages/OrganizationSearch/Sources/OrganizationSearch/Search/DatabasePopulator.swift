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

	// MARK: - Loading

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

	/// Returns the raw JSON data for the endpoint lookup table for the given dataset.
	///
	/// - Parameter dataset: Identifies which endpoints JSON resource file to load.
	/// - Returns: Memory-mapped `Data` of the bundled endpoints JSON file.
	/// - Throws: `OrganizationSearchClientError.resourceNotFound` if the endpoints JSON file is
	///   absent from the module bundle; file I/O errors if the file cannot be opened.
	static func loadEndpointsData(for dataset: OrganizationDataset) throws -> Data {
		
		guard let jsonURL = Bundle.module.url(
			forResource: dataset.endpointsResourceName,
			withExtension: "json"
		) else {
			logError("DatabasePopulator: \(dataset.endpointsResourceName).json not found in bundle")
			throw OrganizationSearchClientError.resourceNotFound
		}
		return try Data(contentsOf: jsonURL, options: .mappedIfSafe)
	}

	// MARK: - Hashing

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

	// MARK: - Decoding

	/// Decodes a flat `{id: url}` dictionary from the endpoints JSON data.
	///
	/// - Parameter data: JSON data previously loaded via `loadEndpointsData(for:)`.
	/// - Returns: A dictionary mapping endpoint IDs to their URL strings.
	/// - Throws: Decoding errors if the JSON is malformed.
	static func decodeEndpoints(_ data: Data) throws -> [String: String] {
		
		return try JSONDecoder().decode([String: String].self, from: data)
	}

	/// Decodes an array of `Organization` values from raw JSON data, resolving
	/// endpoint FK IDs using the provided endpoints lookup table.
	///
	/// Each `DataService`'s `authEndpoint`, `tokenEndpoint`, and `resourceEndpoint`
	/// fields in the raw JSON contain FK IDs (e.g. `"1"`, `"2"`). This method
	/// resolves them to full URL strings using `endpoints`. If an ID is not found
	/// the raw value is kept as-is.
	///
	/// - Parameters:
	///   - data: JSON data previously loaded via `loadJSONData(for:)`.
	///   - endpoints: The endpoint lookup table from `decodeEndpoints(_:)`.
	/// - Returns: All organizations decoded from the data with endpoint FKs resolved.
	/// - Throws: Decoding errors if the JSON is malformed.
	static func decode(
		_ data: Data,
		endpoints: [String: String]
	) throws -> [Organization] {
		
		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let raw = try decoder.decode([Organization].self, from: data)
		return raw.map { org in
			guard let services = org.dataServices else { return org }
			let resolved = services.map { service in
				DataService(
					id: service.id,
					authEndpoint: endpoints[service.authEndpoint] ?? service.authEndpoint,
					resourceEndpoint: endpoints[service.resourceEndpoint] ?? service.resourceEndpoint,
					tokenEndpoint: endpoints[service.tokenEndpoint] ?? service.tokenEndpoint
				)
			}
			return Organization(
				address: org.address,
				careType: org.careType,
				dataServices: resolved,
				name: org.name,
				id: org.id,
				searchBlob: org.searchBlob
			)
		}
	}

	// MARK: - Inserting

	/// Inserts endpoint rows into the `endpoint` table in chunks of `insertChunkSize` records.
	///
	/// Each chunk is written in its own transaction so GRDB can release the
	/// WAL journal state between batches, reducing peak memory for large endpoint sets.
	///
	/// - Parameters:
	///   - endpoints: The `{id: url}` dictionary to persist.
	///   - dbQueue: The database to write into.
	/// - Throws: GRDB errors if a write transaction fails.
	static func insertEndpoints(
		_ endpoints: [String: String],
		into dbQueue: any DatabaseWriter
	) async throws {
		
		let pairs = Array(endpoints)
		for chunkStart in stride(from: 0, to: pairs.count, by: insertChunkSize) {
			let chunk = pairs[chunkStart..<min(chunkStart + insertChunkSize, pairs.count)]
			try await dbQueue.write { db in
				for (id, url) in chunk {
					try db.execute(
						sql: "INSERT INTO endpoint (id, url) VALUES (?, ?)",
						arguments: [id, url]
					)
				}
			}
		}
	}

	/// Inserts organizations into the database in chunks of `insertChunkSize` records.
	///
	/// Each chunk is written in its own transaction so GRDB can release the
	/// WAL journal state between batches, reducing peak memory for large datasets.
	///
	/// The following columns are normalized via `normalizeSearchText(_:)` before
	/// storage so the FTS5 index receives clean, consistent text:
	/// `normalizedDisplayName`, `normalizedCity`, and `searchBlob`.
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
					try insertRow(for: org, into: db)
				}
			}
		}
	}

	// MARK: - Normalization

	/// Normalizes a raw search string for consistent FTS5 indexing and querying.
	///
	/// Applied to `displayName` and `city` at insert time so the FTS5 index
	/// receives clean, consistent text.
	///
	/// Replaces all non-letter, non-digit characters with a space (so hyphens,
	/// dots, and parentheses become word boundaries rather than being silently
	/// dropped), then collapses runs of whitespace, trims, and lowercases.
	/// Using `\p{L}` (Unicode letter category) preserves Dutch characters such
	/// as é, ü, and ij.
	///
	/// Returns `nil` when the input is `nil`.
	static func normalizeSearchText(_ text: String?) -> String? {
		
		guard let text else { return nil }
		return text
			.replacingOccurrences(
				of: "[^\\p{L}0-9]",
				with: " ",
				options: .regularExpression
			)
			.replacingOccurrences(
				of: "\\s+",
				with: " ",
				options: .regularExpression
			)
			.trimmingCharacters(in: .whitespaces)
			.lowercased()
	}

	// MARK: - Private

	/// Encodes and inserts a single organization row into the database.
	///
	/// The `dataServices` array is JSON-encoded to a text blob stored in
	/// `dataServicesJSON`, decoded back to `[DataService]` at query time
	/// by `DatabaseSearchResultFactory`.
	///
	/// - Parameters:
	///   - org: The organization to insert.
	///   - db: An open writable GRDB database connection.
	/// - Throws: GRDB errors if the insert fails; encoding errors if `dataServices`
	///   cannot be serialised to JSON.
	private static func insertRow(for org: Organization, into db: Database) throws {
		
		let dataServicesJSON = try org.dataServices
			.map { try newJSONEncoder().encode($0) }
			.flatMap { String(data: $0, encoding: .utf8) }

		try db.execute(
			sql: """
				INSERT INTO organization
					(id, displayName, careTypeDisplay,
					 city, postalCode, addressLine, geoLat, geoLng,
					 searchBlob, dataServicesJSON, normalizedDisplayName,
					 normalizedCity)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
				""",
			arguments: [
				org.id,
				org.name,
				org.careType,
				org.address.city,
				org.address.postalCode,
				org.address.address,
				org.address.geoLat,
				org.address.geoLng,
				normalizeSearchText(org.searchBlob),
				dataServicesJSON,
				normalizeSearchText(org.name),
				normalizeSearchText(org.address.city)
			]
		)
	}
}
