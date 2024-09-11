/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct EmptyListView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Create an empty view for a list
	/// - Parameters:
	///   - icon: the icon to be displayed
	///   - heading: the heading of the empty state
	///   - subHeading: the sub heading of the empty state
	public init(icon: Image, heading: LocalizedStringKey, subHeading: LocalizedStringKey) {
		self.icon = icon
		self.heading = heading
		self.subHeading = subHeading
	}
	
	/// The icon to be displayed
	public var icon: Image
	
	/// The language key for the heading
	public var heading: LocalizedStringKey
	
	/// The language key for the sub heading
	public var subHeading: LocalizedStringKey
	
	/// helper to calculate the size of the view
	@State private var contentSize: CGSize = .zero
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Empty {
			static let width: CGFloat = 0.5
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 8
			static let top: CGFloat = 12
		}
	}
	
	public var body: some View {
		
		HStack(spacing: ViewTraits.Empty.spacing) {
			
			Spacer()
			
			VStack(alignment: .center) {
				
				// Image, 50% width
				VStack(alignment: .center) {
					Spacer()
					
					icon
						.resizable()
						.aspectRatio(contentMode: .fill)
						.padding(.bottom, ViewTraits.Empty.padding)
				}
				.frame(maxWidth: contentSize.width * ViewTraits.Empty.width)
				
				// Texts, full width
				VStack(alignment: .center, spacing: ViewTraits.Empty.spacing) {
					
					Text(heading)
						.rijksoverheidStyle(font: .bold, style: .title3)
						.foregroundColor(theme.contentPrimary)
						.multilineTextAlignment(.center)
					
					Text(subHeading)
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundColor(theme.contentTertiary)
						.multilineTextAlignment(.center)
					
					Spacer()
				}
			}
			Spacer()
		}
		.readSize($contentSize)
		.accessibilityElement(children: .combine)
		.padding(.top, ViewTraits.Empty.top)
	}
}

#Preview {
	EmptyListView(
		icon: Image(systemName: "42.circle"),
		heading: "Heading",
		subHeading: "SubHeading"
	)
}
