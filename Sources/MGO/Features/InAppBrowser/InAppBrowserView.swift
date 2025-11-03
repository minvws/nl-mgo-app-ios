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
		case closeButtonPressed
	}
	
	/// Create an inn app browser view model
	/// - Parameter coordinator: the app coordinator
	/// - Parameter url: the url to display
	/// - Parameter browser: restricted browser
	/// - Parameter title: the title of the page
	@MainActor init(
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
			case .closeButtonPressed:
				coordinator?.handle(closeAction)
		}
	}
}

struct InAppBrowserView: View {
	
	/// The view model
	@StateObject var viewModel: InAppBrowserViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
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
		.toolbar(content: leadingToolbarContent)
		.background(theme.backgrounds.primary.ignoresSafeArea())
	}
	
	/// Get the leading toolbar content
	/// - Returns: the toolbar content
	@ToolbarContentBuilder private func leadingToolbarContent() -> some ToolbarContent {
		
		let closeKey: LocalizedStringKey = "common.close"
		
		ToolbarItem(placement: .cancellationAction) {
			if osVersionChecker.available(version: .iOS(.v26)) {
				if #available(iOS 26.0, *) {
					Button(role: .close) {
						viewModel.reduce(.closeButtonPressed)
					}
					.accessibilityLabel(closeKey)
					.accessibilityIdentifier(closeKey.stringKey)
				}
			} else {
				Button {
					viewModel.reduce(.closeButtonPressed)
				} label: {
					Text(closeKey)
						.typography(.bodyMedium)
				}
				.buttonStyle(BackButtonStyle())
				.accessibilityLabel(closeKey)
				.accessibilityIdentifier(closeKey.stringKey)
			}
		}
	}
}
