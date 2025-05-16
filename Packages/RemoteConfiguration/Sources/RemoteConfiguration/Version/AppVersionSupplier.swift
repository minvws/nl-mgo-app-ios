/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// The version of the app
public protocol AppVersionSupplierProtocol {
	
	/// Get the current version of the app
	func getCurrentVersion() -> String
	
	/// Get the current build of the app
	func getCurrentBuild() -> String
}

public struct AppVersionSupplier: AppVersionSupplierProtocol {
	
	public init() { /* public init for public access */ }
	
	/// Get the current version number of the app
	/// - Returns: the current version number
	public func getCurrentVersion() -> String {
		
		if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
			return version
		}
		return "1.0.0" // Default to 1.0.0
	}
	
	/// Get the current build of the app
	public func getCurrentBuild() -> String {
		
		if let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String {
			return version
		}
		return "1" // Default to 1
	}
}
