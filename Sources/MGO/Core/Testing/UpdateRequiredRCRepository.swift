/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RemoteConfiguration
import Observatory

/// A stub repository used during UI testing to force the "update required" screen.
/// Registered only when the `-updateRequired` launch argument is present.
@MainActor
final class UpdateRequiredRCRepository: RemoteConfigurationRepositoryProtocol {

	let observatory: Observatory<RemoteConfig>
	private let notify: (RemoteConfig) -> Void

	var storedConfiguration = RemoteConfig(iosMinimumVersion: "99999")

	init() {
		(observatory, notify) = Observatory<RemoteConfig>.create()
	}

	func fetchAndUpdateObservers() async {
		notify(storedConfiguration)
	}

	func wipePersistedData() { /* no-op */ }
}
