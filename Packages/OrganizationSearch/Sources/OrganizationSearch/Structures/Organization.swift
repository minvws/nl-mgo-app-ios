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

	/// The unique identifier of the organization.
	public let id: String

	/// The MedMij identifier of the organization.
	public let medmijId: String?

	/// The display name of the organization shown in search results.
	public let name: String?

	/// A concatenated blob of searchable text used by the FTS5 search index.
	/// Internal — consumers of `Organization` have no use for this field.
	let searchBlob: String?

	/// Creates a new `Organization`.
	/// - Parameters:
	///   - address: The physical location of the organization.
	///   - careType: A human-readable description of the type of care provided.
	///   - dataServices: The data services offered by this organization.
	///   - id: The unique identifier of the organization.
	///   - medmijId: The MedMij identifier of the organization.
	///   - name: The display name of the organization.
	public init(
		address: OrganizationAddress = OrganizationAddress(),
		careType: String? = nil,
		dataServices: [DataService]? = nil,
		id: String,
		medmijId: String? = nil,
		name: String? = nil
	) {
		self.address = address
		self.careType = careType
		self.dataServices = dataServices
		self.id = id
		self.medmijId = medmijId
		self.name = name
		self.searchBlob = nil
	}

	/// Creates a new `Organization` with a search index blob.
	///
	/// For internal use by the search index pipeline and tests. The `searchBlob`
	/// parameter has no default value to prevent ambiguity with the public initializer.
	init(
		address: OrganizationAddress = OrganizationAddress(),
		careType: String? = nil,
		dataServices: [DataService]? = nil,
		id: String,
		medmijId: String? = nil,
		name: String? = nil,
		searchBlob: String?
	) {
		self.address = address
		self.careType = careType
		self.dataServices = dataServices
		self.id = id
		self.medmijId = medmijId
		self.name = name
		self.searchBlob = searchBlob
	}

	// MARK: - Codable

	/// Flat JSON keys — the bundled JSON has address fields at the top level,
	/// not nested under an `address` object.
	private enum CodingKeys: String, CodingKey {
		case address, careType, city, dataServices, id, medmijId, name
		case geoLat, geoLng, postalCode, searchBlob
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
		self.id = try container.decode(String.self, forKey: .id)
		self.medmijId = try container.decodeIfPresent(String.self, forKey: .medmijId)
		self.name = try container.decodeIfPresent(String.self, forKey: .name)
		self.searchBlob = try container.decodeIfPresent(String.self, forKey: .searchBlob)
	}
}
