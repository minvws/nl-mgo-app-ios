/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class LocalAuthenticationProviderSpy: LocalAuthenticationProviderProtocol {
	
	public init() { /* Public initializer needed for public access */ }

	public var invokedBiometricTypeSetter = false
	public var invokedBiometricTypeSetterCount = 0
	public var invokedBiometricType: (() -> LocalAuthentication.BiometricType)?
	public var invokedBiometricTypeList = [() -> LocalAuthentication.BiometricType]()
	public var invokedBiometricTypeGetter = false
	public var invokedBiometricTypeGetterCount = 0
	public var stubbedBiometricType: (() -> LocalAuthentication.BiometricType)!

	public var biometricType: () -> LocalAuthentication.BiometricType {
		set {
			invokedBiometricTypeSetter = true
			invokedBiometricTypeSetterCount += 1
			invokedBiometricType = newValue
			invokedBiometricTypeList.append(newValue)
		}
		get {
			invokedBiometricTypeGetter = true
			invokedBiometricTypeGetterCount += 1
			return stubbedBiometricType
		}
	}

	public var invokedAuthenticate = false
	public var invokedAuthenticateCount = 0
	public var invokedAuthenticateParameters: (localizedReason: String, Void)?
	public var invokedAuthenticateParametersList = [(localizedReason: String, Void)]()
	public var stubbedAuthenticated = false
	public var stubbedLocalAuthenticationError: LocalAuthenticationError?

	private let queue = DispatchQueue(label: "com.LocalAuthenticationProviderSpy.serialqueue.\(UUID().uuidString)")
	
	public func authenticate(localizedReason: String, localizedFallbackTitle: String) async throws -> Bool {
		
		queue.sync {
			self.invokedAuthenticate = true
			self.invokedAuthenticateCount += 1
			self.invokedAuthenticateParameters = (localizedReason, ())
			self.invokedAuthenticateParametersList.append((localizedReason, ()))
		}
		if let error = stubbedLocalAuthenticationError {
			throw error
		}
		return stubbedAuthenticated
	}
}
