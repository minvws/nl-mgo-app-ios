/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct CloseButtonViewModifier: ViewModifier {
	
	/// The action to perform when the users taps on the close button
	public var action: () -> Void
	
	/// Should we use glass style?
	public var glassStyle: Bool = false
	
	/// Create a Close Button in a toolbar
	/// - Parameter content: the view to add the close button to
	/// - Returns: view with toolbar and close button
	public func body(content: Content) -> some View {
		content
			.toolbar(content: toolbarContent)
	}
	
	/// The content for the toolbar
	/// - Returns: the toolbar content
	@ToolbarContentBuilder private func toolbarContent() -> some ToolbarContent {
		
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {
				if glassStyle {
					if #available(iOS 26.0, *) {
						Button(role: .close) { action() }
					}
				} else {
					CloseButton({
						action()
					})
					.buttonStyle(CloseButtonStyle())
				}
			}
		)
	}
}

extension View {
	
	/// Add a toolbar with a close button to a view
	/// - Parameter action: the close action
	/// - Returns: view with toolbar and close button
	public func withToolbarCloseButton(
		_ glassStyle: Bool = false,
		action: @escaping () -> Void
	) -> some View {
		
		modifier(CloseButtonViewModifier(action: action, glassStyle: glassStyle))
	}
}
