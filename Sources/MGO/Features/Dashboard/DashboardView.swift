/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class DashboardViewModel: ObservableObject {
	
}

struct DashboardView: View {
	
	/// The View Model
	@StateObject var viewModel: DashboardViewModel
	
	// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
			TabView {
				
				Group {
					
					OverviewView(viewModel: OverviewViewModel(coordinator: nil))
						.tabItem {
							HStack {
								Text("tab_overview")
									.rijksoverheidStyle(font: .regular, style: .body)
								Image(ImageResource.Tab.overview)
							}
						}
					
					AboutTheAppView(viewModel: AboutTheAppViewModel(coordinator: nil))
						.tabItem {
							HStack {
								Text("tab_about")
									.rijksoverheidStyle(font: .regular, style: .body)
								Image(ImageResource.Tab.about)
							}
						}
				}
				.backportToolbarBackground()
			}
			.foregroundColor(theme.iconsPrimary)
			.accentColor(theme.actionTertiaryDefault)
			.navigationBarBackButtonHidden()
	}
}

#Preview {
	DashboardView(viewModel: DashboardViewModel())
}
