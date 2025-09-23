/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class OSVersionCheckerSpy: OSVersionProtocol {

	public init() {
		// Public initializer
	}
	
	public var invokedAvailable = false
	public var invokedAvailableCount = 0
	public var invokedAvailableParameters: (version: OSVersion, Void)?
	public var invokedAvailableParametersList = [(version: OSVersion, Void)]()
	public var stubbedAvailableResult: Bool! = false

	public func available(version: OSVersion) -> Bool {
		invokedAvailable = true
		invokedAvailableCount += 1
		invokedAvailableParameters = (version, ())
		invokedAvailableParametersList.append((version, ()))
		return stubbedAvailableResult
	}
}

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
