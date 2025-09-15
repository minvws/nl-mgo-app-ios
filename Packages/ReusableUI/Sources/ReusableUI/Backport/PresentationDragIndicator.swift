/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	/// Back ported version of presentationDragIndicator
	/// - See: https://developer.apple.com/documentation/swiftui/view/presentationdragindicator(_:)
	/// - Parameter visibility: Visibility
	/// - Returns: view with back ported presentationDragIndicator
	@ViewBuilder func presentationDragIndicator(_ visibility: Visibility) -> some View {
		if #available(iOS 16.0, *) {
			content
				.presentationDragIndicator(visibility)
		} else {
			content
		}
	}
}
