/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOTest
import MGOFoundation
@testable import MGO

///
/// Set of Spies with sensible default stubbed values, which can be modified per-test.
///
final class ServicesSpies {
	
	fileprivate init() { /* private so it can not be initiated elsewhere */ }
	
	var appVersionSupplierSpy: AppVersionSupplierSpy = {
		let spy = AppVersionSupplierSpy()
		spy.stubbedGetCurrentVersionResult = "1.0.0"
		spy.stubbedGetCurrentBuildResult = "1"
		return spy
	}()
	
	var dataStoreSpy: MgoDataStoreSpy = {
		let spy = MgoDataStoreSpy()
		let records = [MgoResourceRecord(categoryId: "test", organizationId: "test", resources: [], error: false)]
		spy.stubbedGetCategoryIdResult = .success(records)
		spy.stubbedGetCategoryIdOrganizationIdResult = .success(records)
		(spy.stubbedObservatory, _) = Observatory<Bool>.create()
		return spy
	}()
	
	var featureFlagSpy: FeatureFlagManagerSpy = {
		let spy = FeatureFlagManagerSpy()
		spy.stubbedIsAutomaticLocalizationEnabled = true
		spy.stubbedIsDemo = false
		return spy
	}()
	
	var healthcareOrganizationStoreSpy: HealthcareOrganizationRepositorySpy = {
		let spy = HealthcareOrganizationRepositorySpy()
		(spy.stubbedObservatory, _) = Observatory<(MgoOrganization?, HealthcareOrganizationReason)>.create()
		return spy
	}()

	var jailBreakSpy: JailBreakProtocolSpy = {
		let spy = JailBreakProtocolSpy()
		spy.stubbedIsJailBrokenResult = false
		return spy
	}()
	
	var notificationCenterSpy: NotificationCenterSpy = {
		let spy = NotificationCenterSpy()
		spy.stubbedAddObserverForNameResult = NSObject()
		return spy
	}()
		
	var secureUserSettingsSpy: SecureUserSettingsSpy = {
		return SecureUserSettingsSpy()
	}()

	var localAuthenticationProviderSpy: LocalAuthenticationProviderSpy = {
		let spy = LocalAuthenticationProviderSpy()
		spy.stubbedBiometricType = { .faceID }
		return spy
	}()
	
	var localisationServiceClientSpy: LocalisationServiceClientSpy = {
		let url = URL(string: "https://example.com")!
		let spy = LocalisationServiceClientSpy(serverUrl: url, username: nil, password: nil)
		return spy
	}()
	
	var remoteConfigurationRepositorySpy: RemoteConfigurationRepositorySpy = {
		let spy = RemoteConfigurationRepositorySpy()
		spy.stubbedStoredConfiguration = RemoteConfig.fallback
		(spy.stubbedObservatory, _) = Observatory<RemoteConfig>.create()
		return spy
	}()
	
	var resourceRepositorySpy: ResourceRepositorySpy = {
		return ResourceRepositorySpy()
	}()
}

/// Setup the services spies
/// - Returns: the services spies
func setupServicesSpies() -> ServicesSpies {
	
	let spies = ServicesSpies()
	
	Current = Services(
		now: { Date(timeIntervalSince1970: 1700000000) }, // Tuesday, 14 November 2023 22:13:20
		appVersionSupplier: spies.appVersionSupplierSpy,
		dataStore: spies.dataStoreSpy,
		featureFlagManager: spies.featureFlagSpy,
		healthcareOrganizationStore: spies.healthcareOrganizationStoreSpy,
		jailBreakDetector: spies.jailBreakSpy,
		localAuthenticationProvider: spies.localAuthenticationProviderSpy,
		localisationServiceClient: spies.localisationServiceClientSpy,
		notificationCenter: spies.notificationCenterSpy,
		remoteConfigurationRepository: spies.remoteConfigurationRepositorySpy,
		resourceRepository: spies.resourceRepositorySpy,
		secureUserSettings: spies.secureUserSettingsSpy
	)
	
	return spies
}
