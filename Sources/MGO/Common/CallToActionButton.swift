/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A big blue call to action button
struct CallToActionButton: View {
	
	/// The key of the localized text to be displayed as title
	var title: LocalizedStringKey
	
	/// The action to perform when the user presses the button
	var action: (() -> Void)?
	
	/// The button style (primary, secondary)
	var style: Style
	
	/// All possible styles
	enum Style {
		case primary
		case secondary
	}
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	init(_ title: LocalizedStringKey, style: Style = .primary, action: ( () -> Void)? = nil) {
		self.title = title
		self.style = style
		self.action = action
	}
	
	var body: some View {
		
		Button(
			action: {
				action?()
			},
			label: {
				Text(title)
			}
		)
		.if(style == .primary, transform: { button in
			button.buttonStyle(PrimaryButtonStyle())
		})
		.if(style == .secondary, transform: { button in
			button.buttonStyle(SecondaryButtonStyle())
		})
		.hapticFeedback(.medium)
	}
}

#Preview {
	CallToActionButton("onboarding_action")
		.padding(16)
}
