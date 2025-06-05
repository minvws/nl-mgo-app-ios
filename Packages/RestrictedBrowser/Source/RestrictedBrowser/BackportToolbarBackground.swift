/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Back ported version of toolbarBackground
///  - See: https://developer.apple.com/documentation/swiftui/view/toolbarbackground(_:for:)
public struct BackportToolbarBackground: ViewModifier {
	
	public enum Placement {
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
	
	public var color: Color
	
	/// The desired placement, defaults to automatic
	public var placement: Placement = .automatic
	
	/// Get the view for this modifier
	/// - Parameter content: content
	/// - Returns: view with view modifier
	public func body(content: Content) -> some View {
		
		if #available(iOS 16.0, *) {
			content
				.toolbarBackground(color, for: placement.cast())
				.toolbarBackground(.visible, for: placement.cast())
		} else {
			content
		}
	}
}

extension View {
	
	/// Back ported version of toolbarBackground
	/// - Parameter color: the background color
	/// - Parameter placement: where to place this?
	/// - Returns: View
	public func backportToolbarBackground(_ color: Color, for placement: BackportToolbarBackground.Placement) -> some View {
		modifier(BackportToolbarBackground(color: color, placement: placement))
	}
}
