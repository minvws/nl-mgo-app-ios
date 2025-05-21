/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

// Helper for blur effect
public struct BlurView: UIViewRepresentable {
	
	/// The blur style (see https://developer.apple.com/documentation/uikit/uiblureffect/style)
	var style: UIBlurEffect.Style
	
	/// Create a BlurView
	/// - Parameter style: the blur style
	public init(style: UIBlurEffect.Style) {

		self.style = style
	}
	
	// MARK: - UIViewRepresentable -
	
	public func makeUIView(context: Context) -> UIVisualEffectView {
		
		let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
		return view
	}
	
	public func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
		/* No action required */
	}
}
