/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGODebug

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
	
	/// is this data of a certain profile type
	/// - Parameter reference: the profile
	/// - Returns: True if the data is of type profile
	func isReference(_ reference: String) -> Bool {
		do {
			if let object = try JSONSerialization.jsonObject(with: self) as? [String: Any],
			   let referenceId = object["referenceId"] as? String, referenceId == reference {
				return true
			}
		} catch {
			logError("ZibFactory - isReference \(reference): \(error)")
		}
		return false
	}
}
