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
	public var key: LocalizedStringKey?
	
	/// The  title
	public var title: String?
	
	/// An icon
	public var icon: Image?
	
	/// The action to perform when the user presses the button
	public var action: (() -> Void)?
	
	/// The button style (primary, secondary)
	public var style: Style
	
	/// All possible styles
	public enum Style {
		case primary
		case primaryCritical
		case secondary
		case secondaryCritical
		case tertiary
		case tertiaryCritical
		case tertiaryWithIcon
	}
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	public init(_ key: LocalizedStringKey, icon: Image? = nil, style: Style = .primary, action: ( () -> Void)? = nil) {
		self.key = key
		self.style = style
		self.action = action
		self.icon = icon
	}

	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	public init(title: String, icon: Image? = nil, style: Style = .primary, action: ( () -> Void)? = nil) {
		self.title = title
		self.style = style
		self.action = action
		self.icon = icon
	}
	
	public var body: some View {
		
		Button(
			action: {
				action?()
			},
			label: {
				if style == .tertiaryWithIcon, let icon {
					HStack {
						titleLabel()
						Spacer()
						icon
					}
				} else {
					titleLabel()
				}
			}
		)
		.when(style == .primary, transform: { button in
			button.buttonStyle(PrimaryDefaultButtonStyle())
		})
		.when(style == .primaryCritical, transform: { button in
			button.buttonStyle(PrimaryCriticalButtonStyle())
		})
		.when(style == .secondary, transform: { button in
			button.buttonStyle(SecondaryDefaultButtonStyle())
		})
		.when(style == .secondaryCritical, transform: { button in
			button.buttonStyle(SecondaryCriticalButtonStyle())
		})
		.when(style == .tertiary, transform: { button in
			button.buttonStyle(TertiaryButtonStyle())
		})
		.when(style == .tertiaryWithIcon, transform: { button in
			button.buttonStyle(TertiaryButtonWithIconStyle())
		})
		.when(style == .tertiaryCritical, transform: { button in
			button.buttonStyle(TertiaryCriticalButtonStyle())
		})
	}
	
	/// Get the view for the title
	/// - Returns: title label
	@ViewBuilder func titleLabel() -> some View {
		
		if let key {
			Text(key)
		} else {
			Text(title ?? "")
		}
	}
}

#Preview {
	VStack {
		HStack {
			CallToActionButton(".primary", style: .primary)
				.padding(16)
			CallToActionButton(".primaryCritical", style: .primaryCritical)
				.padding(16)
		}
		HStack {
			CallToActionButton(".secondary", style: .secondary)
				.padding(16)
			CallToActionButton(".secondaryCritical", style: .secondaryCritical)
				.padding(16)
		}
		HStack {
			CallToActionButton(".tertiary", style: .tertiary)
				.padding(16)
			CallToActionButton(".tertiaryCritical", style: .tertiaryCritical)
				.padding(16)
		}
		HStack {
			CallToActionButton(".tertiaryWithIcon", icon: Image(systemName: "stethoscope"), style: .tertiaryWithIcon)
				.padding(16)
		}
	}
}
