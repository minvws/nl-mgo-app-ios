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

	/// Returns organizations JSON data for the given dataset.
	///
	/// Routes to the downloader when `dataset.requiresAPIDownload` is `true` and a
	/// downloader is provided; otherwise loads the bundled resource file.
	///
	/// - Parameters:
	///   - dataset: Identifies the dataset to load.
	///   - downloader: The API downloader, or `nil` for bundle-only use.
	///   - db: The database pool used by the downloader to read/write ETags.
	/// - Returns: Raw JSON data for the organizations dataset.
	static func loadOrganizationsData(
		for dataset: OrganizationDataset,
		downloader: OrganizationDatasetDownloader?,
		db: DatabasePool
	) async throws -> Data? {

		if dataset.requiresAPIDownload, let downloader {
			return try await downloader.fetchOrganizationsData(db: db)
		}

		guard let jsonURL = Bundle.module.url(
			forResource: dataset.resourceName,
			withExtension: "json"
		) else {
			logError("DatabasePopulator: \(dataset.resourceName).json not found in bundle")
			throw OrganizationSearchClientError.resourceNotFound
		}
		return try Data(contentsOf: jsonURL, options: .mappedIfSafe)
	}

	/// Returns endpoints JSON data for the given dataset.
	///
	/// Routes to the downloader when `dataset.requiresAPIDownload` is `true` and a
	/// downloader is provided; otherwise loads the bundled resource file.
	///
	/// - Parameters:
	///   - dataset: Identifies the dataset to load.
	///   - downloader: The API downloader, or `nil` for bundle-only use.
	///   - db: The database pool used by the downloader to read/write ETags.
	/// - Returns: Raw JSON data for the endpoints dataset.
	static func loadEndpointsData(
		for dataset: OrganizationDataset,
		downloader: OrganizationDatasetDownloader?,
		db: DatabasePool
	) async throws -> Data? {

		if dataset.requiresAPIDownload, let downloader {
			return try await downloader.fetchEndpointsData(db: db)
		}

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

	/// Decodes an array of `Organization` values from raw JSON data.
	///
	/// Each `DataService`'s `authEndpoint`, `tokenEndpoint`, and `resourceEndpoint`
	/// fields in the raw JSON contain FK IDs (e.g. `"1"`, `"2"`). These are stored
	/// as-is and resolved to full URL strings at query time by
	/// `DatabaseSearchResultFactory` using the `endpoint` table.
	///
	/// - Parameter data: JSON data previously loaded via `loadOrganizationsData(for:)`.
	/// - Returns: All organizations decoded from the data.
	/// - Throws: Decoding errors if the JSON is malformed.
	static func decode(_ data: Data) throws -> [Organization] {

		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		return try decoder.decode([Organization].self, from: data)
	}

	// MARK: - Inserting

	/// Inserts all endpoint rows into the `endpoint` table in a single transaction.
	///
	/// The endpoint table is a small lookup table (a few hundred rows), so a single
	/// transaction is sufficient — unlike the organizations insert which chunks at
	/// `insertChunkSize` to manage WAL journal pressure for large datasets.
	///
	/// - Parameters:
	///   - endpoints: The `{id: url}` dictionary to persist.
	///   - dbQueue: The database to write into.
	/// - Throws: GRDB errors if the write transaction fails.
	static func insertEndpoints(
		_ endpoints: [String: String],
		into dbQueue: any DatabaseWriter
	) async throws {

		try await dbQueue.write { db in
			for (id, url) in endpoints {
				try db.execute(
					sql: "INSERT INTO endpoint (id, url) VALUES (?, ?)",
					arguments: [id, url]
				)
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
	/// `normalizedName`, `normalizedCity`, and `searchBlob`.
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

		let encoder = newJSONEncoder()
		for chunkStart in stride(from: 0, to: organizations.count, by: insertChunkSize) {
			let chunk = organizations[chunkStart..<min(chunkStart + insertChunkSize, organizations.count)]
			try await dbQueue.write { db in
				for org in chunk {
					try insertRow(for: org, encoder: encoder, into: db)
				}
			}
		}
	}

	// MARK: - Normalization

	/// Normalizes a raw search string for consistent FTS5 indexing and querying.
	///
	/// Applied to `name` and `city` at insert time so the FTS5 index
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
	/// `dataServicesJSON`. Endpoint FK IDs (e.g. `"1"`, `"2"`) are kept as-is
	/// and resolved to full URL strings at query time by `DatabaseSearchResultFactory`
	/// using the `endpoint` table.
	///
	/// - Parameters:
	///   - org: The organization to insert.
	///   - encoder: A shared `JSONEncoder` used to serialise `dataServices`.
	///   - db: An open writable GRDB database connection.
	/// - Throws: GRDB errors if the insert fails; encoding errors if `dataServices`
	///   cannot be serialised to JSON.
	private static func insertRow(for org: Organization, encoder: JSONEncoder, into db: Database) throws {

		let dataServicesJSON = try org.dataServices
			.map { try encoder.encode($0) }
			.flatMap { String(data: $0, encoding: .utf8) }

		try db.execute(
			sql: """
				INSERT INTO organization
					(id, medmijId, name, careType,
					 city, postalCode, address, geoLat, geoLng,
					 searchBlob, dataServicesJSON, normalizedName,
					 normalizedCity)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
				""",
			arguments: [
				org.id,
				org.medmijId,
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
