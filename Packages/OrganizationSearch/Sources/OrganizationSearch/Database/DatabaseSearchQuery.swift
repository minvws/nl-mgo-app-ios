/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Executes full-text search queries against the `organization_fts` FTS5 table.
enum DatabaseSearchQuery {

	/// Returns all organizations whose FTS5 index matches the given query string.
	///
	/// Each word in `searchTerm` is suffixed with `*` to enable prefix matching
	/// (e.g. `"tan"` matches `"tandarts"`). Multi-word queries are ANDed together
	/// by FTS5 by default.
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
	///   Returns an empty array when `searchTerm` is blank or whitespace-only.
	/// - Throws: GRDB errors if the SQL query fails.
	static func fetch(matching searchTerm: String, in db: Database) throws -> [Row] {
		let trimmed = searchTerm.trimmingCharacters(in: .whitespaces)
		guard !trimmed.isEmpty else { return [] }

		// Strip characters that FTS5 treats as query syntax (e.g. "." in "J.S.")
		// so that only clean alphanumeric tokens are passed to the engine.
		let allowed = CharacterSet.alphanumerics.union(.whitespaces)
		let sanitised = trimmed
			.unicodeScalars
			.filter { allowed.contains($0) }
			.reduce(into: "") { $0.append(Character($1)) }

		let query = sanitised
			.split(separator: " ")
			.map { "\($0)*" }
			.joined(separator: " ")

		guard !query.isEmpty else { return [] }
		
		let pattern = FTS5Pattern(matchingAnyTokenIn: query)
		

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
			arguments: [query]
		)
	}
}
