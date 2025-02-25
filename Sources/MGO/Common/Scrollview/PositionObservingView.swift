/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct PositionObservingView<Content: View>: View {
	var coordinateSpace: CoordinateSpace
	@Binding var position: CGPoint
	@ViewBuilder var content: () -> Content
	
	var body: some View {
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
