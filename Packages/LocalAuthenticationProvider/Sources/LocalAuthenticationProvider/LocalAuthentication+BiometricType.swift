/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import LocalAuthentication

public enum LocalAuthentication {
	
	/// The various Biometric types
	public enum BiometricType: String, Equatable {
		case none
		case touchID
		case faceID
		case opticID
		case unknown
	}
}

extension LAContext {
	
	/// Get the biometric type for this device
	public var biometricType: LocalAuthentication.BiometricType {
		var error: NSError?

		guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
			print("MGO: Can't evaluate LAPolicy", error?.localizedDescription ?? "") // swiftlint:disable:this disable_print
			return .none
		}
		
		switch self.biometryType {
			case .none:
				return .none
			case .touchID:
				return .touchID
			case .faceID:
				return .faceID
			case .opticID:
				return .opticID
			@unknown default:
				return .unknown
		}
	}
}
