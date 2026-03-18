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
	public let careType: String?

	/// The data services offered by this organization.
	public let dataServices: [DataService]?

	/// The display name of the organization shown in search results.
	public let name: String?

	/// The unique identifier of the organization.
	public let id: String

	/// A concatenated blob of searchable text used by the search index.
	public let searchBlob: String?

	/// Creates a new `Organization`.
	/// - Parameters:
	///   - address: The physical location of the organization.
	///   - careType: A human-readable description of the type of care provided.
	///   - dataServices: The data services offered by this organization.
	///   - name: The display name of the organization.
	///   - id: The unique identifier of the organization.
	///   - searchBlob: A concatenated blob of searchable text used by the search index.
	public init(
		address: OrganizationAddress = OrganizationAddress(),
		careType: String? = nil,
		dataServices: [DataService]? = nil,
		name: String? = nil,
		id: String,
		searchBlob: String? = nil
	) {
		self.address = address
		self.careType = careType
		self.dataServices = dataServices
		self.name = name
		self.id = id
		self.searchBlob = searchBlob
	}

	// MARK: - Codable

	/// Flat JSON keys — the bundled JSON has address fields at the top level,
	/// not nested under an `address` object.
	private enum CodingKeys: String, CodingKey {
		case address, careType, city, dataServices, name
		case geoLat, geoLng, id, postalCode, searchBlob
	}

	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		self.address = OrganizationAddress(
			address: try container.decodeIfPresent(String.self, forKey: .address),
			city: try container.decodeIfPresent(String.self, forKey: .city),
			geoLat: try container.decodeIfPresent(Double.self, forKey: .geoLat),
			geoLng: try container.decodeIfPresent(Double.self, forKey: .geoLng),
			postalCode: try container.decodeIfPresent(String.self, forKey: .postalCode)
		)
		self.careType = try container.decodeIfPresent(String.self, forKey: .careType)
		self.dataServices = try container.decodeIfPresent([DataService].self, forKey: .dataServices)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.id = try container.decode(String.self, forKey: .id)
		self.searchBlob = try container.decodeIfPresent(String.self, forKey: .searchBlob)
	}
}
