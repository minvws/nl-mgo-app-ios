/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A small box for displaying a single digit of a pincode
struct AccessCodeBoxView: View {
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Circle {
			static let small: CGFloat = 16
			static let big: CGFloat = 24
		}
		enum Box {
			static let radius: CGFloat = 5
			static let aspectRatio: CGFloat = 0.80
		}
	}
	
	/// All posible states of the box
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
					String(localized: "acccescode_box_voiceover_empty")
				case .focus:
					String(localized: "acccescode_box_voiceover_focus")
				case .filling:
					String(localized: "acccescode_box_voiceover_filled")
				case .filled:
					String(localized: "acccescode_box_voiceover_filled")
				case .error:
					String(localized: "acccescode_box_voiceover_error")
			}
		}
	}
	
	/// The state of the box
	@Binding var state: State
	
	/// The color of the border for the various states
	var borderColor: Color {
		switch state {
			case .focus, .filling:
			colorScheme == .light ? theme.actionPrimaryBackground : theme.actionSecondaryBackground
			case .empty, .filled: theme.input
			case .error: theme.notificationError
		}
	}
	
	/// The width of the border for the various states
	var borderWidth: CGFloat {
		switch state {
			case .empty, .filled: 2
			case .focus, .filling, .error: 3
		}
	}
	
	/// The height of the border for the various states
	var inset: CGFloat {
		switch state {
			case .empty, .filled, .error: 3
			case .focus, .filling: 0
		}
	}
	
	/// The inside of the box for the various states
	@ViewBuilder var icon: some View {
		switch state {
			case .empty:
				EmptyView()
			
			case .focus:
				EmptyView()
			
			case .filling:
				Circle()
					.foregroundStyle(colorScheme == .light ? theme.actionPrimaryBackground : theme.actionSecondaryBackground)
					.frame(width: ViewTraits.Circle.big, height: ViewTraits.Circle.big)
			
			case .filled:
				Circle()
					.foregroundStyle(colorScheme == .light ? theme.actionPrimaryBackground : theme.actionSecondaryBackground)
					.frame(width: ViewTraits.Circle.small, height: ViewTraits.Circle.small)
			
			case .error:
				Circle()
					.foregroundStyle(theme.notificationError)
					.frame(width: ViewTraits.Circle.small, height: ViewTraits.Circle.small)
		}
	}
	
	var body: some View {
		Rectangle()
			.foregroundStyle(.clear)
			.aspectRatio(ViewTraits.Box.aspectRatio, contentMode: .fit)
			.background(theme.backgroundSecondary)
			.cornerRadius(ViewTraits.Box.radius)
			.overlay(
				ZStack {
					RoundedRectangle(cornerRadius: ViewTraits.Box.radius)
						.inset(by: inset)
						.stroke(borderColor, lineWidth: borderWidth)
					icon
					
				}
			)
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
			AccessCodeBoxView(state: .constant(.filled))
			AccessCodeBoxView(state: .constant(.filling))
			AccessCodeBoxView(state: .constant(.focus))
			AccessCodeBoxView(state: .constant(.empty))
			AccessCodeBoxView(state: .constant(.error))
		}
	}
}
