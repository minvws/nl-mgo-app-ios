/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		case loginWithDigiD
		case loginWithDigiDSpinner
		case primary
		case primaryCritical
		case secondary
		case secondaryCritical
		case tertiary
		case tertiaryCritical
		case withIcon
		case withSpinner
	}
	
	/// Create a Call To Action Button
	/// - Parameter title: The key of the localized text to be displayed as title
	/// - Parameter icon: the optional icon to display
	/// - Parameter style: the style to display in
	/// - Parameter action: the optional action to perform
	public init(_ key: LocalizedStringKey, icon: Image? = nil, style: Style = .primary, action: ( () -> Void)? = nil) {
		self.key = key
		self.style = style
		self.action = action
		self.icon = icon
	}

	/// Create a Call To Action Button
	/// - Parameter title: The text to be displayed as title
	/// - Parameter icon: the optional icon to display
	/// - Parameter style: the style to display in
	/// - Parameter action: the optional action to perform
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
				if style == .withIcon, let icon {
					HStack {
						titleLabel()
						Spacer()
						icon
					}
					.contentShape(Rectangle())
				} else if style == .loginWithDigiD, let icon {
					HStack {
						Spacer()
						icon
						titleLabel()
						Spacer()
					}
					.contentShape(Rectangle())
				} else if style == .withSpinner {
					HStack {
						titleLabel()
						Spacer()
						ProgressView()
							.progressViewStyle(.circular)
					}
				} else if style == .loginWithDigiDSpinner {
					HStack {
						Spacer()
						ProgressView()
							.progressViewStyle(.circular)
						titleLabel()
						Spacer()
						
					}
				} else {
					titleLabel()
				}
			}
		)
		.when(style == .loginWithDigiD || style == .loginWithDigiDSpinner, transform: { button in
			button.buttonStyle(ButtonWithOrangeStyle())
		})
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
		.when(style == .tertiaryCritical, transform: { button in
			button.buttonStyle(TertiaryCriticalButtonStyle())
		})
		.when(style == .withIcon, transform: { button in
			button.buttonStyle(ButtonWithIconStyle())
		})
		.when(style == .withSpinner, transform: { button in
			button.buttonStyle(ButtonWithSpinnerStyle())
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
		CallToActionButton(".loginWithDigiD", icon: Image(systemName: "stethoscope"), style: .loginWithDigiD)
			.padding(16)
		CallToActionButton(".loginWithDigiDSpinner", style: .loginWithDigiDSpinner)
			.padding(16)
		CallToActionButton(".primary", style: .primary)
			.padding(16)
		CallToActionButton(".primaryCritical", style: .primaryCritical)
			.padding(16)
		CallToActionButton(".secondary", style: .secondary)
			.padding(16)
		CallToActionButton(".secondaryCritical", style: .secondaryCritical)
			.padding(16)
		CallToActionButton(".tertiary", style: .tertiary)
			.padding(16)
		CallToActionButton(".tertiaryCritical", style: .tertiaryCritical)
			.padding(16)
		CallToActionButton(".withIcon", icon: Image(systemName: "stethoscope"), style: .withIcon)
			.padding(16)
		CallToActionButton(".withSpinner", style: .withSpinner)
			.padding(16)
		Spacer()
	}
}
