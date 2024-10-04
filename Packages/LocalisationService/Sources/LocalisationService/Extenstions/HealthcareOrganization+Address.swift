/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
		}
		
		return (address, firstAddress.city, firstAddress.postalcode)
	}
}
