/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A scrollview with a fixed box at the bottom 
struct ScrollViewWithFixedBottom<V1: View, V2: View>: View {
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// The content for the scrollView
	@ViewBuilder let content: V1
	
	/// The content for the bottom View
	@ViewBuilder let bottomView: V2
	
	/// State vars for calculating scroll things
	@State private var scrollViewSize: CGSize = .zero
	@State private var contentSize: CGSize = .zero
	@State private var scrollable: Bool = false
	@State private var scrollOffset: CGPoint = .zero
	@State private var hasScrolledToBottom: Bool = false
	
	var body: some View {
		OffsetObservingScrollView(bounces: scrollable, offset: $scrollOffset) {
			content
				.readSize($contentSize)
		}
		.readSize($scrollViewSize)
		.onChange(of: scrollOffset) { value in
			updateScrollState(offset: value)
		}
		.onChange(of: contentSize) { _ in
			recalculateScrollable()
			updateScrollState(offset: scrollOffset)
		}
		.onChange(of: scrollViewSize) { _ in
			recalculateScrollable()
			updateScrollState(offset: scrollOffset)
		}
		.safeAreaInset(edge: VerticalEdge.bottom) {
			footer()
		}
	}
	
	/// The fixed footer part
	/// - Returns: the footer
	@ViewBuilder private func footer() -> some View {
		let showDivider = scrollable && !hasScrolledToBottom
		
		VStack(spacing: 0) {
			NavigationDivider()
				.opacity(showDivider ? 1 : 0)
			bottomView
		}
		.background(
			BlurView(style: .systemUltraThinMaterial)
				.opacity(showDivider ? 0.98 : 0)
				.ignoresSafeArea()
		)
	}
	
	/// Update scroll state to determine if scrolled to bottom
	private func updateScrollState(offset: CGPoint) {
		let margin: CGFloat = 10
		let newValue = (offset.y + scrollViewSize.height + margin > contentSize.height)
		if hasScrolledToBottom != newValue {
			hasScrolledToBottom = newValue
		}
	}
	
	/// Recalculate if we should scroll
	private func recalculateScrollable() {
		scrollable = scrollViewSize.height < contentSize.height
	}
}

#Preview {
	
	let button = Button(
		action: { /* No Action for preview */ },
		label: {
			CallToActionButton(
				"common.next",
				style: .solid(rounded: true, narrow: false)
			)
		}
	)
		.padding(16)
	
	ScrollViewWithFixedBottom(
		content: { Text(verbatim: "Top") },
		bottomView: {
			button
		}
	)
}
