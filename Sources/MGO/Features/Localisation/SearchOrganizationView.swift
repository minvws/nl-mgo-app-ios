/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

@MainActor
class SearchOrganizationViewModel: ObservableObject {

	/// The state of the search organization view
	struct SearchOrganizationViewState {

		/// Are we in the onboarding? -> True
		/// Are we a repeat visitor? -> False
		var isOnboarding: Bool = false

		/// Are we searching for results?
		var isSearching: Bool = false

		/// All search results returned by the database (potentially thousands).
		var results: [OrganizationSearch.Organization] = []

		/// How many results are currently rendered in the list.
		var visibleCount: Int = 20

		/// The total number of search results
		var totalResults: Int = 0

		/// All id of stored organizations
		var storedOrganizationIDs: [String] = []

		/// All available service ids
		var availableServiceIds: [String] = []

		/// The slice of `results` that is currently shown in the list.
		var visibleResults: [OrganizationSearch.Organization] {
			Array(results.prefix(visibleCount))
		}
	}
	
	/// The state for this view
	@Published var state: SearchOrganizationViewState = SearchOrganizationViewState()
	
	/// Dependency injectable organization Search Client
	@Injected(\.organizationSearchClient) private var organizationSearchClient
	
	/// Dependency Healthcare Organization Store
	@Injected(\.healthcareOrganizationRepository) private var healthcareOrganizationRepository
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case closeSheet
		case endEditing
		case search(String?)
		case store(OrganizationSearch.Organization)
		case loadMore
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// The current search task that can be cancelled
	private var searchTask: Task<Void, Never>?

	/// Token for the memory-warning notification observer.
	/// `nonisolated(unsafe)`: written once from `@MainActor` `init`, read once from
	/// nonisolated `deinit`. The single-write / single-read pattern makes concurrent
	/// access impossible.
	nonisolated(unsafe) private var memoryWarningObserver: NSObjectProtocol?

	/// Holds the search-client reference for teardown in `deinit`, which is nonisolated.
	/// `nonisolated(unsafe)`: assigned once at the end of `@MainActor` `init`, read once
	/// in `deinit`. The client itself is `Sendable`; the annotation only bypasses the
	/// actor-isolation check on the stored-property accessor.
	nonisolated(unsafe) private var clientForDeinit: (any OrganizationSearchClientProtocol)?
	
	/// Debounce delay in milliseconds
	private let searchDebounceDelay: UInt64 = 100
	
	/// The number of results rendered per page.
	static let pageSize = 20
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	@MainActor init(coordinator: (any Coordinator)?, firstVisitor: Bool) {
		self.coordinator = coordinator
		self.state = SearchOrganizationViewState(
			isOnboarding: firstVisitor,
			results: [],
			storedOrganizationIDs: healthcareOrganizationRepository.organizations
				.map(\.identification),
			availableServiceIds: DataServices(isDemo: Container.shared.featureFlagManager().isDemo).services.map(\.id)
		)
		
		memoryWarningObserver = NotificationCenter.default.addObserver(
			forName: UIApplication.didReceiveMemoryWarningNotification,
			object: nil,
			queue: nil
		) { [weak self] _ in
			Task { @MainActor [weak self] in
				self?.handleMemoryPressure()
			}
		}

		// Capture for use in nonisolated deinit (see clientForDeinit declaration).
		clientForDeinit = organizationSearchClient
	}

