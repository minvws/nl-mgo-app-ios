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
	/// `[DataService]` array using snake_case key conversion.
	///
	/// - Parameter row: A row returned by `DatabaseSearchQuery.fetch(matching:in:)`.
	/// - Returns: A fully populated `SearchResult`.
	/// - Throws: Decoding errors if `dataServicesJSON` is present but malformed.
	static func makeSearchResult(from row: Row) throws -> SearchResult {

		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase

		let dataServices: [DataService]? = try (row["dataServicesJSON"] as String?)
			.flatMap { try decoder.decode([DataService].self, from: Data($0.utf8)) }

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
