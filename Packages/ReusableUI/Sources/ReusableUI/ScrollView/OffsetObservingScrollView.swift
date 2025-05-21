/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import SwiftUIIntrospect

// See https://www.swiftbysundell.com/articles/observing-swiftui-scrollview-content-offset/

public struct OffsetObservingScrollView<Content: View>: View {
	
	/// Which axis to show
	private var axes: Axis.Set
	
	/// Should we show the scroll indicators?
	private var showsIndicators = true
	
	/// Should the scrollview bounce?
	private var bounces = false
	
	/// The scroll offset
	@Binding private var scrollOffset: CGPoint
	
	/// The content
	@ViewBuilder private var content: () -> Content
	
	/// Create a Scrollview while observing its offset
	/// - Parameters:
	///   - axes: which axis to show?
	///   - showsIndicators: should we show the scroll indicators?
	///   - bounces: should the scrollview bounce?
	///   - offset: the binding scroll offset
	///   - content: the content for the scroll view
	public init(
		axes: Axis.Set = [.vertical],
		showsIndicators: Bool = true,
		bounces: Bool = false,
		offset: Binding<CGPoint>,
		content: @escaping () -> Content) {
		self.axes = axes
		self.showsIndicators = showsIndicators
		self.bounces = bounces
		self._scrollOffset = offset
		self.content = content
	}
	
	// The name of our coordinate space doesn't have to be
	// stable between view updates (it just needs to be
	// consistent within this view), so we'll simply use a
	// plain UUID for it:
	private let coordinateSpaceName = UUID()
	
	public var body: some View {
		ScrollView(axes, showsIndicators: showsIndicators) {
			PositionObservingView(
				coordinateSpace: .named(coordinateSpaceName),
				position: Binding(
					get: { scrollOffset },
					set: { newOffset in
						scrollOffset = CGPoint(
							x: -newOffset.x,
							y: -newOffset.y
						)
					}
				),
				content: content
			)
		}
		.coordinateSpace(name: coordinateSpaceName)
		.introspect(.scrollView, on: .iOS(.v15, .v16, .v17, .v18), customize: { view in
			view.bounces = bounces
		})
	}
}
