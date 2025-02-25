/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

// See https://www.swiftbysundell.com/articles/observing-swiftui-scrollview-content-offset/

struct OffsetObservingScrollView<Content: View>: View {
	var axes: Axis.Set = [.vertical]
	var showsIndicators = true
	var bounces = false
	@Binding var offset: CGPoint
	@ViewBuilder var content: () -> Content
	
	// The name of our coordinate space doesn't have to be
	// stable between view updates (it just needs to be
	// consistent within this view), so we'll simply use a
	// plain UUID for it:
	private let coordinateSpaceName = UUID()
	
	var body: some View {
		ScrollView(axes, showsIndicators: showsIndicators) {
			PositionObservingView(
				coordinateSpace: .named(coordinateSpaceName),
				position: Binding(
					get: { offset },
					set: { newOffset in
						offset = CGPoint(
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
