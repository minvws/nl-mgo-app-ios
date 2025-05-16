/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
				
				Spacer()
				
				Image(ImageResource.Accordion.arrowUp)
					.accessibilityLabel(showBody ? Bundle.module.localizedString(forKey: "expanded", value: nil, table: "Accordion") : Bundle.module.localizedString(forKey: "collapsed", value: nil, table: "Accordion"))
					.rotationEffect(showBody ? .zero : Angle(degrees: 90))
					.accessibilityRemoveTraits(.isImage)
					.accessibilityAddTraits(.isButton)
			}
			.foregroundColor(theme.contentPrimary)
			.when(!UIAccessibility.isVoiceOverRunning, transform: { view in
				view
					.contentShape(Rectangle())
				// Make the whole HStack tappable when voiceover is disable.
				// Without this weird hack, the first element did not respond to a tap in voiceover
			})
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
				.stroke(theme.borderPrimary, lineWidth: 1)
		)
	}
}

#Preview {
	
	VStack {
		AccordionView(title: "First section", startOpen: true) {
			Text(verbatim: "Details First Section. Starts expanded.")
		}
		
		AccordionView(title: "Second section") {
			Text(verbatim: "Details Second Section. Starts collapsed.")
		}
	}
}
