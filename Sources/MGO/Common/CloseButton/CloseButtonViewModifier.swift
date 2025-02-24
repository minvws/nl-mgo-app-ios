/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

public struct CloseButtonViewModifier: ViewModifier {
	
	var action: () -> Void

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
	
	public func withToolbarCloseButton(_ action: @escaping () -> Void) -> some View {
		
		modifier(CloseButtonViewModifier(action: action))
	}
}
