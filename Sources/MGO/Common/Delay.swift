/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
