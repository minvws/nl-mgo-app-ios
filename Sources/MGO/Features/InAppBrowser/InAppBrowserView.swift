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
	
	/// The restricted browser
	@Published var browser: RestrictedBrowser
	
	/// The title of the page
	@Published var title: LocalizedStringKey?
	
	/// The url to display
	@Published var url: URL
	
	/// The action to perform when closing the view
	private var closeAction: Coordination.Action
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
	}
	
	/// Create an inn app browser view model
	/// - Parameter coordinator: the app coordinator
	/// - Parameter url: the url to display
	/// - Parameter browser: restricted browser
	/// - Parameter title: the title of the page
	init(
		url: URL,
		browser: RestrictedBrowser,
		title: LocalizedStringKey?,
		coordinator: (any Coordinator)? = nil,
		closeAction: Coordination.Action = .backButtonPressed
	) {
		
		self.url = url
		self.browser = browser
		self.title = title
		self.coordinator = coordinator
		self.closeAction = closeAction
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: InAppBrowserViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(closeAction)
		}
	}
}

struct InAppBrowserView: View {
	
	/// The view model
	@StateObject var viewModel: InAppBrowserViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
		
		RestrictedBrowserView(
			viewModel: RestrictedBrowserViewModel(
				url: viewModel.url,
				browser: viewModel.browser,
				authUsername: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
				authPassword: Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String
			)
		)
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
				.accessibilityIdentifier("common.close")
		)
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
}
