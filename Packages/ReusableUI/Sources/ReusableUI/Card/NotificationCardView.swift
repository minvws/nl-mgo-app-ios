/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct NotificationCardView: View {
	
	private var icon: Image?
	
	private var title: LocalizedStringKey?
	
	private var message: LocalizedStringKey?
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let spacing: CGFloat = 16
			static let radius: CGFloat = 10
			static let inset: CGFloat = 0.5
		}
		enum Image {
			static let bottom: CGFloat = 8
			static let horizontal: CGFloat = 60
		}
	}
	
	/// Initializer
	/// - Parameters:
	///   - icon: the image for this card
	///   - title: the title for this card
	///   - message: the message for this card
	public init(
		icon: Image? = nil,
		title: LocalizedStringKey? = nil,
		message: LocalizedStringKey? = nil) {
		self.icon = icon
		self.title = title
		self.message = message
	}
	
	public var body: some View {
		
		VStack(alignment: .leading, spacing: 8) {
			
			if let icon {
				HStack {
					Spacer(minLength: ViewTraits.Image.horizontal)
					icon
						.resizable()
						.scaledToFit()
					Spacer(minLength: ViewTraits.Image.horizontal)
				}
				.padding(.bottom, ViewTraits.Image.bottom)
			}
			
			if let title {
				Text(title)
					.rijksoverheidStyle(font: .bold, style: .title2)
					.foregroundColor(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
			}
			
			if let message {
				Text(message)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundColor(theme.contentSecondary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
			}
		}
		.cardify()
	}
}

#Preview {
	
	NotificationCardView(
		icon: Image(systemName: "stethoscope"),
		title: "title",
		message: "message"
	)
	.padding(16)
}
