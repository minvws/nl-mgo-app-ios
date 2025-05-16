/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

// See https://www.swiftbysundell.com/articles/observing-swiftui-scrollview-content-offset/

/// A view that observes the position
public struct PositionObservingView<Content: View>: View {
	
	/// The name space
	var coordinateSpace: CoordinateSpace
	
	/// The position
	@Binding var position: CGPoint
	
	/// The content
	@ViewBuilder var content: () -> Content
	
	public var body: some View {
		content()
			.background(GeometryReader { geometry in
				Color.clear.preference(
					key: PreferenceKey.self,
					value: geometry.frame(in: coordinateSpace).origin
				)
			})
			.onPreferenceChange(PreferenceKey.self) { position in
				self.position = position
			}
	}
}

private extension PositionObservingView {
	
	struct PreferenceKey: SwiftUI.PreferenceKey {
		
		static var defaultValue: CGPoint { .zero }

		static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
			// No-op
		}
	}
}
