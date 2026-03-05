/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Converts raw GRDB `Row` values from `DatabaseSearchQuery` into typed model objects.
enum DatabaseSearchResultFactory {

	/// Decodes a single GRDB `Row` into a `SearchResult`.
	///
	/// Expects the row to contain all columns from the `organization` table plus a
	/// `score` column (the negated FTS5 `rank`) produced by `DatabaseSearchQuery`.
	/// The `dataServicesJSON` text column, if present, is decoded back into a
	/// `[String: DataService]` dictionary using snake_case key conversion.
	///
	/// - Parameter row: A row returned by `DatabaseSearchQuery.fetch(matching:in:)`.
	/// - Returns: A fully populated `SearchResult`.
	/// - Throws: Decoding errors if `dataServicesJSON` is present but malformed.
	static func makeSearchResult(from row: Row) throws -> SearchResult {
		
		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase

		let dataServices: [String: DataService]? = try (row["dataServicesJSON"] as String?)
			.flatMap { try decoder.decode([String: DataService].self, from: Data($0.utf8)) }

		let org = Organization(
			addressLine: row["addressLine"],
			careTypeDisplay: row["careTypeDisplay"],
			city: row["city"],
			dataServices: dataServices,
			displayName: row["displayName"],
			geoLat: row["geoLat"],
			geoLng: row["geoLng"],
			id: row["id"],
			postalCode: row["postalCode"],
			searchBlob: nil
		)
		return SearchResult(document: org, id: org.id, score: row["score"] ?? 0)
	}

	/// Decodes an array of GRDB `Row` values into a `SearchResults` value.
	///
	/// - Parameter rows: The rows returned by the FTS5 search query.
	/// - Returns: A `SearchResults` containing all decoded hits.
	/// - Throws: Decoding errors from `makeSearchResult(from:)`.
	static func makeSearchResults(from rows: [Row]) throws -> SearchResults {
		
		let hits = try rows.map { try makeSearchResult(from: $0) }
		return SearchResults(count: Double(hits.count), hits: hits)
	}
}
