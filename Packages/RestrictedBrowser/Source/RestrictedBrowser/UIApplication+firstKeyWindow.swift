/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

extension UIApplication {
	
	// get the first key window in a multi window environment
	// See https://sarunw.com/posts/how-to-get-root-view-controller/
	public var firstKeyWindow: UIWindow? {
		return UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.first(where: { $0.activationState == .foregroundActive })?
			.keyWindow
	}
}
