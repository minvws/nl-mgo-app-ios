/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import UIKit
import IOSSecuritySuite

public protocol JailBreakProtocol {
	
	/// Is this device jail broken?
	@MainActor func isJailBroken() -> Bool
}

public class JailBreakDetector: JailBreakProtocol {
	
	public init() { /* Public initializer needed for public access */ }
	
	/// Is this device jail broken?
	@MainActor public func isJailBroken() -> Bool {
		
		let jailbreakStatus = IOSSecuritySuite.amIJailbrokenWithFailedChecks()
		return jailbreakStatus.jailbroken
	}
}
