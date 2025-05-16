/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

/// Deeplinks to the app
public enum DeepLink: Equatable, Sendable {

	/// Callback from DigiD
	case digidCallback(userinfo: String)
}
