/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Logging

public extension Data {
	
	/// is this data of a certain profile type
	/// - Parameter profileDefinition: the profile
	/// - Returns: True if the data is of type profile
	func hasProfile(_ profileDefinition: String) -> Bool {
		do {
			if let object = try JSONSerialization.jsonObject(with: self) as? [String: Any],
			   let profile = object["profile"] as? String, profile == profileDefinition {
				return true
			}
		} catch {
			logError("ZibFactory - hasProfile \(profileDefinition): \(error)")
		}
		return false
	}
}
