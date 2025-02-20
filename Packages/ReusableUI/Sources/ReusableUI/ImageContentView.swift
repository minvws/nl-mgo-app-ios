/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// <#Description#>
public struct ImageContentView: View {
	
	public enum Alignment {
		case leading
		case center
	}
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Create an empty view for a list
	/// - Parameters:
	///   - icon: the icon to be displayed
	///   - heading: the heading of the empty state
	///   - subHeading: the sub heading of the empty state
	///   - textAlignment: the alignment of the texts
	///   - textSpacing: the spacing between the texts
	///   - titleStyle: the style of the title
	public init(
		icon: Image,
		heading: LocalizedStringKey,
		subHeading: LocalizedStringKey,
		textAlignment: ImageContentView.Alignment = .center,
		textSpacing: CGFloat = 8,
		titleStyle: Font.TextStyle = .title3,
		subHeadingForegroundColor: Color
	) {
		self.icon = icon
		self.heading = heading
		self.subHeading = subHeading
		self.textAlignment = textAlignment
		self.textSpacing = textSpacing
		self.titleStyle = titleStyle
		self.subHeadingForegroundColor = subHeadingForegroundColor
	}
	
	/// The icon to be displayed
	public var icon: Image
	
	/// The language key for the heading
	public var heading: LocalizedStringKey
	
	/// The language key for the sub heading
	public var subHeading: LocalizedStringKey
	
	/// The alignment of the texts
	private var textAlignment: Alignment
	
	/// The style for the title
	private var titleStyle: Font.TextStyle
	
	/// The style for the title
	private var textSpacing: CGFloat
	
	private var subHeadingForegroundColor: Color?
	
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
				VStack(alignment: textAlignment == .center ? .center : .leading, spacing: textSpacing) {
					
					Text(heading)
						.rijksoverheidStyle(font: .bold, style: titleStyle)
						.foregroundColor(theme.contentPrimary)
						.multilineTextAlignment(textAlignment == .center ? .center : .leading)
						.fixedSize(horizontal: false, vertical: true)
					
					Text(subHeading)
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundColor(subHeadingForegroundColor)
						.multilineTextAlignment(textAlignment == .center ? .center : .leading)
						.fixedSize(horizontal: false, vertical: true)
					
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
	ImageContentView(
		icon: Image(systemName: "42.circle"),
		heading: "Heading",
		subHeading: "SubHeading",
		titleStyle: .largeTitle,
		subHeadingForegroundColor: Color.pink
	)
}
