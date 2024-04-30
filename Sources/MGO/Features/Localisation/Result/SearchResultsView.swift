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
	case success([HealthcareProvider])
	case empty(city: String, name: String)

	static func == (lhs: SearchResultViewState, rhs: SearchResultViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
			
			case let(.failure(lhsError), .failure(rhsError)):
					return lhsError.localizedDescription == rhsError.localizedDescription
			
			case let(.success(lhsResults), .success(rhsResults)):
					return lhsResults == rhsResults
			
			case let(.empty(lhsCity, lhsName), .empty(rhsCity, rhsName)):
					return lhsCity == rhsCity && lhsName == rhsName
			
			default:
				return false
		}
	}
}

class SearchResultViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case retry
		case onAppear
		case backToSearch
		case store
	}
	
	/// The state of the view
	@Published var state: SearchResultViewState
	
	/// Search paramater name
	private var name: String
	
	/// Search paramater city
	private var city: String
	
	/// The flow coordinator for routing
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
			
			case .backToSearch:
				Current.notificationCenter.post(name: .clearSearch, object: nil)
				coordinator?.handle(.backToSearchHealthcareProvider)
			
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)

			case .onAppear:
				SwiftUI.Task {
					await loadHealthcareProviders()
				}
			
			case .retry:
				SwiftUI.Task {
					await loadHealthcareProviders()
				}
			
			case .store:
				coordinator?.handle(.storeHealthcareProvider)
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
				state = .success(organisations)
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
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	var body: some View {
		
		Group {
			
			switch viewModel.state {
				case .loading:
					SearchResultsLoadingView()
			
				case .failure:
					ErrorView(viewModel: ErrorViewModel {
						viewModel.reduce(.retry)
					})
				
				case let .empty(city: city, name: name):
					ErrorView(viewModel: SearchResultNoResultsViewModel(city: city, name: name) {
						viewModel.reduce(.backToSearch)
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
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
	
	@ViewBuilder func listSearchResults(_ list: [HealthcareProvider]) -> some View {
		
		ScrollView {
			
			VStack(alignment: .leading) {
				
				Text("searchresults_loading_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
			
				LazyVStack(spacing: 8, content: {
					ForEach(list, id: \.self) { element in
						
						Button {
							viewModel.reduce(.store)
						} label: {
							SearchResultCardView(element: SearchResultDecorator.create(element), state: .regular)
						}
					}
				})
				
			}
			.padding(.horizontal, ViewTraits.General.padding)
		}
		.padding(.top, ViewTraits.Navigation.padding)
	}
}

#Preview {
	
	let spy = LocalisationServiceClientSpy()
	spy.stubbedSearchHealthcareProviders = [
		HealthcareProvider(
			display_name: "Tandarts Tandje Erbij",
			identification_type: "type",
			identification_value: "value",
			active: true,
			addresses: [Components.Schemas.Address(
				active: true,
				address: "Boorplatform 5",
				city: "Roermond",
				postalcode: "1234AB",
				_type: "postal")
			],
			names: [],
			types: []
		)
	]
	
	return NavigationView {
		SearchResultView(viewModel: SearchResultViewModel(coordinator: nil, city: "Roermond", name: "Tandarts Tandje Erbij", localisationServiceClient: spy))
	}
}
