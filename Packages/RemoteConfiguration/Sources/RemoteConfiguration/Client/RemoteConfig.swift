/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import OpenAPIRuntime
import OpenAPIURLSession

public typealias RemoteConfig = Components.Schemas.RemoteConfig

extension RemoteConfig {
	
	/// Default fallback configuration
	public static var fallback: RemoteConfig {
		return RemoteConfig(iosMinimumVersion: "0.0.1")
	}
}
