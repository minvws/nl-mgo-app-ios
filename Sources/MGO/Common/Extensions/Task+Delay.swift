/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

extension Task where Failure == Error {
	
	/// Delay a task
	/// - Parameters:
	///   - delayInterval: the delay interval in seconds
	///   - priority: the priority of the task
	///   - operation: the delayed operation
	/// - Returns: delayed task
	@discardableResult static func delayed(
		byTimeInterval delayInterval: TimeInterval,
		priority: TaskPriority? = nil,
		operation: @escaping @Sendable () async throws -> Success
	) -> Task {
		Task(priority: priority) {
			let delay = UInt64(delayInterval * 1_000_000_000)
			try await Task<Never, Never>.sleep(nanoseconds: delay)
			return try await operation()
		}
	}
}
