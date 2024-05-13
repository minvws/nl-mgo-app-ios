/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class TabViewModel: ObservableObject {
	
}

struct MainTabView: View {
	
	/// The View Model
	@StateObject var viewModel: TabViewModel
	
	// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
			TabView {
				
				Group {
					
					OverviewView(viewModel: OverviewViewModel(coordinator: nil))
					//			Text("tab_overview")
						.tabItem {
							HStack {
								Text("tab_overview")
									.rijksoverheidStyle(font: .regular, style: .body)
								Image(ImageResource.Tab.overview)
							}
						}
					
					Text("tab_about")
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
	MainTabView(viewModel: TabViewModel())
}
