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
			.backportOnScrollPhaseChanged($isScrolling)
			.readSize($scrollViewSize)
			.onChange(of: isScrolling) { newValue in
				_ = logVerbose("SvFB: isScrolling: \(newValue)")
			}
			.preference(key: IsScrollingPreferenceKey.self, value: [isScrolling])
			
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

public struct BackportesOnSchrollPhaseChanged: ViewModifier {
	
	@Binding var isScrolling: Bool

	public func body(content: Content) -> some View {
		if #available(iOS 18.0, *) {
			content
				.onScrollPhaseChange { oldPhase, newPhase in
					isScrolling = newPhase.isScrolling
				}
		} else {
			content
			
		}
	}
}

extension View {
	public func backportOnScrollPhaseChanged(_ isScrolling: Binding<Bool>) -> some View {
		modifier(BackportesOnSchrollPhaseChanged(isScrolling: isScrolling))
	}
}

/*
 
 
 public struct BackportListSectionSpacing: ViewModifier {
	 
	 var spacing: CGFloat
	 
	 public func body(content: Content) -> some View {
		 
		 if #available(iOS 17.0, *) {
			 content
				 .listSectionSpacing(spacing)
		 } else {
			 content
		 }
	 }
 }

 extension View {
	 public func backportListSectionSpacing(_ spacing: CGFloat) -> some View {
		 modifier(BackportListSectionSpacing(spacing: spacing))
	 }
 }
 */
