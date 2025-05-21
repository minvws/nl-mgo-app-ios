/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct BackportListSectionSpacing: ViewModifier {
	
	var spacing: CGFloat
	
	public func body(content: Content) -> some View {
		
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

extension View {
	public func backportListSectionSpacing(_ spacing: CGFloat) -> some View {
		modifier(BackportListSectionSpacing(spacing: spacing))
	}
}
