/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct HealthCategoryRowView: View {
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// The category to display
	var category: SharedHealthCategories.Category
	
	/// The state
	var state: CategoryState
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Category {
			static let minHeight: CGFloat = 56
		}
		enum Text {
			static let spacing: CGFloat = 4
		}
		enum Icon {
//			static let size: CGFloat = 32
			static let padding: CGFloat = 16
		}
		enum Spinner {
			static let size: CGFloat = 22
			static let minWidth: CGFloat = 24
		}
	}
	
	var body: some View {
		
		HStack(alignment: .top, spacing: 0) {
			
			HealthCategoryIconView(category: category, state: state)
				.padding(.trailing, ViewTraits.Icon.padding)
			
			VStack(alignment: .leading, spacing: ViewTraits.Text.spacing) {
				
				Text(category.localizedHeading())
					.typography(.bodyMedium, with: .bold)
					.foregroundColor(theme.labels.primary)
					
				Text(category.localizedSubheading())
					.typography(.bodyMedium)
					.foregroundColor(theme.labels.secondary)
			}
			
			Spacer()
			
			VStack(alignment: .trailing) {
				CategoryStateView(state: state)
			}
			.frame(minWidth: ViewTraits.Spinner.minWidth)
		}
		.frame(minHeight: ViewTraits.Category.minHeight)
		.accessibilityElement(children: .combine)
	}
}
