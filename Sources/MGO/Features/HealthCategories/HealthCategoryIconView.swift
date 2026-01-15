/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
	
struct HealthCategoryIconView: View {
	
	var category: SharedHealthCategories.Category
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Icon {
			static let size: CGFloat = 32
		}
	}
	
	var body: some View {
	
		category.getIconWithBackground(theme: theme)
			.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size)
	}
	
}
