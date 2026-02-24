/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB

/// Executes full-text search queries against the `organization_fts` table.
enum DatabaseSearchQuery {

	/// The maximum number of results returned by `fetch(matching:in:limit:)`.
	static let defaultLimit = 100

	/// Searches for organizations whose indexed fields match the given FTS5 query string.
	///
	/// Each word in `searchTerm` is automatically suffixed with `*` so that partial
	/// words match (e.g. "tan" matches "tandarts").
	///
	/// Only the top `limit` rows (by FTS5 relevance rank) are returned, but the
	/// returned `totalCount` reflects the full number of matching organizations so
	/// callers can show an accurate "X results" label.
	///
	/// - Parameters:
	///   - searchTerm: The raw user-entered search string.
	///   - db: An open GRDB database connection.
	///   - limit: Maximum number of rows to return (default: `defaultLimit`).
	/// - Returns: A tuple of the matching rows and the total match count.
	///   Both are empty/zero when `searchTerm` is blank.
	/// - Throws: GRDB errors if the query fails.
	static func fetch(
		matching searchTerm: String,
		in db: Database,
		limit: Int = defaultLimit
	) throws -> (rows: [Row], totalCount: Int) {
		let trimmed = searchTerm.trimmingCharacters(in: .whitespaces)
		guard !trimmed.isEmpty else { return ([], 0) }

		let query = trimmed
			.split(separator: " ")
			.map { "\($0)*" }
			.joined(separator: " ")

		let totalCount = try Int.fetchOne(
			db,
			sql: """
				SELECT COUNT(*)
				FROM organization_fts
				WHERE organization_fts MATCH ?
				""",
			arguments: [query]
		) ?? 0

		let rows = try Row.fetchAll(
			db,
			sql: """
				SELECT o.id, o.displayName, o.normalizedDisplayName, o.careTypeDisplay,
				       o.city, o.postalCode, o.addressLine, o.geoLat, o.geoLng,
				       o.searchBlob, o.dataServicesJSON,
				       -organization_fts.rank AS score
				FROM organization_fts
				JOIN organization o ON o.rowid = organization_fts.rowid
				WHERE organization_fts MATCH ?
				ORDER BY organization_fts.rank
				LIMIT ?
				""",
			arguments: [query, limit]
		)

		return (rows, totalCount)
	}
}
