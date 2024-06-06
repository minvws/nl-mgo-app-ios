/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension Observation {
	
	public var quantityText: String? {
		
		if case .quantity(let quantity) = self.value {
			return quantityToString(quantity)
		}
		return nil
	}
	
	public var referenceLowText: String? {
		
		if let quantity = self.referenceRange?.first?.low {
			return quantityToString(quantity)
		}
		return nil
	}
	
	public var referenceHighText: String? {
		
		if let quantity = self.referenceRange?.first?.high {
			return quantityToString(quantity)
		}
		return nil
	}
	
	private func quantityToString(_ quantity: Quantity) -> String? {
		
		guard let value = quantity.value?.value?.decimal else { return nil }
		
		var output = "\(value)"

		if let unit = quantity.unit?.value?.string {
			output += " \(unit)"
		}
		
		return output
	}
}
