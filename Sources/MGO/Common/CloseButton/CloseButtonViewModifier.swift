/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

public struct CloseButtonViewModifier: ViewModifier {
	
	/// The action to perform when the users taps on the close button
	var action: () -> Void
	
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
