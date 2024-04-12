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
			static let width: CGFloat = 50
			static let height: CGFloat = 60
			static let radius: CGFloat = 5
		}
	}
	
	/// All posible states of the box
	enum State {
		case empty
		case focus
		case filling
		case filled
		case error
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
	
	var height: CGFloat {
		switch state {
			case .empty, .filled, .error: ViewTraits.Box.height
			case .focus, .filling: ViewTraits.Box.height + 3
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
			.frame(width: ViewTraits.Box.width, height: height)
			.background(theme.backgroundSecondary)
			.cornerRadius(ViewTraits.Box.radius)
			.overlay(
				ZStack {
					RoundedRectangle(cornerRadius: ViewTraits.Box.radius)
						.stroke(borderColor, lineWidth: borderWidth)
					icon
					
				}
			)
			.onAppear {
				if state == .filling {
					withAnimation(Animation.linear(duration: 0.5)) {
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
