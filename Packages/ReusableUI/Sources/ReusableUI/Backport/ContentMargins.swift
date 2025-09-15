/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	/// Back ported version of the content margins
	/// - See: https://developer.apple.com/documentation/swiftui/view/contentmargins(_:for:)
	/// - Parameters:
	///   - margin: the margin to apply
	///   - edges: the edges to apply the margin to (defaults to .vertical)
	/// - Returns: View
	@ViewBuilder func contentMargins(_ margin: CGFloat, edges: Edge.Set = .vertical) -> some View {
		if #available(iOS 17.0, *) {
			content
				.contentMargins(edges, margin)
		} else {
			content
		}
	}
}
