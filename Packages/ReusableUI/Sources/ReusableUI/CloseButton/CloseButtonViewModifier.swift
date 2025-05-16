/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct CloseButtonViewModifier: ViewModifier {
	
	/// The action to perform when the users taps on the close button
	public var action: () -> Void
	
	/// Create a Close Button in a toolbar
	/// - Parameter content: the view to add the close button to
	/// - Returns: view with toolbar and close button
	public func body(content: Content) -> some View {
		content
			.toolbar(
				content: {
					ToolbarItemGroup(
						placement: .topBarTrailing,
						content: {
							CloseButton({
								action()
							})
							.buttonStyle(CloseButtonStyle())
						}
					)
				}
			)
	}
}

extension View {
	
	/// Add a toolbar with a close button to a view
	/// - Parameter action: the close action
	/// - Returns: view with toolbar and close button
	public func withToolbarCloseButton(_ action: @escaping () -> Void) -> some View {
		
		modifier(CloseButtonViewModifier(action: action))
	}
}