	deinit {
		if let token = memoryWarningObserver {
			NotificationCenter.default.removeObserver(token)
		}
		if let client = clientForDeinit {
			Task { await client.teardown() }
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: SearchOrganizationViewModel.Action) {
		
		switch action {
				
			case .closeSheet:
				coordinator?.handle(Coordination.Action.closeSheet)
				
			case .endEditing:
				UIApplication.shared.endEditing()
				
			case let .search(searchTerm):
				search(searchTerm)
				
			case let .store(organization):
				store(organization)
				coordinator?.handle(Coordination.Action.closeSheet)

			case .loadMore:
				state.visibleCount = min(
					state.visibleCount + SearchOrganizationViewModel.pageSize,
					state.results.count
				)
		}
	}
	
	/// Free the search index and clear UI state in response to a memory-pressure warning.
	///
	/// Tears down the search backend so the OS can reclaim the index memory, then
	/// clears any results currently displayed. The client remains in the same state
	/// as a freshly initialised instance — `prepare` would need to be called again
	/// before searches succeed (which happens automatically if the view is dismissed
	/// and re-opened).
	@MainActor private func handleMemoryPressure() {
		Task {
			await organizationSearchClient.teardown()
		}
		withAnimation {
			state.results = []
			state.totalResults = 0
			state.isSearching = false
		}
	}

	/// Handle user input for search
	/// - Parameter term: the search term
	@MainActor private func search(_ searchTerm: String?) {
		// Cancel any existing search task
		searchTask?.cancel()

		guard let searchTerm,
			  let sanitized = Sanitizer.strip(searchTerm),
			  sanitized.isNotEmpty,
			  sanitized.count > 2 else {
			state.results = []
			state.totalResults = 0
			state.isSearching = false
			return
		}

		MemoryUsage.printMemoryUsage("SOVM: before searching")
		self.state.isSearching = true

		searchTask = Task {
			// Delay the search to debounce
			try? await Task.sleep(nanoseconds: searchDebounceDelay * 1_000_000)

			// Check if task was cancelled during the delay
			guard !Task.isCancelled else { return }

			let searchResult = (try? await organizationSearchClient.searchHealthcareOrganizations(sanitized)) ?? SearchResults(count: 0, hits: [])

			// Discard results if a newer search superseded this one while the query was running
			guard !Task.isCancelled else { return }

			let docs = searchResult.hits.map { $0.document }
			MemoryUsage.printMemoryUsage("SOVM: after searching")
			logDebug("results", searchResult.count)
			await MainActor.run {
				withAnimation {
					self.state.results = docs
					self.state.visibleCount = SearchOrganizationViewModel.pageSize
					self.state.isSearching = false
					self.state.totalResults = Int(searchResult.count)
				}
			}
		}
	}
	
	/// Store an organization
	/// - Parameter organization: the organization to store
	@MainActor private func store(_ organization: Organization) {
		
		// Transform OrganizationSearch.Organization to MgoOrganization
		let mgoOrganization = MgoOrganization(
			medmij_id: organization.id,
			display_name: organization.displayName ?? "",
			identification: organization.id,
			addresses: {
				// Only create an address if we have city (required field)
				guard let city = organization.city else {
					return []
				}
				
				let addressLines: [String]?
				if let addressLine = organization.addressLine {
					addressLines = [addressLine]
				} else {
					addressLines = nil
				}
				
				return [LocalisationService.Components.Schemas.Address(
					active: true,
					address: organization.addressLine,
					city: city,
					country: "NL",
					lines: addressLines,
					postalcode: organization.postalCode
				)]
			}(),
			types: {
				// Only create a type if we have careTypeDisplay
				guard let careTypeDisplay = organization.careTypeDisplay else {
					return []
				}
				
				return [LocalisationService.Components.Schemas.CType(
					code: "",
					display_name: careTypeDisplay,
					_type: ""
				)]
			}(),
			data_services: organization.dataServices?.map { key, value in
				LocalisationService.Components.Schemas.ZalDataServiceResponse(
					id: key,
					name: key,
					interface_versions: [],
					auth_endpoint: value.authEndpoint,
					token_endpoint: value.tokenEndpoint,
					roles: [
						LocalisationService.Components.Schemas.ZalDataServiceRoleResponse(
							code: "",
							resource_endpoint: value.resourceEndpoint
						)
					]
				)
			}
		)
		
		// Store the organization
		try? healthcareOrganizationRepository.store(mgoOrganization)
	}
}

struct SearchOrganizationView: View {
	
	/// The view model
	@StateObject var viewModel: SearchOrganizationViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// The binding input - can be injected for testing
	@State var input: String
	
	/// Initializer
	init(
		viewModel: @autoclosure @escaping () -> SearchOrganizationViewModel,
		input: String = ""
	) {
		self._viewModel = StateObject(wrappedValue: viewModel())
		self._input = State(initialValue: input)
	}
	
	/// helper to calculate the size of the view
	@State private var contentSize: CGSize = .zero
	
	/// State for showing the confirmation alert
	@State private var showConfirmationAlert: Bool = false
	
