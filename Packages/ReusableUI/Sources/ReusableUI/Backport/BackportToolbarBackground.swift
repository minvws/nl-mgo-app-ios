/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Back ported version of toolbarBackground
public struct BackportToolbarBackground: ViewModifier {
	
	// The Theme
	@Environment(\.theme) var theme
	
	/// Get the view for this modifier
	/// - Parameter content: content
	/// - Returns: view with view modifier
	public func body(content: Content) -> some View {
		
		if #available(iOS 16.0, *) {
			content
				.toolbarBackground(theme.backgroundSecondary, for: .tabBar)
				.toolbarBackground(.visible, for: .tabBar)
		} else {
			content
		}
	}
}

extension View {
	
	/// Back ported version of toolbarBackground
	/// - Returns: View
	public func backportToolbarBackground() -> some View {
		modifier(BackportToolbarBackground())
	}
}
