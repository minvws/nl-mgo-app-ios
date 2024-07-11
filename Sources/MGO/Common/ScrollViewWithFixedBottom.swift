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
	
	var body: some View {
		VStack {
			
			ScrollView {
				content.readSize($contentSize)
			}
			.readSize($scrollViewSize)
			
			bottomView
				// Change the background color of the bottom view if we should scroll
				.background(scrollable ? theme.backgroundSecondary : theme.backgroundPrimary)
				// Only apply the shadow if we should scroll
				.when(scrollable) { view in
					view
						.shadow(color: theme.contentPrimary.opacity(0.05), radius: 7, x: 0, y: -6)
						.shadow(color: theme.contentPrimary.opacity(0.06), radius: 3, x: 0, y: 0)
				}
				.onChange(of: contentSize) { _ in
					recalculateScrollable()
				}
				.onChange(of: scrollViewSize) { _ in
					recalculateScrollable()
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
