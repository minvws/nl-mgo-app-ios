/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A scrollview with a fixed box at the bottom 
struct ScrollViewWithFixedBottom<V1: View, V2: View>: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The content for the scrollView
	@ViewBuilder let content: V1
	
	/// The content for the bottom View
	@ViewBuilder let bottomView: V2
	
	@State private var scrollViewSize: CGSize = .zero
	@State private var contentSize: CGSize = .zero
	@State private var scrollable: Bool = false
	@State private var isScrolling: Bool = false
	
	var body: some View {
		VStack {
			
			ScrollView {
				content.readSize($contentSize)
			}
			.introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18), customize: { view in
					view.bounces = scrollable
			})
			.backportOnScrollPhaseChanged($isScrolling)
			.readSize($scrollViewSize)
			.preference(key: IsScrollingPreferenceKey.self, value: [isScrolling])
		}
		.safeAreaInset(edge: VerticalEdge.bottom) {
			
			VStack(spacing: 0) {
				
				if scrollable || isScrolling {
					NavigationDivider()
				}
				
				bottomView
					.background(scrollable ? theme.backgroundSecondary.opacity(0.25) : theme.backgroundPrimary)
					.background(.ultraThinMaterial)
					.onChange(of: contentSize) { _ in
						recalculateScrollable()
					}
					.onChange(of: scrollViewSize) { _ in
						recalculateScrollable()
					}
			}
		}
	}
	
	/// Recalculate if we should scroll
	private func recalculateScrollable() {
		scrollable = scrollViewSize.height < contentSize.height
	}
}

#Preview {
	ScrollViewWithFixedBottom(
		content: { Text(verbatim: "Top") },
		bottomView: { Button(
			action: { },
			label: {
				CallToActionButton("common.next")
			}
		).padding(16)
		}
	)
}
