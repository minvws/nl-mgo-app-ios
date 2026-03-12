/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// View model for `SearchOrganizationView`.
///
/// Owns the search lifecycle (debounced queries, pagination) and the
/// confirmation flow for adding a healthcare organization.  All state mutations
/// happen on the `@MainActor`.
@MainActor
class SearchOrganizationViewModel: ObservableObject {
	
	/// The state of the search organization view
	struct SearchOrganizationViewState {

		/// The heading text key — set once at init based on whether this is the user's first visit.
		var heading: LocalizedStringKey = "search_organization.heading"

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

		/// Non-nil when the confirmation cover is presented; the value is the org being confirmed.
		var pendingConfirmation: OrganizationSearch.Organization?

		/// The slice of `results` that is currently shown in the list.
		var visibleResults: [OrganizationSearch.Organization] {
			Array(results.prefix(visibleCount))
		}
	}
	
	/// The state for this view
	@Published var state: SearchOrganizationViewState = SearchOrganizationViewState()
	
	/// Dependency injectable organization Search Client
	@Injected(\.organizationSearchClient) private var organizationSearchClient
	
	/// Dependency injectable healthcare organization repository
	@Injected(\.healthcareOrganizationRepository) private var healthcareOrganizationRepository
	
	/// All actions this view model can handle.
	enum Action {
		/// Dismiss the sheet that contains this view.
		case closeSheet
		/// Resign the keyboard / end text editing.
		case endEditing
		/// Run a search for the given term, or clear results when `nil` / too short.
		case search(String?)
		/// The user tapped an organization row; show the confirmation cover.
		case select(OrganizationSearch.Organization)
		/// The user confirmed the selection; persist the organization and close the sheet.
		case store(OrganizationSearch.Organization)
		/// Render the next page of results.
		case loadMore
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// The current search task that can be cancelled
	private var searchTask: Task<Void, Never>?
	
	/// Debounce delay in milliseconds
	private let searchDebounceDelay: UInt64 = 100
	
	/// The number of results rendered per page.
	static let pageSize = 20
	
	/// Creates the view model.
	/// - Parameters:
	///   - coordinator: the flow coordinator used for navigation/routing.
	///   - firstVisitor: `true` when the user has not yet added any organization (onboarding flow).
	@MainActor init(coordinator: (any Coordinator)?, firstVisitor: Bool) {
		self.coordinator = coordinator
		self.state = SearchOrganizationViewState(
			heading: firstVisitor ? "search_organization.onboarding.heading" : "search_organization.heading",
			results: [],
			storedOrganizationIDs: healthcareOrganizationRepository.organizations
				.map(\.id),
			availableServiceIds: DataServices().services.map(\.id)
		)
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

			case let .select(organization):
				var transaction = Transaction()
				transaction.disablesAnimations = true
				withTransaction(transaction) {
					state.pendingConfirmation = organization
				}

			case let .store(organization):
				store(organization)
				state.storedOrganizationIDs.append(organization.id)
				coordinator?.handle(Coordination.Action.closeSheet)

			case .loadMore:
				state.visibleCount = min(
					state.visibleCount + SearchOrganizationViewModel.pageSize,
					state.results.count
				)
		}
	}
	
	/// Debounces and executes a search query, updating state when results arrive.
	/// - Parameter searchTerm: the raw text typed by the user; results are cleared when `nil` or too short.
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
	@MainActor private func store(_ organization: OrganizationSearch.Organization) {
		try? healthcareOrganizationRepository.store(organization)
	}
}

/// Lets the user search for a healthcare organization and add it to their profile.
///
/// Presents a debounced search field, a paginated list of results, and a
/// full-screen confirmation cover when the user selects an organization.
struct SearchOrganizationView: View {
	
	/// The view model
	@StateObject var viewModel: SearchOrganizationViewModel
	
	/// The Theme
	@Environment(\.mgoTheme) var theme
	
	/// Are we presented in a sheet?
	@Environment(\.isPresentedAsSheet) private var isPresentedAsSheet
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// The binding input - can be injected for testing
	@State var input: String
	
	/// Creates the view.
	/// - Parameters:
	///   - viewModel: the view model; evaluated lazily via `@autoclosure` so `StateObject` owns the instance.
	///   - input: initial text for the search field; defaults to empty. Inject a non-empty value in tests to pre-populate state.
	init(
		viewModel: @autoclosure @escaping () -> SearchOrganizationViewModel,
		input: String = ""
	) {
		self._viewModel = StateObject(wrappedValue: viewModel())
		self._input = State(initialValue: input)
	}
	
	/// Tracks the rendered size of the list so the empty-state image can scale proportionally.
	@State private var contentSize: CGSize = .zero

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
		.onChange(of: viewModel.state.pendingConfirmation) { pending in
			if pending != nil {
				isInputFocused = false
			}
		}
		.inspectableFullScreenCover(isPresented: $viewModel.state.pendingConfirmation.presence()) {
			if let organization = viewModel.state.pendingConfirmation {
				ConfirmationAlertCoverView(
					organization: organization,
					isPresented: $viewModel.state.pendingConfirmation.presence(),
					onConfirm: { viewModel.reduce(.store(organization)) }
				)
				.clearFullScreenCoverBackground()
				.interactiveDismissDisabled()
			}
		}
	}
	
	/// The top view with heading, subheading and input field
	@ViewBuilder private var topView: some View {
		
		Section {
			
			VStack(spacing: ViewTraits.Header.spacing) {
				
				Text(viewModel.state.heading)
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
	
	/// A single organization row wrapped in its `Section`.
	@ViewBuilder private func organizationRow(_ organization: OrganizationSearch.Organization) -> some View {
		Section {
			OrganizationRowView(
				organization: organization,
				cardState: cardState(organization),
				onSelect: { viewModel.reduce(.select(organization)) }
			)
		}
		.listRowInsets(ViewTraits.List.resultInset)
	}

	/// The list of search results
	@ViewBuilder private var organizationsList: some View {

		ForEach(viewModel.state.visibleResults) { organization in
			organizationRow(organization)
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
	
	/// Determines how an organization row should be rendered.
	/// - Parameter organization: the organization to evaluate.
	/// - Returns: `.selected` if already stored, `.notParticipating` if no supported data services, `.regular` otherwise.
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
