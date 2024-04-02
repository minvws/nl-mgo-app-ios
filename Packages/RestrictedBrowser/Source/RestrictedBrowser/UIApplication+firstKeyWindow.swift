/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

extension UIApplication {
	
	// get the first key window in a multi window environment
	// See https://sarunw.com/posts/how-to-get-root-view-controller/
	var firstKeyWindow: UIWindow? {
		return UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first(where: { $0.activationState == .foregroundActive })?
			.keyWindow
	}
}
