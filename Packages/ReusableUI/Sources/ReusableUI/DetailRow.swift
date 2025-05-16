/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct DetailRow: View {
	
	/// The title of the detail row
	private var title: LocalizedStringKey
	
	/// The content of the detail row
	private var content: String?
	
	/// The Theme
	@Environment(\.theme) private var theme
	
	/// Initializer
	/// - Parameters:
	///   - title: the title of the view
	///   - content: the body of the view
	public init(title: LocalizedStringKey, content: String?) {
		self.title = title
		self.content = content
	}
	
	public var body: some View {
		
		VStack(alignment: .leading, spacing: 4) {
			
			Text(title)
				.textCase(/*@START_MENU_TOKEN@*/.uppercase/*@END_MENU_TOKEN@*/)
				.rijksoverheidStyle(font: .regular, style: .callout)
				.foregroundColor(theme.contentSecondary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
			
			Text(content ?? "")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundColor(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
		}
		.accessibilityElement(children: .combine)
	}
}

#Preview {
	DetailRow(title: "The Title", content: "The Content")
}
