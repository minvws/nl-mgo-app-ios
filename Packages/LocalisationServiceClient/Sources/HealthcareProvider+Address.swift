/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public extension HealthcareProvider {
	
	/// Get the address details from a health provider
	/// - Returns: tuple of address, city and postal code
	func getAddress() -> (address: String, city: String?, postalCode: String?) {
	
		let city = addresses.first?.city
		let postalCode = addresses.first?.postalcode
		var address = addresses.first?.address
		if let city {
			address = address?.replacingOccurrences(of: city, with: "")
		}
		if let postalCode {
			address = address?.replacingOccurrences(of: postalCode, with: "")
		}
		if address != nil {
			address = address!.trimmingCharacters(in: .whitespacesAndNewlines)
		}
		
		return (address ?? "", city, postalCode)
	}
}
