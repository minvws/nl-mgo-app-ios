/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A view containing a privacy shield and a text (as localizesStringKey)
struct PrivacyShieldView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	@Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
	
	/// The possible shield images
	enum ShieldType {
		case encrypted
		case safety
		case checked
		case cross
		
		var image: ImageResource {
			switch self {
				case .encrypted:
					.Shields.encrypted
				case .safety:
					.Shields.plus
				case .checked:
					.Shields.checked
				case .cross:
					.Shields.cross
			}
		}
	}
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Text {
			static let leading: CGFloat = 16
		}
	}
	
	/// The key of the localized text to be displayed as title
	var title: LocalizedStringKey
	
	/// The shield type (image)
	var shieldType: ShieldType
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	init(_ title: LocalizedStringKey, shieldType: ShieldType) {
		self.title = title
		self.shieldType = shieldType
	}
	
	/// The alignment of the HStack, changes on orientation
	@State private var alignment: VerticalAlignment = .center
	
	var body: some View {
		
		HStack(alignment: alignment, spacing: 0) {
			
			Image(shieldType.image)
				.padding(.zero)
			
			Text(title)
				.rijksoverheidStyle(font: .regular, style: .body)
				.padding(.leading, ViewTraits.Text.leading)
				.foregroundStyle(theme.contentPrimary)
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.accessibilityElement(children: .combine)
		.onRotate { newOrientation in
			// The device orientation can be isFlat (faceUp or faceDown). Skip that
			guard !newOrientation.isFlat else { return }
			
			// Top on portrait, center on landscape
			alignment = newOrientation.isLandscape ? .center : .top
		}
		.onAppear {
			if verticalSizeClass != SwiftUI.UserInterfaceSizeClass.compact || UIDevice.current.userInterfaceIdiom == .pad {
				alignment = .top
			}
		}
	}
}

#Preview {
	PrivacyShieldView("proposition.statement_1", shieldType: .safety)
}
