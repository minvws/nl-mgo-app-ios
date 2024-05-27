/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct MedicationLoadingView: View {
	
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
	
	/// Initializer
	/// - Parameter title: the title for the card
	public init( title: LocalizedStringKey) {
		self.title = title
	}
	
	/// Progress for the spinner
	@State private var progress: Double = 0

	var body: some View {
		
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
			.cardify()
			.frame(width: geometry.size.width, height: geometry.size.width) // Make the view square
		}
	}
}

#Preview {
	NavigationView {
		MedicationLoadingView(title: "Aan het laden")
	}
}
