/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Decodes GRDB `Row` values into `SearchResult` and `SearchResults` model types.
enum DatabaseSearchResultFactory {

	/// Decodes a single GRDB `Row` into a `SearchResult`.
	///
	/// Expects the row to contain all `organization` columns plus a `score` column
	/// (the negated FTS5 `rank`) and an optional `dataServicesJSON` text column.
	///
	/// - Parameter row: A row returned by the FTS5 search query.
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
			normalizedDisplayName: row["normalizedDisplayName"],
			postalCode: row["postalCode"],
			searchBlob: row["searchBlob"]
		)
		return SearchResult(document: org, id: org.id, score: row["score"] ?? 0)
	}

	/// Decodes an array of GRDB `Row` values into a `SearchResults` value.
	///
	/// - Parameters:
	///   - rows: The rows returned by the FTS5 search query (may be a limited page).
	///   - totalCount: The true total number of matching organizations, used to
	///     populate `SearchResults.count` independently of how many rows were fetched.
	/// - Returns: A `SearchResults` whose `count` reflects the total matches and
	///   whose `hits` contains the decoded rows.
	/// - Throws: Decoding errors from `makeSearchResult(from:)`.
	static func makeSearchResults(from rows: [Row], totalCount: Int) throws -> SearchResults {
		let hits = try rows.map { try makeSearchResult(from: $0) }
		return SearchResults(count: Double(totalCount), hits: hits)
	}
}
