/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// A scrollview with a fixed box at the bottom 
struct ScrollViewWithFixedBottom<V1: View, V2: View>: View {
	
	/// The content for the scrollView
	@ViewBuilder let content: V1
	
	/// The content for the bottom View
	@ViewBuilder let bottomView: V2
	
	var body: some View {
		VStack {
			
			ScrollView {
				content
					.padding(.bottom, 50)
			}
			.overlay(ClearToBackgroundGradientView(), alignment: .bottom)
			
			bottomView
		}
	}
}

#Preview {
	ScrollViewWithFixedBottom(
		content: { Text(verbatim: "Top") },
		bottomView: { Text(verbatim: "Bottom") }
	)
}
