/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB

/// Executes full-text search queries against the `organization_fts` FTS5 table.
enum DatabaseSearchQuery {

	/// Returns all organizations whose FTS5 index matches the given query string.
	///
	/// Uses `FTS5Pattern(matchingAllPrefixesIn:)` to build a safe, prefix-matched
	/// query from the raw input — e.g. `"tan art"` matches any document containing
	/// a word starting with `"tan"` AND a word starting with `"art"`. GRDB handles
	/// tokenisation and escaping, so punctuation in the input (e.g. `"J.S."`) is
	/// handled correctly without manual sanitisation.
	///
	/// Results are fetched by joining `organization_fts` back to the `organization`
	/// content table on `rowid`, so all stored columns are available in the returned
	/// rows. A `score` column (negated FTS5 `rank`; higher value = more relevant)
	/// is included so callers can display or sort by relevance.
	///
	/// - Parameters:
	///   - searchTerm: The raw user-entered query string.
	///   - db: An open GRDB database connection.
	/// - Returns: All matching rows ordered by descending relevance, each containing
	///   all `organization` columns plus a `score` column.
	///   Returns an empty array when `searchTerm` produces no valid FTS5 tokens.
	/// - Throws: GRDB errors if the SQL query fails.
	static func fetch(matching searchTerm: String, in db: Database) throws -> [Row] {
		guard let pattern = FTS5Pattern(matchingAllPrefixesIn: searchTerm) else {
			return []
		}

		return try Row.fetchAll(
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
				""",
			arguments: [pattern]
		)
	}
}
