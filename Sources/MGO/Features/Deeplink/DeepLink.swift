/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

/// Deeplinks to the app
public enum DeepLink: Equatable, Sendable {

	/// Callback from DigiD
	case digidCallback(userinfo: String)
}
