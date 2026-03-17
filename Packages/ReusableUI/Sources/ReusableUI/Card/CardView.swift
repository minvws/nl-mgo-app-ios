/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// Configuration options for a ``CardView``.
public struct CardViewConfig {

	/// Whether to show a trailing chevron indicating the card is navigable.
	public var showChevron: Bool

	/// The foreground colour of the card title.
	public var titleColor: Color

	/// Creates a `CardViewConfig`.
	/// - Parameters:
	///   - showChevron: Pass `true` to indicate the card is navigable (defaults to `false`).
	///   - titleColor: The colour for the card title..
	public init(showChevron: Bool = false, titleColor: Color) {
		self.showChevron = showChevron
		self.titleColor = titleColor
	}
}

/// A card-shaped view that displays a title, an optional message, and optional detail text.
///
/// When `details` is provided the title colour switches to secondary so the detail value stands out.
/// Use `config.showChevron` to indicate that the card is tappable (the chevron itself is currently
/// rendered by the parent; this flag is stored for future use or external access).
public struct CardView: View {

	/// The main heading of the card.
	private var title: String

	/// An optional secondary line of text shown below the title.
	private var message: String?

	/// Optional trailing text placed to the right of the title, e.g. a date or value.
	private var details: String?

	/// Configuration options for this card.
	public var config: CardViewConfig

	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let spacing: CGFloat = 4
			static let minHeight: CGFloat = 48
		}
		enum Accessory {
			static let size: CGFloat = 17
		}
	}
	
	/// Creates a `CardView`.
	/// - Parameters:
	///   - title: The main heading displayed on the card.
	///   - message: An optional secondary line of text shown below the title.
	///   - details: Optional trailing text placed to the right of the title.
	///   - config: Configuration options for the card
	public init(
		title: String,
		message: String? = nil,
		details: String? = nil,
		config: CardViewConfig
	) {
		self.title = title
		self.message = message
		self.details = details
		self.config = config
	}
	
	public var body: some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.General.spacing) {
			
			HStack(alignment: .top, spacing: 0) {
				
				Text(title)
					.lineLimit(2)
					.typography(.bodyMedium, with: .bold)
					.foregroundStyle(config.titleColor)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Spacer()
				
				if let details {
					Text(details)
						.typography(.bodySmall)
						.foregroundStyle(theme.labels.secondary)
						.layoutPriority(100)
				}
				
				if config.showChevron {
					Image(systemName: "chevron.right")
						.font(.system(size: 17, weight: .semibold))
						.foregroundStyle(theme.symbols.secondary)
						.frame(
							width: ViewTraits.Accessory.size,
							alignment: .leading
						)
						.padding(.leading, 8)
				}
			}
			if let message {
				Text(message)
					.typography(.bodyMedium)
					.foregroundColor(theme.labels.secondary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
			}
		}
		.frame(minHeight: ViewTraits.General.minHeight)
	}
}

#Preview {
	
	CardView(
		title: "title",
		message: "message",
		details: "details",
		config: CardViewConfig(showChevron: true, titleColor: .blue)
	)
	.padding(16)
}
