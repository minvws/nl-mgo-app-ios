/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	/// Back ported version of listSectionSpacing
	/// - See: https://developer.apple.com/documentation/swiftui/view/listsectionspacing(_:)
	/// - Parameter spacing: the spacing between adjacent sections
	/// - Returns: view
	@MainActor @ViewBuilder func listSectionSpacing(_ spacing: CGFloat) -> some View {
		if #available(iOS 17.0, *) {
			content
				.listSectionSpacing(spacing)
		} else {
			content
				.introspect(.list, on: .iOS(.v15)) { tableView in
					tableView.sectionHeaderHeight = 0
					tableView.sectionHeaderHeight = 0
				}
		}
	}
}
