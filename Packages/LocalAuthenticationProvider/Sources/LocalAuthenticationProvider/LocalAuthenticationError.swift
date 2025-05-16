/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public enum LocalAuthenticationError: Error {
	// User or system canceled the authentication
	case canceled
	// Authentication failed (invalid face / touch / optic)
	case authenticationFailed
	// User selected the fall back option
	case userFallback
	// User declined the biometric access
	case declined
	// lockout due to too many attempts
	case lockout
	// Other error
	case other(Error)
}
