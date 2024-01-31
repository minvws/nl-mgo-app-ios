/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A big blue button
struct SkyBlueButton: View {
	
	/// Color sheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum ButtonTitle {
			static let insets = EdgeInsets( top: 16, leading: 24, bottom: 16, trailing: 24)
		}
		enum Button {
			static let cornerRadius: CGFloat = 8
			static let minimumHeight: CGFloat = 48
		}
	}
	
	/// The key of the localized text to be displayed as title
	var title: LocalizedStringKey
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	init(_ title: LocalizedStringKey) {
		self.title = title
	}
	
	var body: some View {
		
		Text(title)
			.rijksoverheidStyle(font: .bold, style: .body)
			.foregroundColor(colorScheme == .light ? Color.Styleguide.white : Color.Styleguide.black)
			.padding(ViewTraits.ButtonTitle.insets)
			.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
			.background(Color.Styleguide.Blue.skyBlue)
			.cornerRadius(ViewTraits.Button.cornerRadius)
	}
}

#Preview {
	SkyBlueButton("onboarding_action")
}
