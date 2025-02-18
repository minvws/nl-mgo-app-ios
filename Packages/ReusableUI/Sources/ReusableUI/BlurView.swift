/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

// Helper for blur effect
struct BlurView: UIViewRepresentable {
	
	/// The blur style (see https://developer.apple.com/documentation/uikit/uiblureffect/style)
	var style: UIBlurEffect.Style
	
	func makeUIView(context: Context) -> UIVisualEffectView {
		let view = UIVisualEffectView(effect: UIBlurEffect(style: style))
		return view
	}
	
	func updateUIView(_ uiView: UIVisualEffectView, context: Context) { /* No action required */ }
}
