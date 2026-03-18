/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import GRDB

/// Encapsulates all SQL operations for the `stored_organization` table.
enum StoreDatabase {

	/// Fetches all stored organizations ordered by insertion order.
	///
	/// - Parameter dbQueue: The database to read from.
	/// - Returns: All organizations currently in `stored_organization`, in row insertion order.
	/// - Throws: GRDB errors if the read fails, or decoding errors if a `dataServicesJSON`
	///   column contains malformed JSON.
	static func fetchAll(from dbQueue: DatabaseQueue) throws -> [Organization] {
		
		try dbQueue.read { db in
			let rows = try Row.fetchAll(
				db,
				sql: "SELECT * FROM stored_organization ORDER BY rowid"
			)
			return try rows.map { try makeOrganization(from: $0) }
		}
	}

	/// Inserts an organization into `stored_organization`, ignoring duplicates (dedup by `id`).
	///
	/// - Parameters:
	///   - org: The organization to insert.
	///   - dbQueue: The database to write to.
	/// - Throws: GRDB errors if the write fails; encoding errors if `dataServices` cannot
	///   be serialised to JSON.
	static func insert(_ org: Organization, into dbQueue: DatabaseQueue) throws {
		
		try dbQueue.write { db in
			try insertRow(for: org, into: db)
		}
	}

	/// Deletes a single organization from `stored_organization` by `id`.
	///
	/// - Parameters:
	///   - org: The organization to remove.
	///   - dbQueue: The database to write to.
	/// - Throws: GRDB errors if the write fails.
	static func delete(_ org: Organization, from dbQueue: DatabaseQueue) throws {
		
		try dbQueue.write { db in
			try db.execute(
				sql: "DELETE FROM stored_organization WHERE id = ?",
				arguments: [org.id]
			)
		}
	}

	/// Replaces the entire stored list atomically: deletes all rows then re-inserts
	/// `organizations` in a single write transaction.
	///
	/// - Parameters:
	///   - organizations: The new list to store.
	///   - dbQueue: The database to write to.
	/// - Throws: GRDB errors if the write fails; encoding errors if any `dataServices` value
	///   cannot be serialised to JSON.
	static func replace(
		with organizations: [Organization],
		in dbQueue: DatabaseQueue
	) throws {
		
		try dbQueue.write { db in
			try db.execute(sql: "DELETE FROM stored_organization")
			for org in organizations {
				try insertRow(for: org, into: db)
			}
		}
	}

	/// Deletes all rows from `stored_organization`.
	///
	/// - Parameter dbQueue: The database to write to.
	/// - Throws: GRDB errors if the write fails.
	static func deleteAll(from dbQueue: DatabaseQueue) throws {
		
		try dbQueue.write { db in
			try db.execute(sql: "DELETE FROM stored_organization")
		}
	}

	// MARK: - Private

	/// Decodes a single GRDB `Row` from `stored_organization` into an `Organization`.
	///
	/// The `dataServicesJSON` text column, if present, is decoded back into a
	/// `[DataService]` array using snake_case key conversion.
	///
	/// - Parameter row: A row returned by a `stored_organization` SELECT query.
	/// - Returns: A fully populated `Organization`.
	/// - Throws: Decoding errors if `dataServicesJSON` is present but malformed.
	private static func makeOrganization(from row: Row) throws -> Organization {
		
		let decoder = newJSONDecoder()
		decoder.keyDecodingStrategy = .convertFromSnakeCase

		let dataServices: [DataService]? = try (row["dataServicesJSON"] as String?)
			.flatMap { try decoder.decode([DataService].self, from: Data($0.utf8)) }

		return Organization(
			address: OrganizationAddress(
				address: row["addressLine"],
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
	}

	/// Encodes and inserts a single organization row into `stored_organization`.
	///
	/// Uses `INSERT OR IGNORE` so duplicate `id` values are silently skipped.
	/// The `dataServices` array is JSON-encoded to a text blob stored in
	/// `dataServicesJSON`, decoded back to `[DataService]` at query time
	/// by `makeOrganization(from:)`.
	///
	/// - Parameters:
	///   - org: The organization to insert.
	///   - db: An open writable GRDB database connection.
	/// - Throws: GRDB errors if the insert fails; encoding errors if `dataServices`
	///   cannot be serialised to JSON.
	private static func insertRow(
		for org: Organization,
		into db: Database
	) throws {
		
		let dataServicesJSON = try org.dataServices
			.map { try newJSONEncoder().encode($0) }
			.flatMap { String(data: $0, encoding: .utf8) }

		try db.execute(
			sql: """
				INSERT OR IGNORE INTO stored_organization
					(id, addressLine, careType, city,
					 dataServicesJSON, medmijId, name, geoLat, geoLng,
					 postalCode)
				VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
				""",
			arguments: [
				org.id,
				org.address.address,
				org.careType,
				org.address.city,
				dataServicesJSON,
				org.medmijId,
				org.name,
				org.address.geoLat,
				org.address.geoLng,
				org.address.postalCode
			]
		)
	}
}
