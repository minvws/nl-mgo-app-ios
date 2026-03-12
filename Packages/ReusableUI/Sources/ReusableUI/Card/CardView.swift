/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// A card-shaped view that displays a title, an optional message, and optional detail text.
///
/// When `details` is provided the title colour switches to secondary so the detail value stands out.
/// Use `showChevron` to indicate that the card is tappable (the chevron itself is currently rendered
/// by the parent; this flag is stored for future use or external access).
public struct CardView: View {

	/// The main heading of the card.
	private var title: String

	/// An optional secondary line of text shown below the title.
	private var message: String?

	/// Optional trailing text placed to the right of the title, e.g. a date or value.
	private var details: String?

	/// Whether to show a trailing chevron indicating the card is navigable.
	private var showChevron: Bool = false

	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let spacing: CGFloat = 4
			static let minHeight: CGFloat = 48
		}
		enum Accessory {
			static let size: CGFloat = 22
		}
	}
	
	/// Creates a `CardView`.
	/// - Parameters:
	///   - title: The main heading displayed on the card.
	///   - message: An optional secondary line of text shown below the title.
	///   - details: Optional trailing text placed to the right of the title.
	///   - showChevron: Pass `true` to indicate the card is navigable (defaults to `false`).
	public init(
		title: String,
		message: String? = nil,
		details: String? = nil,
		showChevron: Bool = false
	) {
		self.title = title
		self.message = message
		self.details = details
		self.showChevron = showChevron
	}
	
	public var body: some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.General.spacing) {
			
			HStack(alignment: .top) {
				
				Text(title)
					.lineLimit(2)
					.typography(.bodyMedium, with: .bold)
					.foregroundColor(
						details == nil ? theme.labels.primary : theme.labels.secondary
					)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Spacer()
				
				if let details {
					Text(details)
						.typography(.bodySmall)
						.foregroundColor(theme.labels.secondary)
						.layoutPriority(100)
				}
				if showChevron {
					Image(ImageResource.Icon.chevron)
						.foregroundStyle(theme.symbols.secondary)
						.frame(
							width: ViewTraits.Accessory.size,
							height: ViewTraits.Accessory.size
						)
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
		showChevron: true
	)
	.padding(16)
}
