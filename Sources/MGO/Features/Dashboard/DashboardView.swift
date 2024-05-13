/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

enum DashboardTab {
	case about
	case overview
}

class DashboardViewModel: ObservableObject {
	
	/// The flow coordinator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any AppCoordinatorProtocol)?) {
		self.coordinator = coordinator
	}

	@ViewBuilder func tab(for tab: DashboardTab) -> some View {
		
		switch tab {
			case .about:
				AboutTheAppView(viewModel: AboutTheAppViewModel(coordinator: self.coordinator))
					.tabItem {
						HStack {
							Text("tab_about")
								.rijksoverheidStyle(font: .regular, style: .body)
							Image(ImageResource.Tab.about)
						}
					}
			case .overview:
				OverviewView(viewModel: OverviewViewModel(coordinator: self.coordinator))
					.tabItem {
						HStack {
							Text("tab_overview")
								.rijksoverheidStyle(font: .regular, style: .body)
							Image(ImageResource.Tab.overview)
						}
					}
		}
	}
}

struct DashboardView: View {
	
	/// The View Model
	@StateObject var viewModel: DashboardViewModel
	
	// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
			TabView {
				
				Group {
					viewModel.tab(for: .overview)
					viewModel.tab(for: .about)
				}
				.backportToolbarBackground()
			}
			.foregroundColor(theme.iconsPrimary)
			.accentColor(theme.actionTertiaryDefault)
			.navigationBarBackButtonHidden()
	}
}

#Preview {
	DashboardView(viewModel: DashboardViewModel(coordinator: nil))
}
