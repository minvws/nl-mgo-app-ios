/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

/// Delay an action
/// - Parameters:
///   - delayInSeconds: the number of seconds to delay
///   - action: the action to perform
@MainActor public func delay(_ delayInSeconds: Double, action: @escaping () -> Void) {
	
	guard delayInSeconds > 0 else {
		action()
		return
	}
	
	Task { @MainActor in
		try await Task.sleep(nanoseconds: UInt64(delayInSeconds) * 1_000_000_000)
		action()
	}
}
