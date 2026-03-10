/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - Organization

/// A healthcare organization returned by the organization search index.
public struct Organization: Decodable, Hashable, Sendable {

	/// The physical location of the organization.
	public let address: OrganizationAddress

	/// A human-readable description of the type of care the organization provides.
	public let careTypeDisplay: String?

	/// The data services offered by this organization, keyed by data service identifier.
	public let dataServices: [String: DataService]?

	/// The display name of the organization shown in search results.
	public let displayName: String?

	/// The unique identifier of the organization.
	public let id: String

	/// A concatenated blob of searchable text used by the search index.
	public let searchBlob: String?

	/// Creates a new `Organization`.
	/// - Parameters:
	///   - address: The physical location of the organization.
	///   - careTypeDisplay: A human-readable description of the type of care provided.
	///   - dataServices: The data services offered, keyed by data service identifier.
	///   - displayName: The display name of the organization.
	///   - id: The unique identifier of the organization.
	///   - searchBlob: A concatenated blob of searchable text used by the search index.
	public init(
		address: OrganizationAddress = OrganizationAddress(),
		careTypeDisplay: String? = nil,
		dataServices: [String: DataService]? = nil,
		displayName: String? = nil,
		id: String,
		searchBlob: String? = nil
	) {
		self.address = address
		self.careTypeDisplay = careTypeDisplay
		self.dataServices = dataServices
		self.displayName = displayName
		self.id = id
		self.searchBlob = searchBlob
	}

	// MARK: - Codable

	/// Flat JSON keys — the bundled JSON has address fields at the top level,
	/// not nested under an `address` object.
	private enum CodingKeys: String, CodingKey {
		case addressLine, careTypeDisplay, city, dataServices, displayName
		case geoLat, geoLng, id, postalCode, searchBlob
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.address = OrganizationAddress(
			addressLine: try container.decodeIfPresent(String.self, forKey: .addressLine),
			city: try container.decodeIfPresent(String.self, forKey: .city),
			geoLat: try container.decodeIfPresent(Double.self, forKey: .geoLat),
			geoLng: try container.decodeIfPresent(Double.self, forKey: .geoLng),
			postalCode: try container.decodeIfPresent(String.self, forKey: .postalCode)
		)
		self.careTypeDisplay = try container.decodeIfPresent(String.self, forKey: .careTypeDisplay)
		self.dataServices = try container.decodeIfPresent([String: DataService].self, forKey: .dataServices)
		self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
		self.id = try container.decode(String.self, forKey: .id)
		self.searchBlob = try container.decodeIfPresent(String.self, forKey: .searchBlob)
	}
}
