/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// The levels of haptic feedback
public enum HapticFeedback {
	case light
	case medium
	case heavy
}

/// A view modifier that gives haptic feedback
struct HapticFeedbackModifier: ViewModifier {
	
	/// The feedback level
	public let feedback: HapticFeedback
	
	/// Give haptic feedback
	/// - Parameter content: the content
	/// - Returns: feedback on press
	public func body(content: Content) -> some View {
		content
			.onLongPressGesture(
				minimumDuration: 0,
				perform: { /* The action to perform when a long press is recognized. Nothing to do here */ },
				onPressingChanged: { pressing in
					if pressing {
						switch feedback {
							case .light:
								Haptic.light()
							case .medium:
								Haptic.medium()
							case .heavy:
								Haptic.heavy()
						}
					}
				}
			)
	}
}

extension View {
	
	/// Give haptic feedback on press
	/// - Parameter feedback: the level of feedback ( light, medium, heavy)
	/// - Returns: modified view.
	public func hapticFeedback(_ feedback: HapticFeedback) -> some View {
		self.modifier(HapticFeedbackModifier(feedback: feedback))
	}
}
