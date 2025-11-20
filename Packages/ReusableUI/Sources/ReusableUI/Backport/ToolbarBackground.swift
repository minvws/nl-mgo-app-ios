/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public extension Backport where Content: View {
	
	enum Placement {
		case automatic
		case bottomBar
		case navigationBar
		case tabBar
	
		@available(iOS 16.0, *)
		public func cast() -> ToolbarPlacement {
		
			switch self {
				case .automatic:
					return .automatic
				case .bottomBar:
					return .bottomBar
				case .navigationBar:
					return .navigationBar
				case .tabBar:
					return .tabBar
			}
		}
	}
	
	/// Back ported version of toolbarBackground
	///  - See: https://developer.apple.com/documentation/swiftui/view/toolbarbackground(_:for:)
	/// - Parameter color: the background color
	/// - Parameter placement: where to place this?
	/// - Returns: View
	@ViewBuilder func toolbarBackground<S>(
		_ style: S,
		for placement: Placement
	) -> some View where S: ShapeStyle {
		if #available(iOS 16.0, *) {
			content
				.toolbarBackground(style, for: placement.cast())
				.toolbarBackground(.visible, for: placement.cast())
		} else {
			content
		}
	}
}
