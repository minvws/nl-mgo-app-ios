/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

enum SearchResultViewState {
	case loading
	case failure(Error)
	case success([SearchResult])
}

class SearchResultViewModel: ObservableObject {
	
	@Published var name: String
	@Published var city: String
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case persist
		case retry
		case onAppear
	}
	
	@Published var state: SearchResultViewState
	
	/// The flow coordintator for routing
	@Published private  var coordinator: (any AppCoordinatorProtocol)?
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any AppCoordinatorProtocol)?, city: String, name: String) {
		self.coordinator = coordinator
		self.city = city
		self.name = name
		
		self.state = .failure(NSError(domain: "test error", code: 12345))
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SearchResultViewModel.Action) {
		
		switch action {
			
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .onAppear:
				#warning("Todo: onAppear")
				
			case .persist:
				#warning("Todo: persist provider")
			
			case .retry:
				#warning("Todo: retry loading")

		}
	}
}

struct SearchResultView: View {
	
	/// The view model
	@StateObject var viewModel: SearchResultViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Image {
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ZStack {
			
			theme.backgroundPrimary
				.ignoresSafeArea()
			
			switch viewModel.state {
				case .loading:
					SearchResultsLoadingView()
			
				case .failure:
				
					ErrorView(viewModel: ErrorViewModel {
						viewModel.reduce(.retry)
					})
				
			case .success(let array):
				if array.isEmpty {
					Spacer()
				} else {
					//				VStack {
					//					Text(viewModel.name)
					//					Text(viewModel.city)
					//					Spacer()
					//				}
					//				Spacer()
					Spacer()
				}
			}
			//
		}
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton("searchresults_backbutton") {
			viewModel.reduce(.backButtonPressed)
		})
	}
}

#Preview {
	NavigationView {
		SearchResultView(viewModel: SearchResultViewModel(coordinator: nil, city: "Roermond", name: "Tandarts Tandje Erbij"))
	}
}
