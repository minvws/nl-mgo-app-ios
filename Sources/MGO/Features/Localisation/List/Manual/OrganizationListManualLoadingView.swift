/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct OrganizationListManualLoadingView: View {

	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	/// Progress for the spinner
	@State private var progress: Double = 0
	
	@State private var showSpinner = false

	var body: some View {
		VStack {
			
			Text("organization_search.heading")
				.rijksoverheidStyle(font: .bold, style: .title)
				.foregroundStyle(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
			
			Spacer()
	
			if showSpinner {
				VStack {
					CircularProgressView(progress: $progress)
						.frame(width: 48, height: 48)
						.padding(.bottom, 20)
					
					Text("organization_search.searching")
						.rijksoverheidStyle(font: .regular, style: .body)
						.foregroundStyle(theme.contentPrimary)
				}
			}
			Spacer()
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.padding(.top, ViewTraits.Navigation.padding)
		.onAppear {
			delay(0.01) {
				showSpinner = true
			}
		}
		.when(showSpinner) { view in
			view
				.onAppear(perform: {
					progress = 1
				})
		}
	}
}

#Preview {
	NavigationView {
		OrganizationListManualLoadingView()
	}
}
