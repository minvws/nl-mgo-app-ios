/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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

#warning("Rool, 28/01/2025: The production endpoints still point to acceptance. This needs to be changed to production")

extension Configuration {
	
	/// Get the url for the localization (organization dataset) server
	/// - Returns: url of the localization server
	func urlForLocalization() -> URL {
		urlForLocalization(for: getRelease())
	}

	func urlForLocalization(for release: Release) -> URL {
		do {
			switch release {
				case .acceptance, .production: return try LocalizationServers.acceptanceUrl()
				case .development, .test: return try LocalizationServers.testUrl()
			}
		} catch {
			logError("Configuration: error creating localization url", error)
		}
		fatalError("Configuration: No url for the localization service")
	}

	/// Get the url for the remote config server
	/// - Returns: url of the remote config server
	func urlForRemoteConfiguration() -> URL {
		urlForRemoteConfiguration(for: getRelease())
	}

	func urlForRemoteConfiguration(for release: Release) -> URL {
		do {
			switch release {
				case .acceptance, .production: return try RemoteConfiguration.Servers.Server2.url()
				case .development, .test: return try RemoteConfiguration.Servers.Server1.url()
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
		urlForDVP(for: getRelease())
	}

	func urlForDVP(for release: Release) -> URL {
		let urlString: String = {
			switch release {
				case .production, .acceptance: return "https://dvp-proxy.acc.mgo.irealisatie.nl/fhir"
				case .development, .test: return "https://dvp-proxy.test.mgo.irealisatie.nl/fhir"
			}
		}()

		guard let url = Foundation.URL(string: urlString) else {
			fatalError("Configuration: No url for the dvp server")
		}

		return url
	}
}

extension Configuration {
	
	/// Get the url for the oidc server
	/// - Returns: url of the oidc server
	func urlForOIDC() -> URL {
		urlForOIDC(for: getRelease())
	}

	func urlForOIDC(for release: Release) -> URL {
		let urlString: String = {
			switch release {
				case .production, .acceptance: return "https://dvp-proxy.acc.mgo.irealisatie.nl"
				case .development, .test: return "https://dvp-proxy.test.mgo.irealisatie.nl"
//				case .development: return "http://localhost:8801"
			}
		}()

		guard let url = Foundation.URL(string: urlString) else {
			fatalError("Configuration: No url for the oidc server")
		}

		return url
	}
	
	/// Get the callback url for oidc
	/// - Returns: the callback url
	func getOIDCCallback() -> String {
		return "\(getCallbackScheme())://app/login"
	}
	
	/// Get the callback scheme
	/// - Returns: the callback scheme
	func getCallbackScheme() -> String {
		
		switch getRelease() {
			case .production: return "mgo"
			case .acceptance: return "mgo-acc"
			case .test: return "mgo-test"
			case .development: return "mgo-dev"
		}
	}
}
