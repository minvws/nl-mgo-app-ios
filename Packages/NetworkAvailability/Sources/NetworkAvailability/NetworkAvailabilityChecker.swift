/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation
import Network

public protocol NetworkAvailabilityChecking: Sendable {
	
	/// Do we have a network available?
	/// - Returns: True if we have a network available
	func isNetworkAvailable() async -> Bool
}

final public class NetworkAvailabilityChecker: NetworkAvailabilityChecking, @unchecked Sendable {
	
	public init() { /* Pulbic initializer */ }
	
	/// Do we have a network available?
	/// - Returns: True if we have a network available
	public func isNetworkAvailable() async -> Bool {
		await withCheckedContinuation { continuation in
			let monitor = NWPathMonitor()
			let queue = DispatchQueue(label: "NetworkMonitor")
			monitor.pathUpdateHandler = { path in
				continuation.resume(returning: path.status == .satisfied)
				monitor.cancel()
			}
			monitor.start(queue: queue)
		}
	}
}
