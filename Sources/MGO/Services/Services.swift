/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */
	
import MGOFoundation
import MGOUI

extension Container {
	
	/// What is the current version of the application
	var appVersionSupplier: Factory<AppVersionSupplierProtocol> {
		Factory(self) { AppVersionSupplier() }
			.shared
	}
	
	/// The store for Mgo  Resource records
	var dataStore: Factory<MgoDataStoreProtocol> {
		Factory(self) { InMemoryDataStore() }
			.singleton
	}
	
	/// Holding all the feature flags
	var featureFlagManager: Factory<FeatureFlagManaging> {
		Factory(self) { @MainActor in FeatureFlagManager() }
			.singleton
	}
	
	var favoritesRepository: Factory<FileRepository<SharedHealthCategories.Category>> {
		Factory(self) { FileRepository<SharedHealthCategories.Category>(fileName: "favorites.json") }
			.singleton
	}
	
	/// The repository for all the stored healthcare organizations
	var healthcareOrganizationRepository: Factory<HealthcareOrganizationRepositoryProtocol> {
		Factory(self) { HealthcareOrganizationRepository() }
			.singleton
	}
	
	/// Detect jail broken devices
	var jailBreakDetector: Factory<JailBreakProtocol> {
		Factory(self) { @MainActor in JailBreakDetector() }
			.shared
	}
	
	/// Access to the biometric access provider
	var localAuthenticationProvider: Factory<LocalAuthenticationProviderProtocol> {
		Factory(self) { LocalAuthenticationProvider() }
			.shared
	}
	
	/// The Client to fetch healthcare providers
	var localisationServiceClient: Factory<LocalisationServiceClientProtocol> {
		Factory(self) {
			LocalisationServiceClient(
				serverUrl: Configuration().urlForLocalisation(),
				username: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
				password: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String
			)
		}
		.singleton
	}
	
	/// The organization Search client
	var organizationSearchClient: Factory<OrganizationSearchClientProtocol> {
		Factory(self) { OrganizationSearchClient() }
		.singleton
	}
	
	/// The patient friendly terms repository
	var patientFriendyTermsRepository: Factory<PatientFriendlyTermsRepositoryProtocol> {
		Factory(self) {
			do {
				let serverUrl = try PatientFriendlyTermsServers.Server1.url()
				if let username = Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
				   let password = Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String {
					return PatientFriendlyTermsRepository(
						client: PatientFriendlyTermsAPIClient(
							serverUrl,
							username: username,
							password: password
						)
					)
				} else {
					return PatientFriendlyTermsRepository(client: PatientFriendlyTermsAPIClient(serverUrl))
				}
			} catch {
				fatalError("No Patient Friendly Terms Server available")
			}
		}
		.singleton
	}
	
	/// The os Version Checker
	var osVersionChecker: Factory<OSVersionProtocol> {
		Factory(self) {
			OSVersionChecker()
		}
		.shared
	}
	
	/// The remote configuration repository
	var remoteConfigurationRepository: Factory<RemoteConfigurationRepositoryProtocol> {
		Factory(self) {
			if let username = Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
			   let password = Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String {
				
				RemoteConfigurationRepository(
					apiClient: RemoteConfigurationClient(
						serverUrl: Configuration().urlForRemoteConfiguration(),
						username: username,
						password: password
					)
				)
			} else {
				RemoteConfigurationRepository(
					apiClient: RemoteConfigurationClient(
						serverUrl: Configuration().urlForRemoteConfiguration()
					)
				)
			}
		}
		.singleton
	}
	
	var resourceRepository: Factory<ResourceRepositoryProtocol> {
		Factory(self) { @MainActor in
			ResourceRepository(
				healthcareOrganizationRepository: self.healthcareOrganizationRepository(),
				dataRepository: self.dataStore(),
				networkAvailabilityChecker: self.networkAvailabilityChecker(),
				featureFlagManager: self.featureFlagManager(),
				serverUrl: Configuration().urlForDVP(),
				username: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
				password: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String
			)
		}
		.singleton
	}
	
	/// Sending and receiving notifications
	var notificationCenter: Factory<NotificationCenterProtocol> {
		Factory(self) { NotificationCenter.default }
			.shared
	}
	
	/// Checking the network
	var networkAvailabilityChecker: Factory<NetworkAvailabilityChecking> {
		Factory(self) { NetworkAvailabilityChecker() }
			.singleton
	}
	
	/// What is the date
	var now: Factory<() -> Date> {
		Factory(self) { Date.init }
			.unique
	}
	
	/// Storing user settings securely
	var secureUserSettings: Factory<SecureUserSettingsProtocol> {
		Factory(self) { SecureUserSettings() }
			.singleton
	}
}
