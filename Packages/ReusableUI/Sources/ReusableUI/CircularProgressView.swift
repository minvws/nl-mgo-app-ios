/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct CircularProgressView: View {
	
	/// The progress value (0 ... 1)
	@Binding private var progress: Double
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The width of the progress line
	public var lineWidth: CGFloat
	
	/// Initializer
	/// - Parameters:
	///   - progress: the progress
	///   - lineWidth: the line width
	public init(progress: Binding<Double>, lineWidth: CGFloat = 6) {
		self._progress = progress
		self.lineWidth = lineWidth
	}
	
	public var body: some View {
		ZStack {
			Circle()
				.stroke(
					theme.backgroundTertiary,
					lineWidth: lineWidth
				)
			Circle()
				.trim(from: 0, to: progress)
				.stroke(
					theme.interactionPrimaryDefaultBackground,
					style: StrokeStyle(
						lineWidth: lineWidth,
						lineCap: .round
					)
				)
				.rotationEffect(.degrees(-90))
				.animation(.linear(duration: 1.0).repeatForever(autoreverses: false), value: progress)
		}
	}
}

#Preview {
	CircularProgressView(progress: .constant(0.25), lineWidth: 6)
		.frame(width: 50, height: 50)
}
