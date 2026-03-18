/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - OrganizationAddress

/// The physical location details of a healthcare organization.
public struct OrganizationAddress: Hashable, Sendable {

	/// The street address of the organization.
	public let address: String?

	/// The city in which the organization is located.
	public let city: String?

	/// The latitude coordinate of the organization's location.
	public let geoLat: Double?

	/// The longitude coordinate of the organization's location.
	public let geoLng: Double?

	/// The postal code of the organization's address.
	public let postalCode: String?

	public init(
		address: String? = nil,
		city: String? = nil,
		geoLat: Double? = nil,
		geoLng: Double? = nil,
		postalCode: String? = nil
	) {
		self.address = address
		self.city = city
		self.geoLat = geoLat
		self.geoLng = geoLng
		self.postalCode = postalCode
	}
}
