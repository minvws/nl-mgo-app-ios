/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct CardView: View {
	
	private var title: String
	
	private var message: String?
	
	private var meta: String?

	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let spacing: CGFloat = 4
			static let minHeight: CGFloat = 48
		}
	}
	
	/// Initializer
	/// - Parameters:
	///   - title: the title for this card
	///   - message: the message for this card
	///   - meta: the meta message for this card
	public init(
		title: String,
		message: String? = nil,
		meta: String? = nil
	) {
		self.title = title
		self.message = message
		self.meta = meta
	}
	
	public var body: some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.General.spacing) {
			
			HStack(alignment: .top) {
				
				Text(title)
					.lineLimit(2)
					.typography(.headingMedium)
					.foregroundColor(theme.labels.primary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Spacer()
				
				if let meta {
					Text(meta)
						.typography(.bodySmall)
						.foregroundColor(theme.labels.secondary)
						.layoutPriority(100)
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
		meta: "meta"
	)
	.padding(16)
}
