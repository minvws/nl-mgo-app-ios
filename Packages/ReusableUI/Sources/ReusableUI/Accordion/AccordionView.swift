/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct AccordionView<Content: View>: View {
	
	/// The content to show or hide
	private var content: () -> Content
	
	/// The title of the content
	private var title: String
	
	/// Should we show the body content?
	@State private var showBody = false
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Initializer
	/// - Parameters:
	///   - title: the title for the accordion
	///   - startOpen: True if the content should be visible on init, defaults to false.
	///   - content: the content to hide and show
	public init(title: String, startOpen: Bool = false, @ViewBuilder content: @escaping () -> Content) {
		self.title = title
		self.showBody = startOpen
		self.content = content
	}
	
	public var body: some View {
		
		VStack(spacing: 0) {
			
			HStack(alignment: .top, spacing: 0) {
				
				Text(title)
					.rijksoverheidStyle(font: .bold, style: .body)
					.accessibilityAddTraits(.isHeader)
				
				Spacer()
				
				Image(showBody ? ImageResource.Accordion.arrowUp : ImageResource.Accordion.arrowDown)
			}
			.foregroundColor(theme.contentPrimary)
			._onButtonGesture { pressed in
				self.onHover = pressed
			} perform: {
				withAnimation {
					showBody.toggle()
				}
			}
			
			if showBody {
				content()
					.padding(.top, 16)
			}
		}
		.padding(16)
		.background(onHover ? theme.backgroundTertiary : theme.backgroundSecondary)
		.shadow(color: theme.contentPrimary.opacity(0.05), radius: 1, x: 0, y: 1)
		.overlay(
			RoundedRectangle(cornerRadius: 8)
				.inset(by: 0.5)
				.stroke(theme.linesPrimary, lineWidth: 1)
		)
	}
}

#Preview {
	AccordionView(title: "The title of the accordion") { Text("Body") }
}
