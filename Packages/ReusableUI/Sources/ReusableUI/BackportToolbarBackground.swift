/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct BackportToolbarBackground: ViewModifier {
	
	// The Theme
	@Environment(\.theme) var theme
	
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
	public func backportToolbarBackground() -> some View {
		modifier(BackportToolbarBackground())
	}
}
