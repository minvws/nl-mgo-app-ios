/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class SearchResultViewModel: ObservableObject {
	
	@Published var name: String
	@Published var city: String
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case persist
		case backButtonPressed
	}
	
//	@Published var state: SearchViewState = SearchViewState()
	
	/// The flow coordintator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any AppCoordinatorProtocol)?, city: String, name: String) {
		self.coordinator = coordinator
		self.city = city
		self.name = name
		
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SearchResultViewModel.Action) {
		
		switch action {
			case .persist:
				#warning("Todo: persist provider")
				break
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
		}
	}
}

struct SearchResultView: View {
	
	/// The view model
	@StateObject var viewModel: SearchResultViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
		
		ZStack {
			
			theme.backgroundPrimary
				.ignoresSafeArea()
			
			VStack {
				Text(viewModel.name)
				Text(viewModel.city)
			}
			
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
	}
}

#Preview {
	NavigationView {
		SearchResultView(viewModel: SearchResultViewModel(coordinator: nil, city: "Roermond", name: "Tandarts Tandje Erbij"))
	}
}
