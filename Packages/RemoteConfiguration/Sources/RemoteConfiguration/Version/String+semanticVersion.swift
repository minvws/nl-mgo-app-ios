/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

extension String {
	
	/// Get a three digit semantic string of the version (https://semver.org/)
	/// - Returns: three digit semantic string of the version
	public func semanticVersion() -> String {
		
		var components = self.split(separator: ".")
		let missingComponents = max(0, 3 - components.count)
		components.append(contentsOf: Array(repeating: "0", count: missingComponents))
		return components.joined(separator: ".")
	}
}
