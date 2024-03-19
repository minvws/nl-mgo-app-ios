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
	
	func authenticate(localizedReason: String, localizedFallbackTitle: String) async throws -> Bool
}

public enum LocalAuthenticationError: Error {
	case canceled
	case authenticationFailed
	case userFallback
	case declined
	case lockout
	case other(Error)
}

public class LocalAuthenticationProvider: LocalAuthenticationProviderProtocol {
	
	/// Initializer
	public init() { }

	/// Get the biometric type for this device
	public var biometricType: () -> LocalAuthentication.BiometricType = {
		return LAContext().biometricType
	}
	
	@discardableResult
	public func authenticate(localizedReason: String, localizedFallbackTitle: String) async throws -> Bool {
		
		let context = LAContext()
		context.localizedFallbackTitle = localizedFallbackTitle
		
		do {
			return try await context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: localizedReason)
			
		} catch LAError.authenticationFailed {
			throw LocalAuthenticationError.authenticationFailed
			
		} catch LAError.userCancel, LAError.appCancel, LAError.systemCancel {
			throw LocalAuthenticationError.canceled
		
		} catch LAError.userFallback {
			throw LocalAuthenticationError.userFallback
			
		} catch LAError.biometryNotEnrolled, LAError.touchIDNotAvailable {
			throw LocalAuthenticationError.declined
			
		} catch LAError.biometryLockout, LAError.touchIDLockout {
			throw LocalAuthenticationError.lockout

		} catch {
			throw LocalAuthenticationError.other(error)
		}
	}
}
