/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import RestrictedBrowser

class InAppBrowserViewModel: ObservableObject {
	
	/// The app coordintator for routing
	weak var coordinator: (any AppCoordinatorProtocol)?
	
	@Published var browser: RestrictedBrowser
	@Published var title: LocalizedStringKey?
	@Published var url: URL
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(url: URL, browser: RestrictedBrowser, title: LocalizedStringKey?, coordinator: (any AppCoordinatorProtocol)? = nil) {
		
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
				coordinator?.handle(AppCoordination.Action.backButtonPressed)
		}
	}
}

struct InAppBrowserView: View {
	
	@StateObject var viewModel: InAppBrowserViewModel
	
	var body: some View {
		
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			RestricedBrowserView(viewModel: RestricedBrowserViewModel(url: viewModel.url, browser: viewModel.browser))
		}
		.navigationTitle(viewModel.title ?? "")
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
	}
}
