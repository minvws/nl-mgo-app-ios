/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI

public struct LoadingCardView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
	}
	
	/// The title of the loading card
	private var title: LocalizedStringKey
	
	/// Should we show the border?
	private var showBorder: Bool
	
	/// Initializer
	/// - Parameter title: the title for the card
	/// - Parameter showBorder: Should we show the border?
	public init( title: LocalizedStringKey, showBorder: Bool = true) {
		self.title = title
		self.showBorder = showBorder
	}
	
	/// Progress for the spinner
	@State private var progress: Double = 0

	public var body: some View {
		
		GeometryReader { geometry in
			
			HStack { // HStack to center the loader + Text
				Spacer()
				
				VStack {
					CircularProgressView(progress: $progress)
						.frame(width: 48, height: 48)
						.padding(.bottom, 20)
					
					Text(title)
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundColor(theme.contentPrimary)
						.frame(maxWidth: .infinity, alignment: .center)
				}
				.frame(maxHeight: .infinity) // Make the view take all its height.
				Spacer()
			}

			.accessibilityElement(children: .combine)
			.padding(.horizontal, ViewTraits.General.padding)
			.onAppear(perform: {
				progress = 1
			})
			.when(showBorder, transform: { view in
				view
					.cardify()
			})
			.frame(width: geometry.size.width, height: geometry.size.width) // Make the view square
		}
	}
}

#Preview {
	NavigationView {
		LoadingCardView(title: "Aan het laden")
	}
}
