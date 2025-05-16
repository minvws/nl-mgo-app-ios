/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import Foundation

public func delay(_ delayInSeconds: Double, action: @escaping () -> Void) {
	
	guard delayInSeconds > 0 else {
		action()
		return
	}
	
	DispatchQueue.main.asyncAfter(deadline: .now() + delayInSeconds) {
		action()
	}
}
