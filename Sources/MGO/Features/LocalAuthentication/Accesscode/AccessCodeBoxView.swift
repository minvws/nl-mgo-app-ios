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
			colorScheme == .light ? Color.Styleguide.Blue.skyBlue : Color.Styleguide.Blue.skyBlueTint1
			case .empty, .filled:
			colorScheme == .light ? Color.Styleguide.Grey.grey6 : Color.Styleguide.Grey.grey4
			case .error: Color.Styleguide.Basic.red
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
					.foregroundStyle(colorScheme == .light ? Color.Styleguide.Blue.skyBlue : Color.Styleguide.Blue.skyBlueTint1)
					.frame(width: ViewTraits.Circle.big, height: ViewTraits.Circle.big)
			
			case .filled:
				Circle()
					.foregroundStyle(colorScheme == .light ? Color.Styleguide.Blue.skyBlue : Color.Styleguide.Blue.skyBlueTint1)
					.frame(width: ViewTraits.Circle.small, height: ViewTraits.Circle.small)
			
			case .error:
				Circle()
					.foregroundStyle(Color.Styleguide.Basic.red)
					.frame(width: ViewTraits.Circle.small, height: ViewTraits.Circle.small)
		}
	}
	
	var body: some View {
		Rectangle()
			.foregroundStyle(.clear)
			.frame(width: ViewTraits.Box.width, height: height)
			.background(Color.Styleguide.white)
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
		Color.Styleguide.background
		HStack {
			AccessCodeBoxView(state: .constant(.filled))
				.frame(maxWidth: .infinity)
			AccessCodeBoxView(state: .constant(.filling))
				.frame(maxWidth: .infinity)
			AccessCodeBoxView(state: .constant(.focus))
				.frame(maxWidth: .infinity)
			AccessCodeBoxView(state: .constant(.empty))
				.frame(maxWidth: .infinity)
			AccessCodeBoxView(state: .constant(.error))
				.frame(maxWidth: .infinity)
		}
	}
}
