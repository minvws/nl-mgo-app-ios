/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

extension Services {
	
	/// Reset all the data within applicable Services
	func wipePersistedData() {
		
		dataStore.wipePersistedData()
		healthcareOrganizationStore.wipePersistedData()
		remoteConfigurationRepository.wipePersistedData()
		secureUserSettings.wipePersistedData()
	}
}
