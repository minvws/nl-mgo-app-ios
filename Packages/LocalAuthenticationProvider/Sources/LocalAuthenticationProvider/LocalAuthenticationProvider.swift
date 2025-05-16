/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import LocalAuthentication
import Foundation

public protocol LocalAuthenticationProviderProtocol {
	
	/// Get the biometric type for this device
	var biometricType: () -> LocalAuthentication.BiometricType { get set }
	
	/// Authenticate
	/// - Parameters:
	///   - localizedReason: the label the show for touch ID for login
	///   - localizedFallbackTitle: the label to show for face ID as fallback
	/// - Returns: True if the user was authenticated
	func authenticate(localizedReason: String, localizedFallbackTitle: String) async throws -> Bool
}

public class LocalAuthenticationProvider: LocalAuthenticationProviderProtocol {
	
	/// Create a local authentication provider
	public init() { /* Public initializer needed for public access */ }

	/// Get the biometric type for this device
	public var biometricType: () -> LocalAuthentication.BiometricType = {
		return LAContext().biometricType
	}
	
	/// Authenticate
	/// - Parameters:
	///   - localizedReason: the label the show for touch ID for login
	///   - localizedFallbackTitle: the label to show for face ID as fallback
	/// - Returns: True if the user was authenticated
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
