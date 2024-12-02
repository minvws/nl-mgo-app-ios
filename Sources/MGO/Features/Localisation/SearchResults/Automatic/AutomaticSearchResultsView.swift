/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AutomaticSearchResultsViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case closeSheet
		case onAppear
		case retry
		case store
		case select(MgoOrganization)
		case unselect(MgoOrganization)
	}
	
	/// The state of the view
	@Published var state: OrganizationSearchResultViewState
	
	/// array to store the results
	internal var searchResultsList = [MgoOrganization]()
	
	/// array of selected search results
	internal var selectedSearchResultsList = [MgoOrganization]()
	
	/// array of not participating  search results
	private var notParticipatingList = [MgoOrganization]()
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// The localisation service client
	private var localisationServiceClient: LocalisationServiceClientProtocol?
	
	/// Is this the first time we are doing automatic localization
	private var preselectAllOrganizations: Bool
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(
		coordinator: (any Coordinator)?,
		localisationServiceClient: LocalisationServiceClientProtocol?,
		preselectAllOrganizations: Bool) {
		
		self.coordinator = coordinator
		self.localisationServiceClient = localisationServiceClient
		self.preselectAllOrganizations = preselectAllOrganizations
		self.state = .loading
	}

	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AutomaticSearchResultsViewModel.Action) {
		
		switch action {
			
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
				//
			case .onAppear:
				
				// Only load the first time
				guard state == .loading else { return }
				
				_Concurrency.Task {
					await loadHealthcareOrganizations()
				}
			
			case .retry:
				_Concurrency.Task {
					await loadHealthcareOrganizations()
				}
			
			case let .select(organization):
				selectedSearchResultsList.append(organization)
				applyListState()
				
			case let .unselect(organization):
				selectedSearchResultsList = selectedSearchResultsList.filter { $0.identifier != organization.identifier }
				applyListState()
			
			case .store:
				selectedSearchResultsList.forEach { organization in
					try? Current.healthcareOrganizationStore.store(organization)
				}
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
			searchResultsList = try await localisationServiceClient.searchHealthcareOrganizations(city: "test", name: "test")
			logDebug("We found \(searchResultsList.count) organizations.")
			
			selectNotParticipatingOrganizations()
			
			if preselectAllOrganizations {
				// On first launch we want all the organizations pre-selected.
				// On re-entry, we should respect the selection the user had made.
				// We should however not select the organizations without any services, or already selected
				selectedSearchResultsList = searchResultsList
					.filter { ssrItem in notParticipatingList.filter { nplItem in nplItem.identifier == ssrItem.identifier }.isEmpty }
				
				selectedSearchResultsList = selectedSearchResultsList
					.filter { ssrItem in Current.healthcareOrganizationStore.organizations.filter { choItem in choItem.identifier == ssrItem.identifier }.isEmpty }
			}
			
			applyListState()
			
		} catch {
			logDebug("Error fetching automatic organizations \(error)")
			state = .failure(error)
		}
	}
	
	/// Apply the state for each of the health organizations
	func applyListState() {
		
		var list = [OrganizationSearchResultSet]()
		searchResultsList.forEach {organization in
			let cardState = cardState(for: organization)
			
			list.append((
				organization: organization,
				cardState: cardState)
			)
		}
		if list.isEmpty {
			#warning("We should have an empty state for automatic localization")
			state = .failure(LocalisationServiceClientError.noOrganizations)
		} else {
			state = .success(list)
		}
	}
	
	func selectNotParticipatingOrganizations() {
		
		for organization in searchResultsList {
			// State .notParticipating for organizations without any data service
			guard let dts = organization.data_services, dts.isNotEmpty else {
				notParticipatingList.append(organization)
				continue
			}
			
			// State .notParticipating for data services we don't handle (yet)
			var activeServices = [DataService]()
			for service in dts {
				if service.id == DVP.CommonClinicalDataset.serviceID || service.id == DVP.GeneralPractitioner.serviceID {
					activeServices.append(service)
				}
			}
			guard activeServices.isNotEmpty else {
				notParticipatingList.append(organization)
				continue
			}
		}
	}
	
	/// Get the state for a card
	/// - Parameter organization: the healthcare organization
	/// - Returns: card state
	private func cardState(for organization: MgoOrganization) -> OrganizationSearchResultCardState {
		
		guard !notParticipatingList.contains(organization) else { return .notParticipating }
		
		// Apply .selected to organizations already selected
		let list = Current.healthcareOrganizationStore.organizations
		for item in list where organization.identifier == item.identifier {
			return .selected
		}
		
		// Apply .automatic to all remaining organizations
		// with isSelected true if the user selected that one.
		return .automatic(isSelected: selectedSearchResultsList.contains(organization))
	}
}

struct AutomaticSearchResultsView: View {
	
	/// The view model
	@StateObject var viewModel: AutomaticSearchResultsViewModel
	
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
		enum Button {
			static let padding: CGFloat = 16
		}
	}
	
	var body: some View {
		
		Group {
			
			switch viewModel.state {
				case .loading:
					AutomaticLoadingSearchResultsView()
				
				case .failure:
					ErrorView(viewModel: ErrorViewModel {
						viewModel.reduce(.retry)
					})
				
				case .success(let results):
					listSearchResults(results)
				
				default:
					EmptyView()
			}
		}
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.navigationBarBackButtonHidden(true)
		.when(isPresentedAsSheet, transform: { view in
			view
				.toolbar {
					ToolbarItem(content: { CloseButton {
						viewModel.reduce(.closeSheet)
					}})
				}
		})
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
	
	/// Create a list of organizations
	/// - Parameter list: the list of search results
	/// - Returns: the list view
	@ViewBuilder private func listSearchResults(_ list: [OrganizationSearchResultSet]) -> some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(alignment: .leading, spacing: ViewTraits.General.padding) {
				
				Text("organization_search.heading")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.accessibilityIdentifier("organization_search.heading")
				
				Text("organization_search.subheading")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityIdentifier("organization_search.subheading")
			
				LazyVStack(spacing: ViewTraits.List.spacing) {
					
					ForEach(Array(list.enumerated()), id: \.offset) { index, element in
						
						cardView(element, index: index)
					}
				}
			}
			.padding(.horizontal, ViewTraits.General.padding)
		} bottomView: {
			
			CallToActionButton("common.to_overview") {
				viewModel.reduce(.store)
			}
			.accessibilityIdentifier("common.to_overview")
			.padding(ViewTraits.Button.padding)
		}
		.navigationBarHidden(false)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.padding(.top, ViewTraits.Navigation.padding)
		.layoutForIPad()
	}
	
	/// Build the view for an organization
	/// - Parameter element: a result set
	/// - Returns: the card for the organization
	@ViewBuilder private func cardView(_ element: OrganizationSearchResultSet, index: Int) -> some View {
		
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
			
			OrganizationSearchResultCardView(
				model: OrganizationSearchResultDecorator.create(element.organization),
				state: element.cardState,
				perform: {
					if case let .automatic(isSelected) = element.cardState {
						if isSelected {
							viewModel.reduce(.unselect(element.organization))
						} else {
							viewModel.reduce(.select(element.organization))
						}
					}
				}
			)
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
		AutomaticSearchResultsView(
			viewModel: AutomaticSearchResultsViewModel(
				coordinator: nil,
				localisationServiceClient: spy,
				preselectAllOrganizations: true
			)
		)
	}
}
