/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class JailBreakProtocolSpy: JailBreakProtocol {
	
	public init() { /* Public init for access outside the package */ }
	
	public var invokedIsJailBroken = false
	public var invokedIsJailBrokenCount = 0
	public var stubbedIsJailBrokenResult: Bool! = false
	
	public func isJailBroken() -> Bool {
		invokedIsJailBroken = true
		invokedIsJailBrokenCount += 1
		return stubbedIsJailBrokenResult
	}
}
