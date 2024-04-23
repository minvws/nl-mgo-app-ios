/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct SearchResultsLoadingView: View {

	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
	}
	
	/// Progress for the spinner
	@State private var progress: Double = 0

	var body: some View {
		VStack {
			
			Text("searchresults_loading_title")
				.rijksoverheidStyle(font: .bold, style: .title)
				.foregroundStyle(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
			
			Spacer()
	
			CircularProgressView(progress: $progress)
				.frame(width: 48, height: 48)
				.padding(.bottom, 20)
			
			Text("searchresults_loading_body")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
			
			Spacer()
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.onAppear(perform: {
			progress = 1
		})
	}
}

#Preview {
	NavigationView {
		SearchResultsLoadingView()
	}
}
