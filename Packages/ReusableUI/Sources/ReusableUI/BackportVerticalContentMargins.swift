/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct BackportVerticalContentMargins: ViewModifier {
	
	var margin: CGFloat
	
	public func body(content: Content) -> some View {
		
		if #available(iOS 17.0, *) {
			content
				.contentMargins(.vertical, margin)
		} else {
			content
		}
	}
}

extension View {
	public func backportVerticalContentMargins(_ margin: CGFloat) -> some View {
		modifier(BackportVerticalContentMargins(margin: margin))
	}
}
