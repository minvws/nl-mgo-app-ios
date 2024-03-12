/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import LocalAuthentication
import MGOFoundation

enum LocalAuthentication {
	
	/// The various Biometric types
	enum BiometricType: String, Equatable {
		case none
		case touchID
		case faceID
		case opticID
		case unknown
	}
}

extension LAContext {
	
	/// Get the biometric type for this device
	var biometricType: LocalAuthentication.BiometricType {
		var error: NSError?

		guard self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
			logError("MGO: Can't evaluate LAPolicy", error?.localizedDescription ?? "")
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
