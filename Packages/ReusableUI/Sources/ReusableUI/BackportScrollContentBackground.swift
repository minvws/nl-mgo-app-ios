/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct BackportScrollContentBackground: ViewModifier {
	
	var visibility: Visibility
	
	public func body(content: Content) -> some View {
		
		if #available(iOS 16.0, *) {
			content
				.scrollContentBackground(visibility)
		} else {
			content
		}
	}
}

extension View {
	public func backportScrollContentBackground(_ visibility: Visibility) -> some View {
		modifier(BackportScrollContentBackground(visibility: visibility))
	}
}
