/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

typealias OrganizationListSet = (
	organization: MgoOrganization,
	cardState: OrganizationListCardState
)

enum OrganizationListViewState: Equatable {
	
	case loading
	case failure(Error)
	case success([OrganizationListSet])
	case empty(city: String, name: String)

	static func == (lhs: OrganizationListViewState, rhs: OrganizationListViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
			
			case let(.failure(lhsError), .failure(rhsError)):
					return lhsError.localizedDescription == rhsError.localizedDescription
			
			case let(.success(lhsResults), .success(rhsResults)):
				guard lhsResults.count == rhsResults.count else { return false}
				var result = true
				for index in lhsResults.indices {
					result = result && lhsResults[index].organization == rhsResults[index].organization
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

class OrganizationListManualViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case backToSearch
		case closeSheet
		case onAppear
		case retry
		case store(MgoOrganization)
	}
	
	/// The state of the view
	@Published var state: OrganizationListViewState
	
	/// Search parameter name
	private var name: String
	
	/// Search parameter city
	private var city: String
	
	/// array to store the results
	private var searchResultsList = [MgoOrganization]()
	
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
	func reduce(_ action: OrganizationListManualViewModel.Action) {
		
		switch action {
			
			case .backToSearch:
				Current.notificationCenter.post(name: .clearSearch, object: nil)
				coordinator?.handle(Coordination.Action.backToAddHealthcareOrganization)
			
			case .backButtonPressed:
				coordinator?.handle(Coordination.Action.backButtonPressed)
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
			
			case .onAppear:
				if case OrganizationListViewState.success = state {
					applyListState()
				}
			
				// Only load the first time
				guard state == .loading else { return }
			
				_Concurrency.Task {
					await loadHealthcareOrganizations()
				}
			
			case .retry:
				_Concurrency.Task {
					await loadHealthcareOrganizations()
				}
			
			case .store(let organization):
				guard cardState(for: organization) == .regular else { return }
			
				try? Current.healthcareOrganizationStore.store(organization)
				applyListState()
				coordinator?.handle(Coordination.Action.finishedSearchingHealthcareOrganizations)
		}
	}
	
	@MainActor
	private func loadHealthcareOrganizations() async {
		
		state = .loading
		
		guard let localisationServiceClient else {
			state = .failure(LocalisationServiceClientError.noServer)
			return
		}
		
		do {
			searchResultsList = try await localisationServiceClient.searchHealthcareOrganizations(city: city, name: name)
			logDebug("We found \(searchResultsList.count) organisations.")
			
			applyListState()
			
		} catch {
			logDebug("Error fetching orginasations \(error)")
			state = .failure(error)
		}
	}
	
	/// Apply the state for each of the health organizations
	func applyListState() {
		
		var list = [OrganizationListSet]()
		searchResultsList.forEach {organization in
			let cardState = cardState(for: organization)
			
			list.append((
				organization: organization,
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
	/// - Parameter organization: the healthcare organization
	/// - Returns: card state
	private func cardState(for organization: MgoOrganization) -> OrganizationListCardState {
		
		guard let dts = organization.data_services, dts.isNotEmpty else {
			return .notParticipating
		}
		
		var activeServices = [DataService]()
		for service in dts {
			if service.id == DVP.CommonClinicalDataset.serviceID ||
				service.id == DVP.GeneralPractitioner.serviceID ||
				service.id == DVP.Vaccination.serviceID ||
				service.id == DVP.Documents.serviceID {
				activeServices.append(service)
			}
		}
		guard activeServices.isNotEmpty else {
			return .notParticipating
		}
		
		let list = Current.healthcareOrganizationStore.organizations
		for item in list where organization.identifier == item.identifier {
			return .selected
		}
		return .regular
	}
}

struct OrganizationListManualView: View {
	
	/// The view model
	@StateObject var viewModel: OrganizationListManualViewModel
	
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
		enum List {
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		VStack {
			
			switch viewModel.state {
				case .loading:
					OrganizationListManualLoadingView()
			
				case .failure:
					ErrorView(viewModel: ErrorViewModel {
						viewModel.reduce(.retry)
					})
				
				case let .empty(city: city, name: name):
					ErrorView(viewModel: OrganizationListEmptyViewModel(city: city, name: name) {
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
		.when(isPresentedAsSheet, transform: { view in
			view
				.withToolbarCloseButton {
					viewModel.reduce(.closeSheet)
				}
		})

		.navigationBarItems(leading: BackButton("common.search") {
			viewModel.reduce(.backButtonPressed)
		})

		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
	
	@ViewBuilder func listSearchResults(_ list: [OrganizationListSet]) -> some View {
		
		ScrollView {
			
			VStack(alignment: .leading) {
				
				Text("organization_search.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.accessibilityIdentifier("organization_search.heading")
			
				LazyVStack(spacing: ViewTraits.List.spacing) {
					
					ForEach(Array(list.enumerated()), id: \.offset) { index, element in
						
						ZStack {
							
							Rectangle()
								.foregroundStyle(.clear)
								.accessibilityLabel(
									String(
										format: String(
											localized: element.cardState.accessibilityLabel),
										arguments: ["\(element.organization.display_name)"]
									)
								)
								.accessibilityAddTraits(.isButton)
								.accessibilityIdentifier("organization_search.result_\(index)")
							
							OrganizationListCardView(
								model: OrganizationDisplayDecorator.create(element.organization),
								state: element.cardState,
								perform: {
									viewModel.reduce(.store(element.organization))
								}
							)
						}
					}
				}
			}
			.padding(.horizontal, ViewTraits.General.padding)
		}
	}
}

#Preview {
	
	let spy = LocalisationServiceClientSpy(serverUrl: URL(string: "https://example.com")!, username: "", password: "")
	spy.stubbedSearchHealthcareOrganizations = [
		PreviewContent.healthcareOrganization,
		MgoOrganization(
			medmij_id: "medmij",
			display_name: "Tandartsenpraktijk Willem II Roermond B.V.",
			identification: "2",
			addresses: [LocalisationService.Components.Schemas.Address(
				active: true,
				address: "Boorplatform 5",
				city: "Roermond",
				lines: ["Boorplatform 5"],
				postalcode: "1234AB",
				_type: "postal")
			],
			types: [],
			data_services: []
		)
	]
	
	return NavigationView {
		OrganizationListManualView(
			viewModel: OrganizationListManualViewModel(
				coordinator: nil,
				city: "Roermond",
				name: "Tandarts Tandje Erbij",
				localisationServiceClient: spy
			)
		)
	}
}
