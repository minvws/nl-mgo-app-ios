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
	var dataStore: MgoDataStoreProtocol
	var healthcareOrganizationStore: HealthcareOrganizationRepositoryProtocol
	var jailBreakDetector: JailBreakProtocol
	var localAuthenticationProvider: LocalAuthenticationProviderProtocol
	var notificationCenter: NotificationCenterProtocol
	var remoteConfigurationRepository: RemoteConfigurationRepositoryProtocol
	var resourceRepository: ResourceRepositoryProtocol
	var secureUserSettings: SecureUserSettingsProtocol
	
	init(
		now: @escaping () -> Date,
		dataStore: MgoDataStoreProtocol,
		healthcareOrganizationStore: HealthcareOrganizationRepositoryProtocol,
		jailBreakDetector: JailBreakProtocol,
		localAuthenticationProvider: LocalAuthenticationProviderProtocol,
		notificationCenter: NotificationCenterProtocol,
		remoteConfigurationRepository: RemoteConfigurationRepositoryProtocol,
		resourceRepository: ResourceRepositoryProtocol,
		secureUserSettings: SecureUserSettingsProtocol
	) {
		self.now = now
		self.dataStore = dataStore
		self.healthcareOrganizationStore = healthcareOrganizationStore
		self.jailBreakDetector = jailBreakDetector
		self.localAuthenticationProvider = localAuthenticationProvider
		self.notificationCenter = notificationCenter
		self.remoteConfigurationRepository = remoteConfigurationRepository
		self.resourceRepository = resourceRepository
		self.secureUserSettings = secureUserSettings
	}
}

// MARK: - 2: Instantiate Private Dependencies

private let dataStore = InMemoryDataStore()
private let healthcareOrganizationStore = HealthcareOrganizationRepository()
private let jailBreakDetector = JailBreakDetector()
private let localAuthenticationProvider = LocalAuthenticationProvider()
private let now: () -> Date = Date.init
private let notificationCenter = NotificationCenter.default
private let secureUserSettings = SecureUserSettings()
private let remoteConfigurationRepository = RemoteConfigurationRepository(
	apiClient: RemoteConfigurationClient(serverUrl: Configuration().urlForRemoteConfiguration())
)
private let resourceRepository = ResourceRepository(
	healthcareOrganizationRepository: healthcareOrganizationStore,
	dataRepository: dataStore,
	serverUrl: Configuration().urlForDVP(),
	username: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
	password: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String
)

// MARK: - 3: Instantiate the Services using private dependencies:

let services: () -> Services = {
	guard !ProcessInfo().isUnitTesting else {
		fatalError("During unit testing, real services should not be instantiated during Services setup.")
	}

	return Services(
		now: now,
		dataStore: dataStore,
		healthcareOrganizationStore: healthcareOrganizationStore,
		jailBreakDetector: jailBreakDetector,
		localAuthenticationProvider: localAuthenticationProvider,
		notificationCenter: notificationCenter,
		remoteConfigurationRepository: remoteConfigurationRepository,
		resourceRepository: resourceRepository,
		secureUserSettings: secureUserSettings
	)
}

/// A global variable with all the services
var Current: Services! // swiftlint:disable:this identifier_name
