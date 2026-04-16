/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {

	/// Back ported version of `presentationBackground(_:)`.
	/// - See: https://developer.apple.com/documentation/swiftui/view/presentationbackground(_:)-8ewpb
	/// - Parameter background: The shape style to use as the presentation background.
	/// - Returns: A view with the presentation background applied on iOS 16.4+; unchanged on earlier versions.
	@ViewBuilder func presentationBackground<S: ShapeStyle>(_ background: S) -> some View {
		if #available(iOS 16.4, *) {
			content.presentationBackground(background)
		} else {
			content
		}
	}
}