	/// The selected organization for the alert
	@State private var selectedOrganization: OrganizationSearch.Organization?
	
	/// Focus state for the input field
	@FocusState private var isInputFocused: Bool
	
	/// Describes how an organization card should be displayed and whether it is tappable.
	enum CardState: Equatable, Sendable {
		/// The organization can be added; the row is tappable and shows a chevron.
		case regular
		/// The organization has already been added by the user; tapping has no effect.
		case selected
		/// The organization does not support any available data services; tapping has no effect.
		case notParticipating
	}
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Header {
			static let spacing: CGFloat = 6
			static let subheadingBottomPadding: CGFloat = 20
			static let inputBottomPadding: CGFloat = 8
		}
		enum Input {
			static let cornerRadius: CGFloat = 12
			static let newCornerRadius: CGFloat = 1000
			static let inset: CGFloat = 0.5
			static let leading: CGFloat = 44
			static let verticalPadding: CGFloat = 12
			static let trailing: CGFloat = 12
		}
		enum List {
			static let headerInset = EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16)
			static let resultInset = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
			static let sectionInset = EdgeInsets(top: 10, leading: 0, bottom: 2, trailing: 0)
		}
		enum Accessory {
			static let size: CGFloat = 22
		}
		enum Empty {
			static let spacing: CGFloat = 8
			static let bottom: CGFloat = 16
			static let maxWidthPercentage: Double = 0.38
		}
	}
	
	var body: some View {
		List {
			
			topView
			
			if viewModel.state.results.isNotEmpty {
				listHeader
				
				organizationsList
			} else if !viewModel.state.isSearching && input.count > 2 {
				emptyState
			}
		}
		.backport.listSectionSpacing(8)
		.backport.contentMargins(0)
		.backport.scrollContentBackground(.hidden)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		.readSize($contentSize)
		.resignKeyboardOnDragGesture()
		.when(isPresentedAsSheet, transform: { view in
			view
				.withToolbarCloseButton(osVersionChecker.available(version: .iOS(.v26))) {
					viewModel.reduce(.closeSheet)
				}
		})
		.when(!isPresentedAsSheet, transform: { view in
			view
				.layoutForIPad()
		})
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.onChange(of: showConfirmationAlert) { isShowing in
			if isShowing {
				isInputFocused = false
			}
		}
		.alert(
			String(
				format: String(localized: "search_organization.dialog.heading"),
				arguments: [selectedOrganization?.displayName ?? ""]
			),
			isPresented: $showConfirmationAlert,
			presenting: selectedOrganization
		) { organization in
			Button("search_organization.dialog.yes", role: .none) {
				viewModel.reduce(.store(organization))
			}
			.accessibilityIdentifier("search_organization.dialog.action")
			Button("search_organization.dialog.no", role: .cancel) { /* No action */ }
		} message: { organization in
			Text(String(localized: "search_organization.dialog.subheading"))
		}
	}
	
	/// The top view with heading, subheading and input field
	@ViewBuilder private var topView: some View {
		
		Section {
			
			VStack(spacing: ViewTraits.Header.spacing) {
				
				Text(viewModel.state.isOnboarding ? "search_organization.onboarding.heading" : "search_organization.heading")
					.typography(.headingExtraLarge)
					.foregroundStyle(theme.labels.primary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.accessibilityIdentifier("search_organization.heading")
				
				Text("search_organization.subheading")
					.typography(
						.bodyMedium,
						with: .semiBold
					)
					.foregroundStyle(theme.labels.secondary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityIdentifier("search_organization.subheading")
					.padding(.bottom, ViewTraits.Header.subheadingBottomPadding)
				
				inputField
					.padding(.bottom, ViewTraits.Header.inputBottomPadding)
			}
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.sectionInset)
	}
	
	/// The input field for the search
	@ViewBuilder private var inputField: some View {
		
		TextField("search_organization.search_placeholder", text: $input)
			.focused($isInputFocused)
			.padding(.leading, ViewTraits.Input.leading)
			.padding(.trailing, ViewTraits.Input.trailing)
			.padding(.vertical, ViewTraits.Input.verticalPadding)
			.foregroundStyle(theme.labels.primary)
			.accentColor(theme.actions.ghost.text)
			.frame(maxWidth: .infinity, alignment: .leading)
			.background(theme.backgrounds.secondary)
			.cornerRadius(
				osVersionChecker
					.available(version: .iOS(.v26)) ? ViewTraits.Input.newCornerRadius : ViewTraits.Input.cornerRadius
			)
			.accessibilityIdentifier("input")
			.overlay(alignment: .trailing) {
				
				Button(
					action: {
						input = ""
					},
					label: {
						Image(ImageResource.Localisation.clear)
					}
				)
				.buttonStyle(IconButtonStyle())
				.accessibilityLabel("common.clear")
				.accessibilityHidden(input.isEmpty)
				.padding(.trailing, ViewTraits.Input.trailing)
				.opacity(input.isNotEmpty ? 1 : 0)
			}
			.overlay(alignment: .leading) {
				
				if viewModel.state.isSearching {
					ProgressView()
						.progressViewStyle(.circular)
						.frame(
							width: ViewTraits.Accessory.size,
							height: ViewTraits.Accessory.size
						)
						.tint(theme.symbols.secondary)
						.padding(.leading, ViewTraits.General.padding)
				} else {
					Image(systemName: "magnifyingglass")
						.foregroundStyle(theme.symbols.secondary)
						.padding(.leading, ViewTraits.General.padding)
				}
			}
			.onChange(of: input) { newValue in
				viewModel.reduce(.search(newValue))
			}
	}
	
	/// The empty state, ie. the search resulted in no organizations
	@ViewBuilder private var emptyState: some View {
		
		Section {
			
			VStack(alignment: .center, spacing: ViewTraits.Empty.spacing, content: {
				
				Spacer()
				
				Image(ImageResource.Localisation.empty)
					.resizable()
					.aspectRatio(contentMode: .fit)
					.frame(width: contentSize.width * (UIDevice.current.userInterfaceIdiom == .pad ? 0.33 : ViewTraits.Empty.maxWidthPercentage))
					.padding(.bottom, ViewTraits.Empty.bottom)
				
				Text("search_organization.no_results.heading")
					.typography(.headingSmall)
					.foregroundStyle(theme.labels.primary)
					.multilineTextAlignment(.center)
				
				Text("search_organization.no_results.subheading")
					.typography(.bodyMedium)
					.foregroundStyle(theme.labels.secondary)
					.multilineTextAlignment(.center)
				
				Spacer()
			})
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.padding(.horizontal, ViewTraits.General.padding)
		}
		.listRowBackground(Color.clear)
	}
	
	/// The list of search results
	@ViewBuilder private var organizationsList: some View {

		ForEach(viewModel.state.visibleResults) { organization in
			Section {
				OrganizationRowView(
					organization: organization,
					cardState: cardState(organization),
					onSelect: {
						selectedOrganization = organization
						showConfirmationAlert = true
					}
				)
			}
			.listRowInsets(ViewTraits.List.resultInset)
		}

		// Load the next page when the user scrolls to the bottom.
		if viewModel.state.visibleCount < viewModel.state.results.count {
			Section {
				Color.clear
					.frame(height: 1)
					.onAppear {
						viewModel.reduce(.loadMore)
					}
			}
			.listRowBackground(Color.clear)
			.listRowInsets(.init())
		}
	}
	
	/// Get the card state of an organization
	/// - Parameter organization: the organization
	/// - Returns: card state
	private func cardState(_ organization: Organization) -> CardState {
		guard let dts = organization.dataServices else {
			return .notParticipating
		}
		
		// Check if any data service key is included in available service IDs
		let hasAvailableService = dts.keys.contains { key in
			viewModel.state.availableServiceIds.contains(key)
		}
		
		if !hasAvailableService {
			return .notParticipating
		}
		
		// Check if the organization is already stored
		if viewModel.state.storedOrganizationIDs.contains(organization.id) {
			return .selected
		}
		
		return .regular
	}
	
	/// The header for the list with search results
	@ViewBuilder private var listHeader: some View {
		
		Section {
			Text(
				String(
					format: String(localized: "search_organization.result_count"),
					arguments: ["\(viewModel.state.totalResults)"]
				)
			)
			.typography(.bodyMedium)
			.foregroundStyle(theme.labels.secondary)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.headerInset)
	}
}
