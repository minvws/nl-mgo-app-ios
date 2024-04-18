/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

extension NavigationStackBackport.NavigationPath {
	
	/// Get the index of a string in the navigation path
	/// - Parameter value: the string value to search
	/// - Returns: if the value is present in the navigation path, we return the `index`, if not found `nil`.
	func indexOf(_ value: Any) -> Int? {
		
		if let codable = self.codable,
		   let data = try? JSONEncoder().encode(codable),
		   let arrayOfStringObjects = try? JSONDecoder().decode([String].self, from: data) {
			
			let arrayOfPaths: [String] = arrayOfStringObjects
				// Remove the lines with "MGO.AppCoordination.State"
				.filter { string in
					string != "MGO.AppCoordination.State"
				}
				// remove non alphaNumeric chars
				.map { $0.alphaNumeric }
				// reverse the order
				.reversed()
			
			logDebug("NavigationPath: the path consists of \(arrayOfPaths)")

			let castedValue = String(describing: value).map { String($0).alphaNumeric }.joined()
			for (index, element) in arrayOfPaths.enumerated() where element == castedValue {
				return index
			}
		}
		return nil
	}
}

extension String {
	
	/// Get the value of a string wiith only alpha numeric characters
	var alphaNumeric: String {
		return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
	}
}
