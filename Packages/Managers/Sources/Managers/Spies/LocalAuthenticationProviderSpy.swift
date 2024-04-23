/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class LocalAuthenticationProviderSpy: LocalAuthenticationProviderProtocol {

	public init() { }
	
	public var invokedBiometricTypeGetter = false
	public var invokedBiometricTypeGetterCount = 0
	public var stubbedBiometricType: (() -> LocalAuthentication.BiometricType)!

	public var biometricType: () -> LocalAuthentication.BiometricType {
		invokedBiometricTypeGetter = true
		invokedBiometricTypeGetterCount += 1
		return stubbedBiometricType
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
