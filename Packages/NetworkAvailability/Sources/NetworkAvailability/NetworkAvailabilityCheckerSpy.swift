/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public class NetworkAvailabilityCheckerSpy: NetworkAvailabilityChecking, @unchecked Sendable {
	
	private let queue = DispatchQueue(label: "com.NetworkAvailabilityCheckerSpy.serialqueue.\(UUID().uuidString)")
	
	public var stubbedIsNetworkAvailable: Bool! = true
	public var invokedIsNetworkAvailable: Bool = false
	public var invokedIsNetworkAvailableCount: Int = 0
	
	public func isNetworkAvailable() async -> Bool {
		queue.sync {
			invokedIsNetworkAvailable = true
			invokedIsNetworkAvailableCount += 1
		}
		return stubbedIsNetworkAvailable
	}
}
