/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation

extension Container {
	
	/// Reset all the data within applicable Services
	func wipePersistedData() {
		
		dataStore().wipePersistedData()
		healthcareOrganizationRepository().wipePersistedData()
		patientFriendyTermsRepository().wipePersistedData()
		remoteConfigurationRepository().wipePersistedData()
		secureUserSettings().wipePersistedData()
	}
}
