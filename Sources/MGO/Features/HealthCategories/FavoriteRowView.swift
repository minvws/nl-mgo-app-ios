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
	
	/// The action to be performed when the user presses this card
	var perform: (() -> Void)?
	
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
		enum General {
			static let padding: CGFloat = 16
		}
	}
	
	@State var hover = false
	
	var body: some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.Text.spacing) {
			HStack(alignment: .top, spacing: 0) {
				
				category.getIconWithBackground(theme: theme)
					.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size)
				
				Spacer()
				
				CategoryStateView(state: state)
			}
			
			Spacer()
			
			Text(category.localizedHeading())
				.typography(.bodyMedium)
				.foregroundColor(theme.labels.primary)
		}
		.frame(minHeight: ViewTraits.Category.minHeight)
		.accessibilityElement(children: .combine)
		.padding(ViewTraits.General.padding)
		.background(hover ? theme.backgrounds.tertiary : theme.backgrounds.secondary)
		._onButtonGesture { pressed in
			self.hover = pressed
		} perform: {
			perform?()
		}
	}
}
