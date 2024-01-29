/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import SwiftUI
import GifzUI

/// A simple backbutton consisting of an left chevron and a previous text
struct BackButton: View {
	@Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let width: CGFloat = 12
			static let height: CGFloat = 20
			static let padding: CGFloat = 8
		}
	}
	
	/// The key of the localized text to be displayed as title
	var title: LocalizedStringKey
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	init(_ title: LocalizedStringKey = "previous") {
		self.title = title
	}
	
	var body: some View {
		Button(
			action: {
				self.presentationMode.wrappedValue.dismiss()
			},
			label: {
				HStack(alignment: .center, spacing: 0) {
					
					Image(.backArrow)
						.resizable()
						.frame(width: ViewTraits.Image.width, height: ViewTraits.Image.height)
						.tint(.skyBlue)
						.padding(.trailing, ViewTraits.Image.padding)
					
					Text(title)
						.rijksoverheidStyle(font: .regular, style: .headline)
						.foregroundColor(.skyBlue)
				}
			}
		)
	}
}

#Preview {
	BackButton()
}
