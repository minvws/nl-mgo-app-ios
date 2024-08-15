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
		.when(style == .secondary, transform: { button in
			button.buttonStyle(SecondaryDefaultButtonStyle())
		})
		.when(style == .primaryNegative, transform: { button in
			button.buttonStyle(PrimaryNegativeButtonStyle())
		})
	}
}

#Preview {
	VStack {
		CallToActionButton("common.next", style: .primary)
			.padding(16)
		CallToActionButton("common.next", style: .secondary)
			.padding(16)
		CallToActionButton("common.next", style: .primaryNegative)
			.padding(16)
	}
}
