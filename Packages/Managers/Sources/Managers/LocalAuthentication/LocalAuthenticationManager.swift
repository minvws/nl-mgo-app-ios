/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import LocalAuthentication
import Foundation

public protocol LocalAuthenticationProviderProtocol {
	
	/// Get the biometric type for this device
	var biometricType: () -> LocalAuthentication.BiometricType { get }
	
	func xxx()
}

public class LocalAuthenticationProvider: LocalAuthenticationProviderProtocol {
	
	public init() { }
	
	public func xxx() {
		
	}
	
	/// Get the biometric type for this device
	public var biometricType: () -> LocalAuthentication.BiometricType = {
		return LAContext().biometricType
	}
}

public class LocalAuthenticationProviderSpy: LocalAuthenticationProviderProtocol {

	public var invokedBiometricTypeGetter = false
	public var invokedBiometricTypeGetterCount = 0
	public var stubbedBiometricType: (() -> LocalAuthentication.BiometricType)!

	public var biometricType: () -> LocalAuthentication.BiometricType {
		invokedBiometricTypeGetter = true
		invokedBiometricTypeGetterCount += 1
		return stubbedBiometricType
	}

	public var invokedXxx = false
	public var invokedXxxCount = 0

	public func xxx() {
		invokedXxx = true
		invokedXxxCount += 1
	}
	
	public init() { }
}
