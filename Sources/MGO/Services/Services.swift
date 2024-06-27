/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGOFoundation

// MARK: - 1: Define the Services

struct Services {
	var now: () -> Date
	var healthcareOrganizationStore: HealthcareOrganizationRepositoryProtocol
	var localAuthenticationProvider: LocalAuthenticationProviderProtocol
	var notificationCenter: NotificationCenterProtocol
	var secureUserSettings: SecureUserSettingsProtocol
	
	init(
		now: @escaping () -> Date,
		healthcareOrganizationStore: HealthcareOrganizationRepositoryProtocol,
		localAuthenticationProvider: LocalAuthenticationProviderProtocol,
		notificationCenter: NotificationCenterProtocol,
		secureUserSettings: SecureUserSettingsProtocol
	) {
		self.now = now
		self.healthcareOrganizationStore = healthcareOrganizationStore
		self.localAuthenticationProvider = localAuthenticationProvider
		self.notificationCenter = notificationCenter
		self.secureUserSettings = secureUserSettings
	}
}

// MARK: - 2: Instantiate Private Dependencies

private let healthcareOrganizationStore = HealthcareOrganizationRepository()
private let localAuthenticationProvider = LocalAuthenticationProvider()
private let now: () -> Date = Date.init
private let notificationCenter = NotificationCenter.default
private let secureUserSettings = SecureUserSettings()

// MARK: - 3: Instantiate the Services using private dependencies:

let services: () -> Services = {
	guard !ProcessInfo().isUnitTesting else {
		fatalError("During unit testing, real services should not be instantiated during Services setup.")
	}

	return Services(
		now: now,
		healthcareOrganizationStore: healthcareOrganizationStore,
		localAuthenticationProvider: localAuthenticationProvider,
		notificationCenter: notificationCenter,
		secureUserSettings: secureUserSettings
	)
}

/// A global variable with all the services
var Current: Services! // swiftlint:disable:this identifier_name
