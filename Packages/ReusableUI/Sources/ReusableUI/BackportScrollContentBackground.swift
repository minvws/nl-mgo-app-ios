/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
