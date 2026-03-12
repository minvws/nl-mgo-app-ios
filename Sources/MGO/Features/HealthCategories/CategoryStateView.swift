/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct CategoryStateView: View {
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// The state
	var state: CategoryState
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Accessory {
			static let size: CGFloat = 22
		}
	}
	
	/// The category state view
	var body: some View {
		
		switch state {
			case .loaded:
				Image(ImageResource.Icon.chevron)
					.foregroundStyle(theme.symbols.secondary)
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
					.tint(theme.symbols.secondary)
				
			case .clientError, .serverError:
				Image(ImageResource.Icon.syncProblem)
					.foregroundStyle(theme.symbols.primary)
					.frame(
						width: ViewTraits.Accessory.size,
						height: ViewTraits.Accessory.size
					)
				
			case .empty:
				Text("common.no_data")
					.typography(.bodySmall)
					.foregroundStyle(theme.labels.secondary)
				
			default:
				Spacer()
		}
	}
}
