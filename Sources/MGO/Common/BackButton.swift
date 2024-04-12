/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

/// A simple backbutton consisting of an left chevron and a previous text
struct BackButton: View {
	
	var action: (() -> Void)?
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let width: CGFloat = 12
			static let height: CGFloat = 20
			static let padding: CGFloat = 8
		}
		enum Button {
			static let minWidth: CGFloat = 70
		}
	}
	
	/// The key of the localized text to be displayed as title
	var title: LocalizedStringKey
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	/// - Parameter action: Optional closure to be executed when the user presses the button
	init(_ title: LocalizedStringKey = "general_previous", action: (() -> Void)?) {
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
					
					Image(ImageResource.Icon.backArrow)
						.resizable()
						.frame(width: ViewTraits.Image.width, height: ViewTraits.Image.height)
						.padding(.trailing, ViewTraits.Image.padding)
					
					Text(title)
						.rijksoverheidStyle(font: .regular, style: .headline)
				}
			}
		)
		.buttonStyle(BackButtonStyle())
		.frame(minWidth: ViewTraits.Button.minWidth, maxWidth: .infinity, alignment: .leading)
	}
}

#Preview {
	BackButton(action: nil)
}

struct BackButtonStyle: ButtonStyle {

	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Get the foreground style for the appropriate settings
	/// - Parameters:
	///   - configuration: the configuration of the the button (isPressed)
	///   - colorScheme: the color scheme (dark / light)
	/// - Returns: Appropriate foreground color
	func getForeGroundStyle(configuration: Self.Configuration, colorScheme: ColorScheme) -> Color {
		
		switch (configuration.isPressed, colorScheme) {
			case (true, .light): return theme.actionTertiaryBackground.opacity(0.75)
			case (true, .dark): return theme.actionTertiaryBackground.opacity(0.75)
			case (false, .light): return theme.actionTertiaryBackground
			case (false, .dark): return theme.actionTertiaryBackground
			case (_, _):
				logWarning("Unhandled case for back button style")
		}
		return theme.actionPrimaryBackground
	}
	
	/// Style the button to a primary button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.foregroundStyle(getForeGroundStyle(configuration: configuration, colorScheme: colorScheme))
	}
}
