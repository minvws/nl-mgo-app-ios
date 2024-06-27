/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

typealias SearchResultSet = (
	provider: HealthcareProvider,
	cardState: SearchResultCardState
)

enum SearchResultViewState: Equatable {
	
	case loading
	case failure(Error)
	case success([SearchResultSet])
	case empty(city: String, name: String)

	static func == (lhs: SearchResultViewState, rhs: SearchResultViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
			
			case let(.failure(lhsError), .failure(rhsError)):
					return lhsError.localizedDescription == rhsError.localizedDescription
			
			case let(.success(lhsResults), .success(rhsResults)):
				guard lhsResults.count == rhsResults.count else { return false}
				var result = true
				for index in lhsResults.indices {
					result = result && lhsResults[index].provider == rhsResults[index].provider
					result = result && lhsResults[index].cardState == rhsResults[index].cardState
				}
				return result
			
			case let(.empty(lhsCity, lhsName), .empty(rhsCity, rhsName)):
					return lhsCity == rhsCity && lhsName == rhsName
			
			default:
				return false
		}
	}
}

class SearchResultsViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case backToSearch
		case closeSheet
		case onAppear
		case retry
		case store(HealthcareProvider)
	}
	
	/// The state of the view
	@Published var state: SearchResultViewState
	
	/// Search parameter name
	private var name: String
	
	/// Search parameter city
	private var city: String
	
	/// array to store the results
	private var searchResultsList = [HealthcareProvider]()
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// The localisation service client
	private var localisationServiceClient: LocalisationServiceClientProtocol?
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any Coordinator)?, city: String, name: String, localisationServiceClient: LocalisationServiceClientProtocol?) {
		self.coordinator = coordinator
		self.city = city
		self.name = name
		self.localisationServiceClient = localisationServiceClient
		self.state = .loading
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SearchResultsViewModel.Action) {
		
		switch action {
			
			case .backToSearch:
				Current.notificationCenter.post(name: .clearSearch, object: nil)
				coordinator?.handle(Coordination.Action.backToAddHealthcareOrganization)
			
			case .backButtonPressed:
				coordinator?.handle(Coordination.Action.backButtonPressed)
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
			
			case .onAppear:
				if case SearchResultViewState.success = state {
					applyListState()
				}
			
				// Only load the first time
				guard state == .loading else { return }
			
				_Concurrency.Task {
					await loadHealthcareProviders()
				}
			
			case .retry:
				_Concurrency.Task {
					await loadHealthcareProviders()
				}
			
			case .store(let provider):
				try? Current.healthcareProviderStore.store(provider)
				if !(Current.secureUserSettings.userHasAddedHealthcareProvider) {
					Current.secureUserSettings.userHasAddedHealthcareProvider = true
				}
				applyListState()
				coordinator?.handle(Coordination.Action.finishedSearchingHealthcareProviders)
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
			searchResultsList = try await localisationServiceClient.searchHealthcareProviders(city: city, name: name)
			logDebug("We found \(searchResultsList.count) organisations.")
			
			applyListState()
			
		} catch {
			logDebug("Error fetching orginasations \(error)")
			state = .failure(error)
		}
	}
	
	/// Apply the state for each of the health providers
	func applyListState() {
		
		var list = [SearchResultSet]()
		searchResultsList.forEach {provider in
			let cardState = cardState(for: provider)
			
			list.append((
				provider: provider,
				cardState: cardState)
			)
		}
		if list.isEmpty {
			state = .empty(city: city, name: name)
		} else {
			state = .success(list)
		}
	}
	
	/// Get the state for a card
	/// - Parameter provider: the healthcare provider
	/// - Returns: card state
	private func cardState(for provider: HealthcareProvider) -> SearchResultCardState {

		let list = HealthcareProviderRepository().providers
		return list.contains(provider) ? .selected : .regular
	}
}

struct SearchResultsView: View {
	
	/// The view model
	@StateObject var viewModel: SearchResultsViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
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
		enum List {
			static let spacing: CGFloat = 8
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
		.if(isPresentedAsSheet, transform: { view in
			view
				.toolbar {
					ToolbarItem(content: { CloseButton {
						viewModel.reduce(.closeSheet)
					}})
				}
		})

		.navigationBarItems(leading: BackButton("searchresults_backbutton") {
			viewModel.reduce(.backButtonPressed)
		})

		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
	
	@ViewBuilder func listSearchResults(_ list: [SearchResultSet]) -> some View {
		
		ScrollView {
			
			VStack(alignment: .leading) {
				
				Text("searchresults_loading_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
			
				LazyVStack(spacing: ViewTraits.List.spacing) {
					
					ForEach(list, id: \.provider) { element in
						
						ZStack {
							
							Rectangle()
								.foregroundStyle(.clear)
								.accessibilityLabel(
									String(
										format: String(
											localized: element.cardState.accessibilityLabel),
										arguments: ["\(element.provider.display_name)"]
									)
								)
								.accessibilityAddTraits(.isButton)
							
							SearchResultCardView(
								model: SearchResultDecorator.create(element.provider),
								state: element.cardState,
								perform: {
									viewModel.reduce(.store(element.provider))
								}
							)
						}
					}
				}
			}
			.padding(.horizontal, ViewTraits.General.padding)
		}
		.padding(.top, ViewTraits.Navigation.padding)
	}
}

#Preview {
	
	let spy = LocalisationServiceClientSpy()
	spy.stubbedSearchHealthcareProviders = [
		PreviewContent.healthcareOrganization,
		HealthcareProvider(
			display_name: "Tandartsenpraktijk Willem II Roermond B.V.",
			identification_type: "type",
			identification_value: "2",
			active: true,
			addresses: [Components.Schemas.Address(
				active: true,
				address: "Boorplatform 5",
				city: "Roermond",
				lines: ["Boorplatform 5"],
				postalcode: "1234AB",
				_type: "postal")
			],
			names: [],
			types: [],
			data_services: []
		)
	]
	
	return NavigationView {
		SearchResultsView(viewModel: SearchResultsViewModel(coordinator: nil, city: "Roermond", name: "Tandarts Tandje Erbij", localisationServiceClient: spy))
	}
}
