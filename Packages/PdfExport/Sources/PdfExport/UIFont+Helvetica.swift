/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension UIFont {
	
	static func helvetica(_ pointSize: CGFloat) -> UIFont? {
		UIFont(
			name: "Helvetica",
			size: pointSize
		)
	}
	
	static func helveticaBold(_ pointSize: CGFloat) -> UIFont? {
		UIFont(
			name: "Helvetica-Bold",
			size: pointSize
		)
	}
}
