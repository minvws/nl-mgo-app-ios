/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct AutomaticLoadingSearchResultsView: View {

	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
			static let opacity: CGFloat = 0.6
		}
	}
	
	var body: some View {
		VStack {
			
			Spacer()
			
			ProgressView("organization_search.searching")
				.tint(theme.contentPrimary.opacity(ViewTraits.General.opacity))
				.rijksoverheidStyle(font: .regular, style: .body)
			
			Spacer()
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.frame(maxWidth: .infinity)
	}
}

#Preview {
	NavigationView {
		AutomaticLoadingSearchResultsView()
	}
}
