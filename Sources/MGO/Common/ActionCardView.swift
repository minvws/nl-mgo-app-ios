/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// The various Icons for an action card
enum ActionCardIcon {
	
	case diagnoses
	case medication
	case remove
	case results
	case none
	
	/// The image to use for the category
	var image: ImageResource? {
		switch self {
			case .diagnoses:
				return ImageResource.Details.diagnoses
			
			case .medication:
				return ImageResource.Details.medication
			
			case .remove:
				return ImageResource.Details.trashcan
		
			case .results:
				return ImageResource.Details.results
		
			case .none:
				return nil
		}
	}
	
	/// The color for the icon background
	var backgroundColor: Color? {
		switch self {
			case .diagnoses:
				return Theme().tandarts
			case .medication:
				return Theme().verpleeghuis
			case .remove:
				return Theme().notificationError
			case .results:
				return Theme().fysiotherapeut
			case .none:
				return nil
		}
	}
}

struct ActionCardView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The title of the card
	var title: LocalizedStringKey
	
	/// The body of the card
	var message: LocalizedStringKey
	
	/// The action icon
	var icon: ActionCardIcon = .none
	
	/// has the user pressed (but no released) the button
	@State private var onHover = false
	
	/// The action to be performed when the user presses this card
	var perform: (() -> Void)?
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
			static let spacing: CGFloat = 8
		}
		enum Icon {
			static let size: CGFloat = 32.0
		}
	}
	
	var body: some View {
		
		VStack(spacing: 0) {
			
			HStack(alignment: .center, spacing: 0) {
				
				if icon != .none,
				   let image = icon.image,
				   let backgroundColor = icon.backgroundColor {
					
					Image(image)
						.foregroundStyle(theme.backgroundSecondary)
						.background(backgroundColor)
						.cornerRadius(50)
					
					Spacer(minLength: ViewTraits.General.padding)
				}
				
				VStack(alignment: .leading, spacing: ViewTraits.General.spacing) {
					
					Text(title)
						.rijksoverheidStyle(font: .bold, style: .body)
						.multilineTextAlignment(.leading)
						.foregroundColor(theme.contentPrimary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
					Text(message)
						.rijksoverheidStyle(font: .regular, style: .body)
						.multilineTextAlignment(.leading)
						.foregroundColor(theme.contentSecondary)
						.frame(maxWidth: .infinity, alignment: .topLeading)
				}
				
				Image(ImageResource.Overview.chevronRight)
					.foregroundStyle(theme.iconsPrimary)
					.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size, alignment: .center)
					.accessibilityHidden(true)
				
			}
			.accessibilityElement(children: .combine)
			.padding(ViewTraits.General.padding)
			.background(onHover ? theme.backgroundTertiary : theme.backgroundSecondary)
			
		}
		._onButtonGesture { pressed in
			self.onHover = pressed
		} perform: {
			perform?()
		}
	}
}

#Preview {
	VStack(spacing: 4) {
		ActionCardView(
			title: "medication_use.heading",
			message: "medication_use.subheading",
			icon: ActionCardIcon.medication
		)
	}
}
