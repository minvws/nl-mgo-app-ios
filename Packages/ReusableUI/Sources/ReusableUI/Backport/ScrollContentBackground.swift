/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	/// Back ported version of scrollContentBackground
	/// - See: https://developer.apple.com/documentation/swiftui/view/scrollcontentbackground(_:)
	/// - Parameter visibility: the visibility
	/// - Returns: view
	@ViewBuilder func scrollContentBackground(_ visibility: Visibility) -> some View {
		if #available(iOS 16.0, *) {
			content
				.scrollContentBackground(visibility)
		} else {
			content
		}
	}
}
