/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

/// A view containing a privacy shield and a text (as localizesStringKey)
struct PrivacyShieldView: View {
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// The possible shield images
	enum ShieldType {
		case secure
		case personal
		case storage
		case control
		
		var image: ImageResource {
			switch self {
				case .secure:
					.Shields.encrypted
				case .personal:
					.Shields.checked
				case .storage:
					.Shields.cloud
				case .control:
					.Shields.control
			}
		}
	}
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Text {
			static let leading: CGFloat = 16
			static let padding: CGFloat = 4
		}
	}
	
	/// The key of the localized text to be displayed as heading
	var heading: LocalizedStringKey
	
	/// The key of the localized text to be displayed as sub heading
	var subHeading: LocalizedStringKey
	
	/// The shield type (image)
	var shieldType: ShieldType
	
	/// Initializer
	/// - Parameter title: The key of the localized text to be displayed as title
	init(
		_ title: LocalizedStringKey,
		subHeading: LocalizedStringKey,
		shieldType: ShieldType
	) {
		self.heading = title
		self.subHeading = subHeading
		self.shieldType = shieldType
	}
	
	var body: some View {
		
		HStack(alignment: .center, spacing: 0) {
			
			Image(shieldType.image)
				.foregroundStyle(theme.categories.rijkslint)
				.padding(.zero)
			
			VStack(
				alignment: .leading,
				spacing: ViewTraits.Text.padding,
				content: {
					Text(heading)
						.typography(.bodyMedium, with: .bold)
						.padding(.leading, ViewTraits.Text.leading)
						.foregroundStyle(theme.labels.primary)
					
					Text(subHeading)
						.typography(.bodyMedium)
						.padding(.leading, ViewTraits.Text.leading)
						.foregroundStyle(theme.labels.secondary)
				}
			)
		}
		.frame(maxWidth: .infinity, alignment: .topLeading)
		.accessibilityElement(children: .combine)
	}
}

#Preview {
	PrivacyShieldView(
		"proposition.statement.heading_1",
		subHeading: "proposition.statement.subheading_1",
		shieldType: .secure
	)
}
