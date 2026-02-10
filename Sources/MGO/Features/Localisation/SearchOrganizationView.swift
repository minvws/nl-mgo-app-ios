/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class SearchOrganizationViewModel: ObservableObject {
	
	/// The state of the search organization view
	struct SearchOrganizationViewState {
		
		/// Are we in the onboarding? -> True
		/// Are we a repeat visitor? -> False
		var isOnboarding: Bool = false
		
		/// Are we searching for results?
		var isSearching: Bool = false
		
		/// The search results
		var results: [OrganizationSearch.Organization] = []
		
		/// The total number of search results
		var totalResults: Int = 0
	}
	
	/// The state for this view
	@Published var state: SearchOrganizationViewState = SearchOrganizationViewState()
	
	/// Dependency injectable organization Search Client
	@Injected(\.organizationSearchClient) private var organizationSearchClient
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case closeSheet
		case endEditing
		case search(String?)
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// The current search task that can be cancelled
	private var searchTask: Task<Void, Never>?
	
	/// Debounce delay in milliseconds
	private let searchDebounceDelay: UInt64 = 100
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	@MainActor init(coordinator: (any Coordinator)?, firstVisitor: Bool) {
		self.coordinator = coordinator
		self.state = SearchOrganizationViewState(
			isOnboarding: firstVisitor,
			results: []
		)
		
		Task {
			MemoryUsage.printMemoryUsage("before indexing")
			try await organizationSearchClient.prepare()
			MemoryUsage.printMemoryUsage("after indexing")
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
		}
	}
	
	/// Handle user input for search
	/// - Parameter term: the search term
	@MainActor private func search(_ searchTerm: String?) {
		// Cancel any existing search task
		searchTask?.cancel()
		
		guard let searchTerm, searchTerm.isNotEmpty, searchTerm.count > 2 else {
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
			guard !Task.isCancelled else {
				return
			}
			
			let searchResult = try? await organizationSearchClient.searchHealthcareOrganizations(searchTerm)
			let docs = searchResult?.hits.map { $0.document } ?? []
			await MainActor.run {
				withAnimation {
					
					self.state.results = docs
					self.state.isSearching = false
					self.state.totalResults = Int(searchResult?.count ?? 0)
				}
			}
		}
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
	
	/// The binding input
	@State var input: String = ""
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Header {
			static let spacing: CGFloat = 6
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
			static let headerInset = EdgeInsets(top: 16, leading: 16, bottom: 0, trailing: 16)
			static let resultInset = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
		}
		enum Accessory {
			static let size: CGFloat = 22
		}
	}
	
	var body: some View {
		VStack(alignment: .leading, spacing: ViewTraits.General.padding) {
			heading
			
			inputField
			
			searchResults
			
			Spacer()
		}
		.onTapGesture {
			_ = logDebug("Tapping outside the input")
			viewModel.reduce(.endEditing)
		}
		
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
	}
	
	/// The heading and subheading
	@ViewBuilder private var heading: some View {
		
		VStack(spacing: ViewTraits.Header.spacing) {
			
			Text(viewModel.state.isOnboarding ? "search_organization.onboarding.heading" : "search_organization.heading")
				.typography(.headingExtraLarge)
				.foregroundStyle(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
				.accessibilityIdentifier("add_organization.heading")
			
			Text("search_organization.subheading")
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.secondary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityIdentifier("add_organization.subheading")
		}
		.padding(.horizontal, ViewTraits.General.padding)
	}
	
	/// The input field for the search
	@ViewBuilder private var inputField: some View {
		
		TextField("search_organization.search_placeholder", text: $input)
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
			.padding(.horizontal, ViewTraits.General.padding)
			.onChange(of: input) { newValue in
				viewModel.reduce(.search(newValue))
			}
	}
	
	/// The search results, header and list
	@ViewBuilder private var searchResults: some View {
		if viewModel.state.results.isNotEmpty {
			
			List {
				
				listHeader
				
				list
			}
			.backport.listSectionSpacing(8)
			.backport.contentMargins(0)
			.backport.scrollContentBackground(.hidden)
			.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		} else {
			EmptyView()
		}
	}
	
	/// The list of search results
	@ViewBuilder private var list: some View {
		
		ForEach(viewModel.state.results) { organization in
			Section {
				CardView(
					title: organization.displayName ?? "",
					message: (
						(organization.addressLine ?? "") + " " + (
							organization.city ?? ""
						)
					)
					.trim()
				)
			}
			.listRowInsets(ViewTraits.List.resultInset)
		}
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

extension OrganizationSearch.Organization: @retroactive Identifiable {
	// Already implemented
}
