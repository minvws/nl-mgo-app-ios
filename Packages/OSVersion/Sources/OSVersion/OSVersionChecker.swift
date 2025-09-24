/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public protocol OSVersionProtocol {
	
	func available(version: OSVersion) -> Bool
}

nonisolated public class OSVersionChecker: OSVersionProtocol {
	
	/// Create an instance of the OS Version Checker
	public init() {
		// Public initializer
	}
	
	/// Is this version of the OS available?
	/// - Parameter version: the version to check
	/// - Returns: true if available, false if unavailable
	public func available(version: OSVersion) -> Bool {
		
		switch version {
			case .iOS(let iOSVersion):
				switch iOSVersion {
					case .v15:
						if #available(iOS 15.0, *) {
							return true
						}
						return false
					case .v16:
						if #available(iOS 16.0, *) {
							return true
						}
						return false
					case .v17:
						if #available(iOS 17.0, *) {
							return true
						}
						return false
					case .v18:
						if #available(iOS 18.0, *) {
							return true
						}
						return false
					case .v26:
						if #available(iOS 26.0, *) {
							return true
						}
						return false
				}
		}
	}
}
