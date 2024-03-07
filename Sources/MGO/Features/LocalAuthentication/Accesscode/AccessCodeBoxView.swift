/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A small box for displaying a single digit of a pincode
struct AccessCodeBoxView: View {
	
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
	
	@Binding var state: State
	
	enum State {
		case empty
		case focus
		case filling
		case filled
		case error
		
		var borderColor: Color {
			switch self {
				case .focus, .filling: Color.Styleguide.Blue.skyBlue
				case .empty, .filled: Color.Styleguide.Grey.grey6
				case .error: Color.Styleguide.Basic.red
			}
		}
		
		var borderWidth: CGFloat {
			switch self {
				case .empty, .filled: 2
				case .focus, .filling, .error: 3
			}
		}
		
		@ViewBuilder var icon: some View {
			switch self {
				case .empty:
					EmptyView()
				case .focus:
					EmptyView()
				case .filling:
					Circle()
						.foregroundStyle(Color.Styleguide.Blue.skyBlue)
						.frame(width: ViewTraits.Circle.big, height: ViewTraits.Circle.big)
				case .filled:
					Circle()
						.foregroundStyle(Color.Styleguide.Blue.skyBlue)
						.frame(width: ViewTraits.Circle.small, height: ViewTraits.Circle.small)
				case .error:
					Circle()
						.foregroundStyle(Color.Styleguide.Basic.red)
						.frame(width: ViewTraits.Circle.small, height: ViewTraits.Circle.small)
			}
		}
	}
	
	var body: some View {
		Rectangle()
			.foregroundStyle(.clear)
			.frame(width: ViewTraits.Box.width, height: ViewTraits.Box.height)
			.background(Color.Styleguide.white)
			.cornerRadius(ViewTraits.Box.radius)
			.overlay(
				ZStack {
					RoundedRectangle(cornerRadius: ViewTraits.Box.radius)
						.stroke(state.borderColor, lineWidth: state.borderWidth)
					state.icon
				}
			)
	}
}

#Preview {
	ZStack {
		Color.Styleguide.background
		HStack(spacing: 12) {
			AccessCodeBoxView(state: .constant(.filled))
			AccessCodeBoxView(state: .constant(.filling))
			AccessCodeBoxView(state: .constant(.focus))
			AccessCodeBoxView(state: .constant(.empty))
			AccessCodeBoxView(state: .constant(.error))
		}
	}
}
