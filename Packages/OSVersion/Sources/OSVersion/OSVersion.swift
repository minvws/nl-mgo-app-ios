/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public enum iOSVersion: String, Codable { // swiftlint:disable:this type_name
	case v15
	case v16
	case v17
	case v18
	case v26
}

public enum OSVersion: Codable {
	
	case iOS(iOSVersion)
}

public protocol OSVersionProtocol {
	
	func available(version: OSVersion) -> Bool
}

public class OSVersionChecker: OSVersionProtocol {
	
	public init() {
		// Public initializer
	}
	
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
