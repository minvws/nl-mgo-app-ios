/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A small box for displaying a single digit of a pincode
struct PinCodeBoxView: View {
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Circle {
			static let border: CGFloat = 2
			static let size: CGFloat = 32
		}
	}
	
	/// All possible states of the box
	enum State {
		// The box is empty.
		case empty
		// The box has focus, ready for input
		case focus
		// The user has just entered input
		case filling
		// The box is filled
		case filled
		// The box is filled, but with an invalid code
		case error
		
		/// Get the voice over value
		/// - Returns: the voice over value
		func accessibilityVoiceOverValue() -> String {
			switch self {
				case .empty:
					String(localized: "pincode.empty.voiceover")
				case .focus:
					String(localized: "pincode.focus.voiceover")
				case .filling:
					String(localized: "pincode.filled.voiceover")
				case .filled:
					String(localized: "pincode.filled.voiceover")
				case .error:
					String(localized: "pincode.error.voiceover")
			}
		}
	}
	
	/// The state of the box
	@Binding var state: State
	
	/// The color of the border for the various states
	var borderColor: Color {
		if state == .error {
			return theme.sentimentCritical
		} else {
			return theme.interactionTertiaryDefaultText
		}
	}
	
	var fill: Color {
		switch state {
			case .empty, .focus:
				.clear
			case .filling, .filled:
				theme.interactionTertiaryDefaultText
			case .error:
				theme.sentimentCritical
		}
	}
	
	var body: some View {

		Circle()
			.strokeBorder(borderColor, lineWidth: ViewTraits.Circle.border)
			.background(Circle().fill(fill))
			.frame(width: ViewTraits.Circle.size, height: ViewTraits.Circle.size)
			.onAppear {
				if state == .filling {
					withAnimation(Animation.linear(duration: 0.05)) {
						state = .filled
					}
				}
			}
	}
}

#Preview {
	
	ZStack {
		Theme().backgroundPrimary
		HStack(spacing: 12) {
			PinCodeBoxView(state: .constant(.filled))
			PinCodeBoxView(state: .constant(.filling))
			PinCodeBoxView(state: .constant(.focus))
			PinCodeBoxView(state: .constant(.empty))
			PinCodeBoxView(state: .constant(.error))
		}
	}
}
