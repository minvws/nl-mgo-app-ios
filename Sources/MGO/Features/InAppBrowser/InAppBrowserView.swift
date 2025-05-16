/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import RestrictedBrowser

class InAppBrowserViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	@Published var browser: RestrictedBrowser
	@Published var title: LocalizedStringKey?
	@Published var url: URL
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(url: URL, browser: RestrictedBrowser, title: LocalizedStringKey?, coordinator: (any Coordinator)? = nil) {
		
		self.url = url
		self.browser = browser
		self.title = title
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: InAppBrowserViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(Coordination.Action.backButtonPressed)
		}
	}
}

struct InAppBrowserView: View {
	
	/// The view model
	@StateObject var viewModel: InAppBrowserViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
		
		RestrictedBrowserView(viewModel: RestrictedBrowserViewModel(url: viewModel.url, browser: viewModel.browser))
		.navigationTitle(viewModel.title ?? "")
		.navigationBarBackButtonHidden(true)
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarItems(
			leading:
				Button(
					action: {
						viewModel.reduce(.backButtonPressed)
					},
					label: {
						Text("common.close")
							.rijksoverheidStyle(font: .regular, style: .headline)
					}
				)
				.buttonStyle(BackButtonStyle())
				.tag("close_view")
				.accessibilityIdentifier("common.close")
		)
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
}
