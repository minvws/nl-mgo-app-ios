/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct DisclosureWithImageButton: View {
	
	/// The title for the button
	var title: LocalizedStringKey
	
	/// The image for the button
	var image: ImageResource
	
	/// Should we show a border around the image?
	var showImageBorder: Bool = false
	
	/// The action to perform
	var action: (() -> Void)?
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Image {
			static let size: CGFloat = 32
		}
		enum Chevron {
			static let size: CGFloat = 32
		}
		enum General {
			static let padding: CGFloat = 16
			static let radius: CGFloat = 8
		}
	}
	
	/// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
		
		Button(action: {
			action?()
		}, label: {
			
			HStack(alignment: .center, spacing: 0) {
				
				Rectangle()
					.when(showImageBorder, transform: { view in
						view
							.overlay {
								Rectangle()
									.inset(by: 1)
									.stroke(theme.linesPrimary, lineWidth: 1)
									.clipShape(RoundedRectangle(cornerRadius: 3))
							}
					})
					.foregroundColor(.clear)
					.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
				
					.background(
						Image(image)
							.resizable()
							.aspectRatio(contentMode: .fill)
							.frame(width: ViewTraits.Image.size, height: ViewTraits.Image.size)
					)
				
				Text(title)
					.rijksoverheidStyle(font: .bold, style: .body)
					.foregroundColor(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .leading)
					.padding(.leading, ViewTraits.General.padding)
				
				Image(ImageResource.Localisation.arrowForward)
					.foregroundStyle(theme.iconsPrimary)
					.frame(width: ViewTraits.Chevron.size, height: ViewTraits.Chevron.size, alignment: .center)
				
			}
			.frame(maxWidth: .infinity, alignment: .leading)
			.cardify(setBackground: false)
		})
		.buttonStyle(HoverButtonStyle())
		.clipShape(RoundedRectangle(cornerRadius: ViewTraits.General.radius))
	}
}

#Preview {
	
	DisclosureWithImageButton(title: "title", image: ImageResource.RemoteAuthentication.digid)
}
