/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

// MARK: - Organization
public struct Organization: Codable, Hashable, Sendable {
	
	public let addressLine, careTypeDisplay, city: String?
	public let dataServices: [String: DataService]?
	public let displayName: String?
	public let geoLat, geoLng: Double?
	public let id: String
	public let normalizedDisplayName, postalCode, searchBlob: String?
	
	public init(addressLine: String?, careTypeDisplay: String?, city: String?, dataServices: [String: DataService]?, displayName: String?, geoLat: Double?, geoLng: Double?, id: String, normalizedDisplayName: String?, postalCode: String?, searchBlob: String?) {
		self.addressLine = addressLine
		self.careTypeDisplay = careTypeDisplay
		self.city = city
		self.dataServices = dataServices
		self.displayName = displayName
		self.geoLat = geoLat
		self.geoLng = geoLng
		self.id = id
		self.normalizedDisplayName = normalizedDisplayName
		self.postalCode = postalCode
		self.searchBlob = searchBlob
	}
}
