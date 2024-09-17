/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

public class Configuration {
	
	/// Initlializer
	public init() { /* Public initializer needed for public access */ }
	
	/// Which release are we?
	/// - Returns: the flavour of the app (Production, Acceptance, Test, Development)
	public func getRelease() -> Release {
		
		guard let networkConfigurationValue = Bundle.main.infoDictionary?["NETWORK_CONFIGURATION"] as? String else { return .test }
		guard let release = Release(rawValue: networkConfigurationValue.lowercased()) else { return .test }
		return release
	}
}

extension Configuration {
	
	/// Get the url for the localisation server
	/// - Returns: url of the localisation server
	func urlForLocalisation() -> URL {
		do {
			switch getRelease() {
				case .acceptance, .production: return try LocalisationService.Servers.server2()
				case .development, .test: return try LocalisationService.Servers.server1()
			}
			
		} catch {
			logError("Configuration: error creating localisation url", error)
		}
		fatalError("Configuration: No url for the localisation service")
	}
}

extension Configuration {
	
	/// Get the url for the localisation server
	/// - Returns: url of the localisation server
	func urlForRemoteConfiguration() -> URL {
		do {
			switch getRelease() {
				case .production: return try RemoteConfiguration.Servers.server2()
				case .development, .test, .acceptance: return try RemoteConfiguration.Servers.server1()
			}
			
		} catch {
			logError("Configuration: error creating localisation url", error)
		}
		fatalError("Configuration: No url for the localisation service")
	}
}
