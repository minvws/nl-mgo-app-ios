/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Back ported version of listSectionSpacing
/// - See: https://developer.apple.com/documentation/swiftui/view/listsectionspacing(_:)
public struct BackportListSectionSpacing: ViewModifier {
	
	/// the spacing between adjacent sections
	public var spacing: CGFloat
	
	/// Get the view for this modifier
	/// - Parameter content: content
	/// - Returns: view with view modifier
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
	
	/// Back ported version of listSectionSpacing
	/// - See: https://developer.apple.com/documentation/swiftui/view/listsectionspacing(_:)
	/// - Parameter spacing: the spacing between adjacent sections
	/// - Returns: view
	public func backportListSectionSpacing(_ spacing: CGFloat) -> some View {
		modifier(BackportListSectionSpacing(spacing: spacing))
	}
}
