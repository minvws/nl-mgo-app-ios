/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct HealthCategoryRowView: View {
	
	/// The Theme
	@Environment(\.theme) var theme
	
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
			static let size: CGFloat = 32
			static let padding: CGFloat = 16
		}
		enum Spinner {
			static let size: CGFloat = 22
		}
	}
	
	var body: some View {
		
		HStack(alignment: .top, spacing: 0) {
			
			category.getIcon(theme)
				.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size)
				.padding(.trailing, ViewTraits.Icon.padding)
			
			VStack(alignment: .leading, spacing: ViewTraits.Text.spacing) {
				
				Text(category.localizedHeading())
					.typography(.bodyMedium, isBold: true)
					.foregroundColor(theme.labels.primary)
					.background(.green)
				
				if state == .empty {
					
					Text("common.no_data")
						.typography(.bodyMedium)
						.foregroundColor(theme.labels.secondary)
					
				} else {
					
					Text(category.localizedSubheading())
						.typography(.bodyMedium)
						.foregroundColor(theme.labels.secondary)
					
				}
			}
			
			Spacer()
			
			VStack {
				switch state {
					case .loaded:
						Image(systemName: "chevron.right")
							.foregroundStyle(theme.symbols.secondary)
							.frame(width: 12, height: 22)
					
					case .loading:
						ProgressView()
							.progressViewStyle(.circular)
							.frame(width: ViewTraits.Spinner.size, height: ViewTraits.Spinner.size)
							.tint(theme.symbols.secondary)
					
					default:
						EmptyView()
				}
			}
		}
		.frame(minHeight: ViewTraits.Category.minHeight)
		.accessibilityElement(children: .combine)
	}
}
