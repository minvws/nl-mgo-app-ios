/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct FavoriteRowView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// The category to display
	var category: SharedHealthCategories.Category
	
	/// The state
	var state: CategoryState
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Category {
			static let minHeight: CGFloat = 84
		}
		enum Text {
			static let spacing: CGFloat = 8
		}
		enum Icon {
			static let size: CGFloat = 32
		}
		enum Accessory {
			static let size: CGFloat = 22
		}
	}
	
	var body: some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.Text.spacing) {
			HStack(alignment: .top, spacing: 0) {
				
				category.getIcon(theme)
					.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size)
				
				Spacer()
				
				switch state {
					case .loaded:
						Image(systemName: "chevron.right")
							.foregroundStyle(theme.symbolSecondary)
							.frame(
								width: ViewTraits.Accessory.size,
								height: ViewTraits.Accessory.size
							)
						
					case .loading:
						ProgressView()
							.progressViewStyle(.circular)
							.frame(
								width: ViewTraits.Accessory.size,
								height: ViewTraits.Accessory.size
							)
							.tint(theme.symbolSecondary)
						
					default:
						EmptyView()
				}
			}
			
			Spacer()
			
			Text(String(localized: String.LocalizationValue(stringLiteral: category.heading)))
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundColor(theme.labels.primary)
		}
		.frame(minHeight: ViewTraits.Category.minHeight)
		.accessibilityElement(children: .combine)
	}
}
