/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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

	var healthcareOrganizationStoreSpy: HealthcareOrganizationRepositorySpy = {
		let spy = HealthcareOrganizationRepositorySpy()
		(spy.stubbedObservatory, _) = Observatory<Bool>.create()
		(spy.stubbedRemovalObservatory, _) = Observatory<HealthcareOrganization>.create()
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
	
	var remoteConfigurationRepositorySpy: RemoteConfigurationRepositorySpy = {
		let spy = RemoteConfigurationRepositorySpy()
		spy.stubbedStoredConfiguration = RemoteConfig.fallback
		(spy.stubbedObservatory, _) = Observatory<RemoteConfig>.create()
		return spy
	}()
}

/// Setup the services spies
/// - Returns: the services spies
func setupServicesSpies() -> ServicesSpies {
	
	let spies = ServicesSpies()
	
	Current = Services(
		now: { Date(timeIntervalSince1970: 1700000000) }, // Tuesday, 14 November 2023 22:13:20
		healthcareOrganizationStore: spies.healthcareOrganizationStoreSpy,
		localAuthenticationProvider: spies.localAuthenticationProviderSpy,
		notificationCenter: spies.notificationCenterSpy,
		remoteConfigurationRepository: spies.remoteConfigurationRepositorySpy,
		secureUserSettings: spies.secureUserSettingsSpy
	)
	
	return spies
}
