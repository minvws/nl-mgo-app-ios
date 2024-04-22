/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import LocalisationServiceClient

enum SearchResultViewState {
	case loading
	case failure(Error)
	case success([SearchResult])
	case empty(city: String, name: String)
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
	private  var coordinator: (any AppCoordinatorProtocol)?
	
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
				SwiftUI.Task {
					await load()
				}
				
//			case .persist:
//				#warning("Todo: persist provider")
			
			case .retry:
				loadHealthcareProviders()

		}
	}
	
	@MainActor
	private func load() async {
		
		state = .loading
		
		do {
			let client = try LocalisationServiceClient()
			let organisations = try await client.searchHealthcareProviders(city: city, name: name)
			logDebug("We found \(organisations.count) organisations. ")
			if organisations.isEmpty {
				state = .empty(city: city, name: name)
			} else {
				// Todo
			}
			
		} catch {
			logDebug("Error fetching orginasations \(error)")
			state = .failure(error)
		}
	}
	
	private func loadHealthcareProviders() {
		
		state = .loading
		
//		delay(1.5) {
			self.state = .success([
				SearchResult(id: "1", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB"),
				SearchResult(id: "2", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB"),
				SearchResult(id: "3", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB"),
				SearchResult(id: "4", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB"),
				SearchResult(id: "5", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB"),
				SearchResult(id: "6", name: "Tandarts Tandje Erbij", city: "Roermond", address: "Boorplatform 5", postalCode: "1234AB")
			])
//		}
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
		SearchResultView(viewModel: SearchResultViewModel(coordinator: nil, city: "Roermond", name: "Tandarts Tandje Erbij"))
	}
}
