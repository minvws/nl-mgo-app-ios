/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A simple backbutton consisting of an left chevron and a previous text
struct BackButton: View {
	
	var action: (() -> Void)?
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let width: CGFloat = 12
			static let height: CGFloat = 20
			static let padding: CGFloat = 8
		}
	}
	
	/// The key of the localized text to be displayed as title
	var title: LocalizedStringKey
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	/// - Parameter action: Optional closure to be executed when the user presses the button
	init(_ title: LocalizedStringKey = "previous", action: (() -> Void)?) {
		self.title = title
		self.action = action
	}
	
	var body: some View {
		Button(
			action: {
				action?()
			},
			label: {
				HStack(alignment: .center, spacing: 0) {
					
					Image(.backArrow)
						.resizable()
						.frame(width: ViewTraits.Image.width, height: ViewTraits.Image.height)
						.tint(colorScheme == .light ? Color.Styleguide.Blue.skyBlue : Color.Styleguide.Blue.skyBlueTint1)
						.padding(.trailing, ViewTraits.Image.padding)
					
					Text(title)
						.rijksoverheidStyle(font: .regular, style: .headline)
						.foregroundColor(colorScheme == .light ? Color.Styleguide.Blue.skyBlue : Color.Styleguide.Blue.skyBlueTint1)
				}
			}
		)
	}
}

#Preview {
	BackButton(action: nil)
}
