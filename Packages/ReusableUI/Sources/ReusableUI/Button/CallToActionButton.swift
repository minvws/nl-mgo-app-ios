/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import RijksoverheidFont
import SwiftUI
import Theme

/// A big blue call to action button
public struct CallToActionButton: View {
	
	/// The key of the localized text to be displayed as title
	public var title: LocalizedStringKey
	
	/// The action to perform when the user presses the button
	public var action: (() -> Void)?
	
	/// The button style (primary, secondary)
	public var style: Style
	
	/// All possible styles
	public enum Style {
		case primary
		case primaryNegative
		case secondary
		case secondaryNegative
		case tertiary
		case tertiaryNegative
	}
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	public init(_ title: LocalizedStringKey, style: Style = .primary, action: ( () -> Void)? = nil) {
		self.title = title
		self.style = style
		self.action = action
	}
	
	public var body: some View {
		
		Button(
			action: {
				action?()
			},
			label: {
				Text(title)
			}
		)
		.when(style == .primary, transform: { button in
			button.buttonStyle(PrimaryDefaultButtonStyle())
		})
		.when(style == .primaryNegative, transform: { button in
			button.buttonStyle(PrimaryNegativeButtonStyle())
		})
		.when(style == .secondary, transform: { button in
			button.buttonStyle(SecondaryDefaultButtonStyle())
		})
		.when(style == .secondaryNegative, transform: { button in
			button.buttonStyle(SecondaryNegativeButtonStyle())
		})
		.when(style == .tertiary, transform: { button in
			button.buttonStyle(TertiaryButtonStyle())
		})
		.when(style == .tertiaryNegative, transform: { button in
			button.buttonStyle(TertiaryNegativeButtonStyle())
		})
	}
}

#Preview {
	VStack {
		CallToActionButton("primary", style: .primary)
			.padding(16)
		CallToActionButton("primaryNegative", style: .primaryNegative)
			.padding(16)
		CallToActionButton("secondary", style: .secondary)
			.padding(16)
		CallToActionButton("secondaryNegative", style: .secondaryNegative)
			.padding(16)
		CallToActionButton("tertiary", style: .tertiary)
			.padding(16)
		CallToActionButton("tertiaryNegative", style: .tertiaryNegative)
			.padding(16)
	}
}
