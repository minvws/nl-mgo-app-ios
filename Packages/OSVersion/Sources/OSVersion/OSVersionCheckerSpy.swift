/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public struct OSVersionCheckerTrue: OSVersionProtocol, Sendable {
	
	public init() { /* Public initializer for public access */ }
	
	public func available(version: OSVersion) -> Bool {
		return true
	}
}

public struct OSVersionCheckerFalse: OSVersionProtocol, Sendable {
	
	public init() { /* Public initializer for public access */ }
	
	public func available(version: OSVersion) -> Bool {
		return false
	}
}
