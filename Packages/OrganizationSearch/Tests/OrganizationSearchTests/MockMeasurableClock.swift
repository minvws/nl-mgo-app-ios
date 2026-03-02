/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

@testable import OrganizationSearch
import Foundation

/// A `MeasurableClock` that records how many times `now()` was called.
final class MockMeasurableClock: MeasurableClock, @unchecked Sendable {
	
	private(set) var nowCallCount = 0
	var fixedElapsed = "0.0 seconds"
	
	func now() -> any Sendable {
		nowCallCount += 1
		return Date()
	}
	
	func elapsed(since start: any Sendable) -> String {
		fixedElapsed
	}
}
