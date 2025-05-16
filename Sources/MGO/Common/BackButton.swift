/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

/// A simple back button consisting of an left chevron and a previous text
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
	init(_ title: LocalizedStringKey = "common.previous", action: (() -> Void)?) {
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
		.accessibilityIdentifier("common.previous")
		.buttonStyle(BackButtonStyle())
		.frame(minWidth: ViewTraits.Button.minWidth, maxWidth: .infinity, alignment: .leading)
		.padding(.leading, -ViewTraits.Image.padding)
	}
}

#Preview {
	BackButton(action: nil)
}

struct BackButtonStyle: ButtonStyle {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Style the button to a back button
	/// - Parameter configuration: the button configuration
	/// - Returns: primary button
	func makeBody(configuration: Self.Configuration) -> some View {
		
		configuration.label
			.foregroundStyle(configuration.isPressed ? theme.interactionTertiaryDefaultTextHover : theme.interactionTertiaryDefaultText)
	}
}
