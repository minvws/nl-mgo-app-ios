/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import LocalisationServiceClient

enum SearchResultViewState: Equatable {
	
	case loading
	case failure(Error)
	case success([SearchResult])
	case empty(city: String, name: String)

	static func == (lhs: SearchResultViewState, rhs: SearchResultViewState) -> Bool {
		switch (lhs, rhs) {
			case (.loading, .loading): return true
			case let(.failure(lhsError), .failure(rhsError)):
			return lhsError.localizedDescription == rhsError.localizedDescription
			case let(.success(lhsResults), .success(rhsResults)):
				return lhsResults == rhsResults
			case let(.empty(lhsCity, lhsName), .empty(rhsCity, rhsName)):
				return lhsCity == rhsCity && lhsName == rhsName
			default: return false
		}
	}
}

class SearchResultViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
//		case persist
		case retry
		case onAppear
	}
	
	/// The state of the view
	@Published var state: SearchResultViewState
	
	/// Search paramater name
	private var name: String
	
	/// Search paramater city
	private var city: String
	
	/// The flow coordintator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// The localisation service client
	private var localisationServiceClient: LocalisationServiceClientProtocol?
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any AppCoordinatorProtocol)?, city: String, name: String, localisationServiceClient: LocalisationServiceClientProtocol?) {
		self.coordinator = coordinator
		self.city = city
		self.name = name
		self.localisationServiceClient = localisationServiceClient
		self.state = .loading
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SearchResultViewModel.Action) {
		
		switch action {
			
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)

			case .onAppear:
				SwiftUI.Task {
					await loadHealthcareProviders()
				}
				
//			case .persist:
//				#warning("Todo: persist provider")
			
			case .retry:
				SwiftUI.Task {
					await loadHealthcareProviders()
				}
		}
	}
	
	@MainActor
	private func loadHealthcareProviders() async {
		
		state = .loading
		
		guard let localisationServiceClient else {
			state = .failure(LocalisationServiceClientError.noServer)
			return
		}
		
		do {
			
			let organisations = try await localisationServiceClient.searchHealthcareProviders(city: city, name: name)
			logDebug("We found \(organisations.count) organisations.")
			if organisations.isEmpty {
				state = .empty(city: city, name: name)
			} else {
				let results = SearchResultDecorator.create(organisations)
				state = .success(results)
			}
			
		} catch {
			logDebug("Error fetching orginasations \(error)")
			state = .failure(error)
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
				
				case let .empty(city: city, name: name):
					ErrorView(viewModel: SearchResultNoResultsViewModel(city: city, name: name) {
						viewModel.reduce(.backButtonPressed)
					})
					
				case .success(let results):
					listSearchResults(results)
			}
		}
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton("searchresults_backbutton") {
			viewModel.reduce(.backButtonPressed)
		})
	}
	
	@ViewBuilder func listSearchResults(_ list: [SearchResult]) -> some View {
		
		ScrollView {
			
			VStack(alignment: .leading) {
				
				Text("searchresults_loading_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
			
				LazyVStack(spacing: 8, content: {
					ForEach(list, id: \.self) { element in
						SearchResultCardView(element: element)
					}
				})
				
			}
			.padding(.horizontal, ViewTraits.General.padding)
		}
	}
}

#Preview {
	NavigationView {
		SearchResultView(viewModel: SearchResultViewModel(coordinator: nil, city: "Roermond", name: "Tandarts Tandje Erbij", localisationServiceClient: LocalisationServiceClient()))
	}
}
