/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public extension MgoOrganization {
	
	/// Get the address details from a health organization
	/// - Returns: tuple of address, city and postal code
	func getAddress() -> (address: String, city: String?, postalCode: String?) {
	
		guard let firstAddress = addresses?.first else {
			return ("", nil, nil)
		}
		
		var address = ""
		if let lines = firstAddress.lines,
			let firstLine = lines.first {
			address = firstLine ?? ""
		} else {
			if var rawAddress = firstAddress.address {
				rawAddress = rawAddress.replacingOccurrences(of: "\r\n", with: "|")
				rawAddress = rawAddress.replacingOccurrences(of: "\n", with: "|")
				rawAddress = rawAddress.replacingOccurrences(of: ",", with: "|")
				
				let addressParts = rawAddress.split(separator: "|")
				if let addressPart = addressParts.first {
					address = String(addressPart)
				}
			}
		}
		
		return (address, firstAddress.city, firstAddress.postalcode)
	}
}
