/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public final class Configuration {

	/// Initlializer
	public init() {
		// Public initializer needed for public access. 
	}
	
	/// Which release are we?
	/// - Returns: the flavour of the app (Production, Acceptance, Test, Development)
	public func getRelease() -> Release {

		guard let networkConfigurationValue = Bundle.main.infoDictionary?["NETWORK_CONFIGURATION"] as? String else { return .test }
		guard let release = Release(rawValue: networkConfigurationValue.lowercased()) else { return .test }
		return release
	}
}
