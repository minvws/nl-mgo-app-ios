/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - Organization

/// A healthcare organization returned by the organization search index.
public struct Organization: Codable, Hashable, Sendable {
	
	/// The street address of the organization.
	public let addressLine: String?

	/// A human-readable description of the type of care the organization provides.
	public let careTypeDisplay: String?

	/// The city in which the organization is located.
	public let city: String?

	/// The data services offered by this organization, keyed by data service identifier.
	public let dataServices: [String: DataService]?

	/// The display name of the organization shown in search results.
	public let displayName: String?

	/// The latitude coordinate of the organization's location.
	public let geoLat: Double?

	/// The longitude coordinate of the organization's location.
	public let geoLng: Double?

	/// The unique identifier of the organization.
	public let id: String

	/// The postal code of the organization's address.
	public let postalCode: String?

	/// A concatenated blob of searchable text used by the search index.
	public let searchBlob: String?

	/// Creates a new `Organization`.
	/// - Parameters:
	///   - addressLine: The street address of the organization.
	///   - careTypeDisplay: A human-readable description of the type of care provided.
	///   - city: The city in which the organization is located.
	///   - dataServices: The data services offered, keyed by data service identifier.
	///   - displayName: The display name of the organization.
	///   - geoLat: The latitude coordinate of the organization's location.
	///   - geoLng: The longitude coordinate of the organization's location.
	///   - id: The unique identifier of the organization.
	///   - postalCode: The postal code of the organization's address.
	///   - searchBlob: A concatenated blob of searchable text used by the search index.
	public init(
		addressLine: String? = nil,
		careTypeDisplay: String? = nil,
		city: String? = nil,
		dataServices: [String: DataService]? = nil,
		displayName: String? = nil,
		geoLat: Double? = nil,
		geoLng: Double? = nil,
		id: String,
		postalCode: String? = nil,
		searchBlob: String? = nil
	) {
		self.addressLine = addressLine
		self.careTypeDisplay = careTypeDisplay
		self.city = city
		self.dataServices = dataServices
		self.displayName = displayName
		self.geoLat = geoLat
		self.geoLng = geoLng
		self.id = id
		self.postalCode = postalCode
		self.searchBlob = searchBlob
	}
}
