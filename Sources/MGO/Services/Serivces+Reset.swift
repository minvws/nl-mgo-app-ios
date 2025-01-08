/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

extension Services {
	
	/// Reset all the data within applicable Services
	func wipePersistedData() {
		
		dataStore.wipePersistedData()
		if Configuration().getRelease() != .demo {
			featureFlagManager.wipePersistedData()
		}
		healthcareOrganizationStore.wipePersistedData()
		remoteConfigurationRepository.wipePersistedData()
		secureUserSettings.wipePersistedData()
	}
}
