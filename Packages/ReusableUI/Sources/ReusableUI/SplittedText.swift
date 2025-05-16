/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

/// A Text View that is broken up into a Text View for each line of the content
public struct SplittedText: View {
	
	/// The spacing between the text elements
	private var spacing: CGFloat
	
	/// The alignment of the text elements
	private var alignment: HorizontalAlignment
	
	/// The text broken up into elements by new lines
	private var elements: [String] = []
	
	/// Initializer
	/// - Parameters:
	///   - content: the content to be displayed
	///   - spacing: the spacing between each of the lines
	///   - alignment: the alignment of the texts
	public init(_ content: String, spacing: CGFloat = 0, alignment: HorizontalAlignment = .leading) {
		
		self.spacing = spacing
		self.alignment = alignment

		elements = content.components(separatedBy: "\n")
	}
	
	@available(iOS 15, *)
	/// Initializer
	/// - Parameters:
	///   - key: the  string key of the content
	///   - spacing: the spacing between each of the lines
	///   - alignment: the alignment of the texts
	public init(key: String.LocalizationValue, spacing: CGFloat = 0, alignment: HorizontalAlignment = .leading) {
		
		self.spacing = spacing
		self.alignment = alignment
		let content = String(localized: key)

		elements = content.components(separatedBy: "\n")
	}

	public var body: some View {
		
		VStack(alignment: alignment, spacing: spacing) {
			ForEach(elements, id: \.self) { element in
				Text(element)
			}
		}
	}
}

#Preview {
	VStack {
		SplittedText("Content\nContent\nMore Content", spacing: 8, alignment: .center)
			.padding(.bottom, 16)
		
		SplittedText("Content\nContent\nMore Content", spacing: 3, alignment: .leading)
	}
}
