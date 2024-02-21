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
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	init(_ title: LocalizedStringKey, action: ( () -> Void)? = nil) {
		self.title = title
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
		.buttonStyle(PrimaryButtonStyle())
		.hapticFeedback(.medium)
	}
}

#Preview {
	CallToActionButton("onboarding_action")
		.padding(16)
}
