/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A scrollview with a fixed box at the bottom
struct ScrollViewWithDivider<V1: View>: View {
	
	/// The content for the scrollView
	@ViewBuilder let content: V1
	
	/// Are we scrolling
	@State private var isScrolling: Bool = false
	
	var body: some View {
		
		ScrollView {
			content
		}
		.backportOnScrollPhaseChanged($isScrolling)
		.onChange(of: isScrolling) { newValue in
			_ = logVerbose("SvWD: isScrolling: \(newValue)")
		}
		.preference(key: IsScrollingPreferenceKey.self, value: [isScrolling])
	}
}

#Preview {
	ScrollViewWithDivider {
		Text(verbatim: "Top")
	}
	.padding(16)
}
