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
				case .acceptance, .production: return try LocalisationService.Servers.Server2.url()
				case .demo, .development, .test: return try LocalisationService.Servers.Server1.url()
			}
			
		} catch {
			logError("Configuration: error creating localisation url", error)
		}
		fatalError("Configuration: No url for the localisation service")
	}
}

extension Configuration {
	
	/// Get the url for the remote config server
	/// - Returns: url of the remote config server
	func urlForRemoteConfiguration() -> URL {
		do {
			switch getRelease() {
				case .acceptance, .production: return try RemoteConfiguration.Servers.Server2.url()
				case .demo, .development, .test: return try RemoteConfiguration.Servers.Server1.url()
			}
			
		} catch {
			logError("Configuration: error creating remote config url", error)
		}
		fatalError("Configuration: No url for the remote config service")
	}
}

extension Configuration {
	
	/// Get the url for the dvp server
	/// - Returns: url of the dvp server
	func urlForDVP() -> URL {
		
		let urlString: String = {
			switch getRelease() {
				case .production, .acceptance: return "https://dva.acc.mgo.irealisatie.nl/fhir"
				case .demo, .development, .test: return "https://dva.test.mgo.irealisatie.nl/fhir"
			}
		}()
		
		guard let url = Foundation.URL(string: urlString) else {
			fatalError("Configuration: No url for the dvp server")
		}
		
		return url
	}
}
