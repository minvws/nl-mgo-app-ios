/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import MGOFoundation

// MARK: - 1: Define the Services

struct Services {
	var now: () -> Date
	var appVersionSupplier: AppVersionSupplierProtocol
	var dataStore: MgoDataStoreProtocol
	var featureFlagManager: FeatureFlagManaging
	var healthcareOrganizationStore: HealthcareOrganizationRepositoryProtocol
	var jailBreakDetector: JailBreakProtocol
	var localAuthenticationProvider: LocalAuthenticationProviderProtocol
	var localisationServiceClient: LocalisationServiceClientProtocol
	var notificationCenter: NotificationCenterProtocol
	var remoteConfigurationRepository: RemoteConfigurationRepositoryProtocol
	var resourceRepository: ResourceRepositoryProtocol
	var secureUserSettings: SecureUserSettingsProtocol
	
	init(
		now: @escaping () -> Date,
		appVersionSupplier: AppVersionSupplierProtocol,
		dataStore: MgoDataStoreProtocol,
		featureFlagManager: FeatureFlagManaging,
		healthcareOrganizationStore: HealthcareOrganizationRepositoryProtocol,
		jailBreakDetector: JailBreakProtocol,
		localAuthenticationProvider: LocalAuthenticationProviderProtocol,
		localisationServiceClient: LocalisationServiceClientProtocol,
		notificationCenter: NotificationCenterProtocol,
		remoteConfigurationRepository: RemoteConfigurationRepositoryProtocol,
		resourceRepository: ResourceRepositoryProtocol,
		secureUserSettings: SecureUserSettingsProtocol
	) {
		self.now = now
		self.appVersionSupplier = appVersionSupplier
		self.dataStore = dataStore
		self.featureFlagManager = featureFlagManager
		self.healthcareOrganizationStore = healthcareOrganizationStore
		self.jailBreakDetector = jailBreakDetector
		self.localAuthenticationProvider = localAuthenticationProvider
		self.localisationServiceClient = localisationServiceClient
		self.notificationCenter = notificationCenter
		self.remoteConfigurationRepository = remoteConfigurationRepository
		self.resourceRepository = resourceRepository
		self.secureUserSettings = secureUserSettings
	}
}

// MARK: - 2: Instantiate Private Dependencies

private let appVersionSupplier = AppVersionSupplier()
private let dataStore = InMemoryDataStore()
private let featureFlagManager = FeatureFlagManager()
private let healthcareOrganizationStore = HealthcareOrganizationRepository()
private let jailBreakDetector = JailBreakDetector()
private let localAuthenticationProvider = LocalAuthenticationProvider()
private let localisationServiceClient = LocalisationServiceClient(
	serverUrl: Configuration().urlForLocalisation(),
	username: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
	password: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String
)

private let now: () -> Date = Date.init
private let notificationCenter = NotificationCenter.default
private let secureUserSettings = SecureUserSettings()
private let remoteConfigurationRepository = RemoteConfigurationRepository(
	apiClient: RemoteConfigurationClient(serverUrl: Configuration().urlForRemoteConfiguration())
)
private let resourceRepository = ResourceRepository(
	healthcareOrganizationRepository: healthcareOrganizationStore,
	dataRepository: dataStore,
	featureFlagManager: featureFlagManager,
	serverUrl: Configuration().urlForDVP(),
	username: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
	password: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String
)

// MARK: - 3: Instantiate the Services using private dependencies:

let services: () -> Services = {
	guard !ProcessInfo().isUnitTesting else {
		fatalError("During unit testing, real services should not be instantiated during Services setup.")
	}

	if Configuration().getRelease() == .demo {
		featureFlagManager.isDemo = true
		featureFlagManager.isAutomaticLocalizationEnabled = true
	}
	
	return Services(
		now: now,
		appVersionSupplier: appVersionSupplier,
		dataStore: dataStore,
		featureFlagManager: featureFlagManager,
		healthcareOrganizationStore: healthcareOrganizationStore,
		jailBreakDetector: jailBreakDetector,
		localAuthenticationProvider: localAuthenticationProvider,
		localisationServiceClient: localisationServiceClient,
		notificationCenter: notificationCenter,
		remoteConfigurationRepository: remoteConfigurationRepository,
		resourceRepository: resourceRepository,
		secureUserSettings: secureUserSettings
	)
}

/// A global variable with all the services
var Current: Services! // swiftlint:disable:this identifier_name
