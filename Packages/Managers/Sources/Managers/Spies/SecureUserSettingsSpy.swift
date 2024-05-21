/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class SecureUserSettingsSpy: SecureUserSettingsProtocol {

	/// Initlializer
	public init() {
		// Public initializer needed for public access.
	}
	
	public var invokedTempAccessCodeSetter = false
	public var invokedTempAccessCodeSetterCount = 0
	public var invokedTempAccessCode: String?
	public var invokedTempAccessCodeList = [String?]()
	public var invokedTempAccessCodeGetter = false
	public var invokedTempAccessCodeGetterCount = 0
	public var stubbedTempAccessCode: String!

	public var tempAccessCode: String? {
		set {
			invokedTempAccessCodeSetter = true
			invokedTempAccessCodeSetterCount += 1
			invokedTempAccessCode = newValue
			invokedTempAccessCodeList.append(newValue)
		}
		get {
			invokedTempAccessCodeGetter = true
			invokedTempAccessCodeGetterCount += 1
			return stubbedTempAccessCode
		}
	}

	public var invokedAccessCodeSetter = false
	public var invokedAccessCodeSetterCount = 0
	public var invokedAccessCode: String?
	public var invokedAccessCodeList = [String?]()
	public var invokedAccessCodeGetter = false
	public var invokedAccessCodeGetterCount = 0
	public var stubbedAccessCode: String!

	public var accessCode: String? {
		set {
			invokedAccessCodeSetter = true
			invokedAccessCodeSetterCount += 1
			invokedAccessCode = newValue
			invokedAccessCodeList.append(newValue)
		}
		get {
			invokedAccessCodeGetter = true
			invokedAccessCodeGetterCount += 1
			return stubbedAccessCode
		}
	}

	public var invokedBioMetricAuthenticationEnabledSetter = false
	public var invokedBioMetricAuthenticationEnabledSetterCount = 0
	public var invokedBioMetricAuthenticationEnabled: Bool?
	public var invokedBioMetricAuthenticationEnabledList = [Bool]()
	public var invokedBioMetricAuthenticationEnabledGetter = false
	public var invokedBioMetricAuthenticationEnabledGetterCount = 0
	public var stubbedBioMetricAuthenticationEnabled: Bool! = false

	public var bioMetricAuthenticationEnabled: Bool {
		set {
			invokedBioMetricAuthenticationEnabledSetter = true
			invokedBioMetricAuthenticationEnabledSetterCount += 1
			invokedBioMetricAuthenticationEnabled = newValue
			invokedBioMetricAuthenticationEnabledList.append(newValue)
		}
		get {
			invokedBioMetricAuthenticationEnabledGetter = true
			invokedBioMetricAuthenticationEnabledGetterCount += 1
			return stubbedBioMetricAuthenticationEnabled
		}
	}

	public var invokedUserHasAddedHealthcareProviderSetter = false
	public var invokedUserHasAddedHealthcareProviderSetterCount = 0
	public var invokedUserHasAddedHealthcareProvider: Bool?
	public var invokedUserHasAddedHealthcareProviderList = [Bool]()
	public var invokedUserHasAddedHealthcareProviderGetter = false
	public var invokedUserHasAddedHealthcareProviderGetterCount = 0
	public var stubbedUserHasAddedHealthcareProvider: Bool! = false

	public var userHasAddedHealthcareProvider: Bool {
		set {
			invokedUserHasAddedHealthcareProviderSetter = true
			invokedUserHasAddedHealthcareProviderSetterCount += 1
			invokedUserHasAddedHealthcareProvider = newValue
			invokedUserHasAddedHealthcareProviderList.append(newValue)
		}
		get {
			invokedUserHasAddedHealthcareProviderGetter = true
			invokedUserHasAddedHealthcareProviderGetterCount += 1
			return stubbedUserHasAddedHealthcareProvider
		}
	}
	
	public var invokedUserHasSeenAppIntroductionSetter = false
	public var invokedUserHasSeenAppIntroductionSetterCount = 0
	public var invokedUserHasSeenAppIntroduction: Bool?
	public var invokedUserHasSeenAppIntroductionList = [Bool]()
	public var invokedUserHasSeenAppIntroductionGetter = false
	public var invokedUserHasSeenAppIntroductionGetterCount = 0
	public var stubbedUserHasSeenAppIntroduction: Bool! = false

	public var userHasSeenAppIntroduction: Bool {
		set {
			invokedUserHasSeenAppIntroductionSetter = true
			invokedUserHasSeenAppIntroductionSetterCount += 1
			invokedUserHasSeenAppIntroduction = newValue
			invokedUserHasSeenAppIntroductionList.append(newValue)
		}
		get {
			invokedUserHasSeenAppIntroductionGetter = true
			invokedUserHasSeenAppIntroductionGetterCount += 1
			return stubbedUserHasSeenAppIntroduction
		}
	}

	public var invokedUserHasRemoteAuthenticationSetter = false
	public var invokedUserHasRemoteAuthenticationSetterCount = 0
	public var invokedUserHasRemoteAuthentication: Bool?
	public var invokedUserHasRemoteAuthenticationList = [Bool]()
	public var invokedUserHasRemoteAuthenticationGetter = false
	public var invokedUserHasRemoteAuthenticationGetterCount = 0
	public var stubbedUserHasRemoteAuthentication: Bool! = false

	public var userHasRemoteAuthentication: Bool {
		set {
			invokedUserHasRemoteAuthenticationSetter = true
			invokedUserHasRemoteAuthenticationSetterCount += 1
			invokedUserHasRemoteAuthentication = newValue
			invokedUserHasRemoteAuthenticationList.append(newValue)
		}
		get {
			invokedUserHasRemoteAuthenticationGetter = true
			invokedUserHasRemoteAuthenticationGetterCount += 1
			return stubbedUserHasRemoteAuthentication
		}
	}

	public var invokedWipePersistedData = false
	public var invokedWipePersistedDataCount = 0

	public func wipePersistedData() {
		invokedWipePersistedData = true
		invokedWipePersistedDataCount += 1
	}
}
