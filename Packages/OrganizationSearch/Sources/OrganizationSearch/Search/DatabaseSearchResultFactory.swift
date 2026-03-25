/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Converts raw GRDB `Row` values from `DatabaseSearchQuery` into typed model objects.
enum DatabaseSearchResultFactory {

	/// Decodes a single GRDB `Row` into a `SearchResult`, resolving endpoint FK IDs.
	///
	/// Expects the row to contain all columns from the `organization` table plus a
	/// `score` column (the negated FTS5 `rank`) produced by `DatabaseSearchQuery`.
	/// The `dataServicesJSON` text column, if present, is decoded back into a
	/// `[DataService]` array using snake_case key conversion. Each service's
	/// `authEndpoint`, `tokenEndpoint`, and `resourceEndpoint` FK IDs are then
	/// resolved to full URL strings using the provided `endpoints` lookup table.
	///
	/// - Parameters:
	///   - row: A row returned by `DatabaseSearchQuery.fetch(matching:in:)`.
	///   - decoder: A shared `JSONDecoder` configured with snake_case key conversion.
	///   - endpoints: A dictionary mapping endpoint IDs to their URL strings.
	/// - Returns: A fully populated `SearchResult` with resolved endpoint URLs.
	/// - Throws: Decoding errors if `dataServicesJSON` is present but malformed.
	static func makeSearchResult(from row: Row, decoder: JSONDecoder, endpoints: [String: String]) throws -> SearchResult {

		let rawServices: [DataService]? = try (row["dataServicesJSON"] as String?)
			.flatMap { try decoder.decode([DataService].self, from: Data($0.utf8)) }

		let dataServices = rawServices.map { services in
			services.map { service in
				DataService(
					id: service.id,
					authEndpoint: endpoints[service.authEndpoint] ?? service.authEndpoint,
					resourceEndpoint: endpoints[service.resourceEndpoint] ?? service.resourceEndpoint,
					tokenEndpoint: endpoints[service.tokenEndpoint] ?? service.tokenEndpoint
				)
			}
		}

		let org = Organization(
			address: OrganizationAddress(
				address: row["address"],
				city: row["city"],
				geoLat: row["geoLat"],
				geoLng: row["geoLng"],
				postalCode: row["postalCode"]
			),
			careType: row["careType"],
			dataServices: dataServices,
			id: row["id"],
			medmijId: row["medmijId"],
			name: row["name"]
		)
		return SearchResult(document: org, id: org.id, score: row["score"] ?? 0)
	}

	/// Decodes an array of GRDB `Row` values into a `SearchResults` value,
	/// resolving endpoint FK IDs from the `endpoint` table in `db`.
	///
	/// - Parameters:
	///   - rows: The rows returned by the FTS5 search query.
	///   - db: An open read-only GRDB database connection used to fetch the endpoint lookup table.
	/// - Returns: A `SearchResults` containing all decoded hits with resolved endpoint URLs.
	/// - Throws: Decoding errors from `makeSearchResult(from:decoder:endpoints:)`;
	///   GRDB errors if the endpoint table cannot be read.
	static func makeSearchResults(from rows: [Row], in db: Database) throws -> SearchResults {

		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase
		let endpoints = try fetchEndpoints(from: db)
		let hits = try rows.map { try makeSearchResult(from: $0, decoder: decoder, endpoints: endpoints) }
		return SearchResults(count: hits.count, hits: hits)
	}

	// MARK: - Private

	/// Fetches all rows from the `endpoint` table and returns them as an `[id: url]` dictionary.
	private static func fetchEndpoints(from db: Database) throws -> [String: String] {

		let rows = try Row.fetchAll(db, sql: "SELECT id, url FROM endpoint")
		return Dictionary(uniqueKeysWithValues: rows.map { ($0["id"] as String, $0["url"] as String) })
	}
}
