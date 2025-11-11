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
	public var style: CallToActionButtonStyle
	
	/// Create a Call To Action Button
	/// - Parameter title: The key of the localized text to be displayed as title
	/// - Parameter icon: the optional icon to display
	/// - Parameter style: the style to display in
	/// - Parameter action: the optional action to perform
	public init(
		_ key: LocalizedStringKey,
		icon: Image? = nil,
		style: CallToActionButtonStyle = .solid(rounded: false),
		action: ( () -> Void)? = nil
	) {
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
	public init(
		title: String,
		icon: Image? = nil,
		style: CallToActionButtonStyle,
		action: ( () -> Void)? = nil
	) {
		self.title = title
		self.style = style
		self.action = action
		self.icon = icon
	}
	
	public var body: some View {
		Group {
			Button(
				action: {
					action?()
				},
				label: {
					if case .withIcon = style, let icon {
						HStack {
							titleLabel()
							Spacer()
							icon
						}
						.contentShape(Rectangle())
					} else if case .solidLeadingIcon = style, let icon {
						HStack {
							Spacer()
							icon
							titleLabel()
							Spacer()
						}
						.contentShape(Rectangle())
					} else if case .withSpinner = style {
						HStack {
							titleLabel()
							Spacer()
							ProgressView()
								.progressViewStyle(.circular)
						}
					} else if case .solidLeadingSpinner = style {
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
		}
		.modifier(ButtonStyleApplier(style: style))
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

private struct ButtonStyleApplier: ViewModifier {
	
	/// The style to apply
	let style: CallToActionButtonStyle
	
	/// Applying the button style
	/// - Parameter content: the content
	/// - Returns: the content with button style
	func body(content: Content) -> some View {
		switch style {
			case .ghost:
				content.buttonStyle(GhostButtonStyle())
			case let .solid(rounded),
				let .solidLeadingIcon(rounded: rounded),
				let .solidLeadingSpinner(rounded: rounded):
				content.buttonStyle(SolidButtonStyle(rounded: rounded))
			case let .tonal(rounded):
				content.buttonStyle(TonalButtonStyle(rounded: rounded))
			case .withIcon:
				content.buttonStyle(ButtonWithIconStyle())
			case .withSpinner:
				content.buttonStyle(ButtonWithSpinnerStyle())
		}
	}
}

#Preview {
	VStack {
		CallToActionButton(
			".solidLeadingIcon(rounded: false)",
			icon: Image(systemName: "stethoscope"),
			style: .solidLeadingIcon(rounded: false)
		)
			.padding(16)
		CallToActionButton(
			".solidLeadingIcon(rounded: true)",
			icon: Image(systemName: "stethoscope"),
			style: .solidLeadingIcon(rounded: true)
		)
		.padding(16)
		CallToActionButton(
			".solidLeadingSpinner(rounded: false)",
			style: .solidLeadingSpinner(rounded: false)
		)
		.padding(16)
		CallToActionButton(
			".solidLeadingSpinner(rounded: true)",
			style: .solidLeadingSpinner(rounded: true)
		)
		.padding(16)
		CallToActionButton(
			".solid(rounded: false)",
			style: .solid(rounded: false)
		)
			.padding(16)
		CallToActionButton(
			".solid(rounded: true)",
			style: .solid(rounded: true)
		)
			.padding(16)
		CallToActionButton(
			".tonal(rounded: false)",
			style: .tonal(rounded: false)
		)
			.padding(16)
		CallToActionButton(
			".tonal(rounded: true)",
			style: .tonal(rounded: true)
		)
			.padding(16)
		CallToActionButton(
			".ghost",
			style: .ghost
		)
			.padding(16)
		CallToActionButton(
			".withIcon",
			icon: Image(systemName: "stethoscope"),
			style: .withIcon
		)
			.padding(16)
		CallToActionButton(
			".withSpinner",
			style: .withSpinner
		)
			.padding(16)
		Spacer()
	}
}

