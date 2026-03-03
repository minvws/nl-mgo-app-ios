/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GRDB

/// Executes full-text search queries against the `organization_fts` FTS5 table.
enum DatabaseSearchQuery {
	
	// MARK: - Public
	
	/// Returns all organizations whose FTS5 index matches the given query string.
	///
	/// Uses a two-pass strategy:
	///
	/// 1. **Prefix pass** — `FTS5Pattern(matchingAllPrefixesIn:)` requires every
	///    typed word to be present in the document (AND + prefix semantics).
	///    This is the fast path for correctly-spelled queries.
	///
	/// 2. **Fuzzy pass** — if the prefix pass returns no rows, each token is
	///    expanded to every string within edit distance 1 (single deletion,
	///    substitution, insertion, or transposition of a–z characters). An FTS5
	///    OR group is built for each token, e.g. `"hiusman"` produces
	///    `(hiusman* OR huisman* OR iisman* OR ...)` which matches "Huisman"
	///    because the transposition `hi→hu` is within ED1.
	///
	/// - Parameters:
	///   - searchTerm: The raw user-entered query string.
	///   - db: An open GRDB database connection.
	/// - Returns: All matching rows ordered by descending relevance, each containing
	///   all `organization` columns plus a `score` column.
	///   Returns an empty array when `searchTerm` produces no valid FTS5 tokens.
	/// - Throws: GRDB errors if the SQL query fails.
	static func fetch(
		matching searchTerm: String,
		in db: Database
	) throws -> [Row] {
		
		// Pass 1: fast path — all typed words must appear (AND + prefix).
		if let pattern = FTS5Pattern(matchingAllPrefixesIn: searchTerm) {
			let rows = try fetchRows(matching: pattern, in: db)
			if !rows.isEmpty { return rows }
		}
		
		// Pass 2: fuzzy fallback — expand each token to its ED1 neighbourhood.
		if let pattern = try ed1Pattern(for: searchTerm, db: db) {
			return try fetchRows(matching: pattern, in: db)
		}
		
		return []
	}
	
	// MARK: - Private
	
	/// Executes a pre-built FTS5 pattern against the `organization_fts` table.
	private static func fetchRows(matching pattern: FTS5Pattern, in db: Database) throws -> [Row] {

		try Row.fetchAll(
			db,
			sql: """
				SELECT o.*,
					   -bm25(organization_fts, 10.0, 5.0, 1.0, 5.0) AS score
				FROM organization_fts
				JOIN organization o ON o.rowid = organization_fts.rowid
				WHERE organization_fts MATCH ?
				ORDER BY bm25(organization_fts, 10.0, 5.0, 1.0, 5.0)
				""",
			arguments: [pattern]
		)
	}
	
	/// Builds a raw FTS5 pattern where every token in `searchTerm` is expanded
	/// to an OR group containing the original term plus all strings within
	/// edit distance 1.
	///
	/// Returns `nil` when `searchTerm` yields no tokens, or when the generated
	/// pattern string is not valid FTS5 syntax (should not happen for a–z input).
	private static func ed1Pattern(
		for searchTerm: String,
		db: Database
	) throws -> FTS5Pattern? {
		
		// Tokenise with the same tokenizer the FTS5 table uses so that
		// case-folding and punctuation handling are consistent.
		let tokens = try db.makeTokenizer(.unicode61())
			.tokenize(query: searchTerm)
			.filter { !$0.flags.contains(.colocated) }
			.map { $0.token }
		
		guard !tokens.isEmpty else { return nil }
		
		// Build one OR group per token.
		let groups: [String] = tokens.map { token in
			guard token.count >= 4 else {
				// Short tokens are unlikely to be misspelled; just prefix-match.
				return "\(token)*"
			}
			let terms = ([token] + token.editDistance1Variants())
				.map { "\($0)*" }
				.joined(separator: " OR ")
			// Parentheses are not supported in FTS5 MATCH; return a flat OR list.
			return terms
		}
		
		// Join groups with explicit AND to avoid relying on parentheses.
		return try? FTS5Pattern(rawPattern: groups.joined(separator: " AND "))
	}
}
