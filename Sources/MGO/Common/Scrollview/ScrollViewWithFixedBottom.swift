/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	/// State vars for calculating scroll things
	@State private var scrollViewSize: CGSize = .zero
	@State private var contentSize: CGSize = .zero
	@State private var scrollable: Bool = false
	@State private var scrollOffset: CGPoint = .zero
	@State private var hasScrolledToBottom: Bool = false
	
	var body: some View {
		VStack {
			
			OffsetObservingScrollView(bounces: scrollable, offset: $scrollOffset) {
				content.readSize($contentSize)
			}
			.readSize($scrollViewSize)
		}
		.onChange(of: scrollOffset) { value in
			let margin: CGFloat = 10
			hasScrolledToBottom = (value.y + scrollViewSize.height + margin > contentSize.height)
		}
		.safeAreaInset(edge: VerticalEdge.bottom) {
			footer()
		}
	}
	
	/// The fixed footer part
	/// - Returns: the footer
	@ViewBuilder private func footer() -> some View {
		
		bottomView
			.when(scrollable && !hasScrolledToBottom, transform: { view in
				view
					.background(BlurView(style: .systemUltraThinMaterial).opacity(0.98).ignoresSafeArea())
			})
			.when(scrollable && !hasScrolledToBottom, transform: { view in
				
				VStack(spacing: 0) {
					NavigationDivider()
					view
				}
			})
			.onChange(of: contentSize) { _ in
				recalculateScrollable()
			}
			.onChange(of: scrollViewSize) { _ in
				recalculateScrollable()
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
			CallToActionButton("common.next")
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
