/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// The various states the page can be in
enum HealthCategoriesViewMode {
	
	/// This is a detailed single healthcare organization view
	case single(MgoOrganization)
	
	/// This is an overview of all your healthcare organizations
	case all
}

struct HealthCategoriesViewState {
	
	var heading: String
	var subheading: String
	var canTitleCollapse: Bool
	var showEmptyView: Bool
	var showRemoveHealthcareProvider: Bool
	var mainCategories: [SharedHealthCategories.MainCategory]
	var buttonState: [String: CategoryState]
	var favorites: [SharedHealthCategories.Category]
	var backButtonTitle: LocalizedStringKey?
	var belowIOS18: Bool
}

class HealthCategoriesViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The mode we are in (single, multiple)
	private var mode: HealthCategoriesViewMode
	
	/// The state of the view
	@Published var state: HealthCategoriesViewState
		
	struct Tokens {
		/// Token for the data store observatory
		var dataStoreToken: Observatory.ObserverToken?
		
		/// Token for the healthcare organization observatory
		var healthcareOrganizationStoreToken: Observatory.ObserverToken?
		
		/// Token for the favorites observatory
		var favoritesStoreToken: Observatory.ObserverToken?
	}
	
	private var tokens = Tokens()
	
	/// Dependency Healthcare Organization Store
	@Injected(\.healthcareOrganizationRepository) private var healthcareOrganizationRepository
	
	/// Dependency Injectable Data Store
	@Injected(\.dataStore) private var dataStore
	
	/// Dependency Injectable Resource Repository
	@Injected(\.resourceRepository) private var resourceRepository
	
	/// Dependency injectable Favorites store
	@Injected(\.favoritesRepository) private var favoritesRepository
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case refresh
		case categorySelected(SharedHealthCategories.Category)
		case removeHealthcareOrganization
		case onAppear
		case search
		case showFavorites
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	@MainActor init(coordinator: (any Coordinator)? = nil, mode: HealthCategoriesViewMode) {
		
		self.coordinator = coordinator
		self.mode = mode
		
		let heading: String = switch mode {
			case .single(let mgoOrganization):
				mgoOrganization.display_name
			case .all:
				String(localized: "overview.heading")
		}
		
		let subheading: String = switch mode {
			case .single:
				String(localized: "overview.organizations.subheading")
			case .all:
				String(localized: "overview.subheading")
		}
		
		let backbuttonTitle: LocalizedStringKey? = switch mode {
			case .single: "organizations.heading"
			case .all: nil
		}
		
		let showRemoveHealthcareProvider: Bool = switch mode {
			case .single: true
			case .all: false
		}
		
		let canTitleCollapse: Bool = switch mode {
			case .single: false
			case .all: true
		}
		
		var initialButtonState = [String: CategoryState]()
		let sharedHealthCategories = try? SharedHealthCategories()
		for category in sharedHealthCategories?.categories() ?? [] {
			initialButtonState[category.id] = .loading
		}
		
		self.state = HealthCategoriesViewState(
			heading: heading,
			subheading: subheading,
			canTitleCollapse: canTitleCollapse,
			showEmptyView: Container.shared.healthcareOrganizationRepository().organizations.isEmpty,
			showRemoveHealthcareProvider: showRemoveHealthcareProvider,
			mainCategories: sharedHealthCategories?.mainCategories ?? [],
			buttonState: initialButtonState,
			favorites: [],
			backButtonTitle: backbuttonTitle,
			belowIOS18: belowIOS18
		)
		prepareFavorites()
		registerObservers()
	}
	
	@MainActor private func registerObservers() {
		self.tokens.dataStoreToken = dataStore.observatory.append { [weak self] changed in
			if changed {
				Task { @MainActor in
					// Handle updates in the fetched data
					self?.updateState()
				}
			}
		}
		
		self.tokens.healthcareOrganizationStoreToken = healthcareOrganizationRepository.observatory.append { [weak self] _ in
			Task { @MainActor in
				// Check if there are any healthcare organizations left.
				self?.state.showEmptyView = self?.healthcareOrganizationRepository.organizations.isEmpty ?? true
			}
		}
		
		self.tokens.favoritesStoreToken = favoritesRepository.observatory.append { [weak self] _ in
			Task { @MainActor in
				self?.prepareFavorites()
			}
		}
	}
	
	/// Maybe the shared categories have been altered by an update,
	/// and the stored favorite is no longer a category.
	@MainActor private func prepareFavorites() {
		
		let sharedHealthCategories = try? SharedHealthCategories()
		self.state.favorites = favoritesRepository.items.filter { favorite in
			for category in sharedHealthCategories?.categories() ?? [] where category == favorite {
				return true
			}
			return false
		}
	}
	
	deinit {
		// Remove observers
		tokens.dataStoreToken.map(dataStore.observatory.remove)
		tokens.healthcareOrganizationStoreToken.map(healthcareOrganizationRepository.observatory.remove)
		tokens.favoritesStoreToken.map(favoritesRepository.observatory.remove)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthCategoriesViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
				
			case .search:
				coordinator?.handle(Coordination.Action.addHealthcareOrganization)
				
			case .refresh:
				if case let .single(healthcareOrganization) = mode {
					dataStore.removeRecords(for: healthcareOrganization.identifier)
					resourceRepository.loadFor(healthcareOrganization)
				} else {
					dataStore.removeAllRecords()
					resourceRepository.load()
				}
				reduce(.onAppear)
			
			case let .categorySelected(category):
				
				var params: [String: AnyHashable] = ["category": category]
				if case let .single(healthcareOrganization) = mode {
					params["healthcareOrganization"] = healthcareOrganization
				}
				
				coordinator?.handle(
					Coordination.Action(
						identifier: Coordination.Action.showHealthCategory.identifier,
						params: params
					)
				)
			
			case .onAppear:
				updateState()
			
			case .removeHealthcareOrganization:
				if case let .single(healthcareOrganization) = mode {
					coordinator?.handle(
						Coordination.Action(
							identifier: "removeHealthcareOrganization",
							params: ["healthcareOrganization": healthcareOrganization]
						)
					)
				}
			case .showFavorites:
				if case .all = mode {
					coordinator?.handle(.showFavorites)
				}
		}
	}
	
	/// The store has changed, update the
	@MainActor private func updateState() {
		
		for mainCategory in state.mainCategories {
			for category in mainCategory.categories {
				
				let cacheResult: Result<[MgoResourceRecord], Error> = {
					switch mode {
						case .single(let healthcareOrganization):
							return dataStore.get(
								categoryId: category.id,
								organizationId: healthcareOrganization.identifier
							)
						case .all:
							return dataStore.get(categoryId: category.id)
					}
				}()
				handleCacheResult(cacheResult, category: category)
			}
		}
	}

	/// Update the state
	/// - Parameter button: the button to update
	@MainActor private func handleCacheResult(
		_ cacheResult: Result<[MgoResourceRecord], Error>,
		category: SharedHealthCategories.Category
	) {
	
		let expectedNumberOfResults: Int = {
			switch mode {
				case .single(let organization):
					// All the services for that category
					return organization.servicesForCategory(category)
				case .all:
					// All the services for that category * the number of organizations
					var result = 0
					for organization in healthcareOrganizationRepository.organizations {
						result += organization.servicesForCategory(category)
					}
					return result
			}
		}()
		
		logVerbose("HealthCategoriesViewModel: expectedNumberOfResults = \(expectedNumberOfResults) for \(category)")
		
		guard expectedNumberOfResults > 0 else {
			state.buttonState[category.id] = .empty
			return
		}
		
		switch cacheResult {
			case let .success(records):
				handleCacheHit(category, records: records, expectedNumberOfResults: expectedNumberOfResults)
			case let .failure(error):
				handleCacheMiss(category, error: error)
		}
	}
	
	/// Handle the success path of the cache
	/// - Parameters:
	///   - category: the category
	///   - records: the records for the category
	///   - expectedNumberOfResults: the expected number of results
	private func handleCacheHit(
		_ category: SharedHealthCategories.Category,
		records: [MgoResourceRecord],
		expectedNumberOfResults: Int
	) {
		
		guard records.count >= expectedNumberOfResults else {
			// We don't have data for all organizations. Keep loading
			state.buttonState[category.id] = .loading
			return
		}
		
		// There are records for all organizations.
		// Let's check if any of them has data with an accepted profile
		var hasAcceptedProfile = false
		for record in records where record.resources.isNotEmpty {
			for resource in record.resources {
				for profile in category.profiles() where resource.hasProfile(profile) {
					hasAcceptedProfile = true
				}
			}
		}
		state.buttonState[category.id] = hasAcceptedProfile ? .loaded : .empty
	}
	
	/// handle the failure path of the cache
	/// - Parameters:
	///   - category: the category
	///   - error: the error
	private func handleCacheMiss(_ category: SharedHealthCategories.Category, error: Error) {
		
		// No records available. Keep in loading state.
		guard case DataStoreError.noData = error else {
			logError("Error", error)
			state.buttonState[category.id] = .empty
			return
		}
		state.buttonState[category.id] = .loading
	}
}

// swiftlint:disable type_body_length
/// The view for an overview of all the health categories
struct HealthCategoriesView: View {

	/// The View Model
	@StateObject var viewModel: HealthCategoriesViewModel
	
	/// Are we scrolling
	@State private var isScrolling: Bool = false
	
	/// The Theme
	@Environment(\.theme) var theme
	
	@State private var contentSize: CGSize = .zero
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let rowInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let headerInset = EdgeInsets(top: 24, leading: 0, bottom: 12, trailing: 0)
			static let alternativeInset = EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
			static let spacing: CGFloat = 4
			static let padding: CGFloat = 8
			static let demoSpacing: CGFloat = 16
			static let bottom: CGFloat = 16
		}
		enum NoResults {
			static let top: CGFloat = 44
		}
		enum Favorites {
			static let cornerRadius: CGFloat = if #available(iOS 26.0, *) {
				26
			} else {
				12
			}
			static let inset: CGFloat = 0.5
			static let rowInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let style = StrokeStyle(lineWidth: 1, dash: [5, 5])
			static let gridSpacing: CGFloat = 10
			static let minWidth: CGFloat = 153
		}
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {
		
		VStack(spacing: 0) {
			
			if viewModel.state.showEmptyView {
				noHealthcareOrganizationView()
			} else {
				categoriesView()
					.backport.listSectionSpacing(ViewTraits.List.spacing)
					.backport.contentMargins(0)
//					.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
			}
		} // VStack
		.navigationBarBackButtonHidden()
		.when(viewModel.state.backButtonTitle != nil, transform: { view in
			view
				.navigationBarItems(leading: BackButton(viewModel.state.backButtonTitle!) {
					viewModel.reduce(.backButtonPressed)
				})
		})
		.when(viewModel.state.canTitleCollapse) { view in
			view.navigationTitle(viewModel.state.heading)
		}
		.when(viewModel.state.belowIOS18 && !viewModel.state.canTitleCollapse) { view in
			view
				.navigationBarTitleDisplayMode(.inline)
		}
		.when(!viewModel.state.showEmptyView) { view in
			view
				.toolbar(content: toolbarContent)
		}
		.navigationBarHidden(false)
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.refreshable {
			viewModel.reduce(.refresh)
		}
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.readSize($contentSize)
	}
	
	/// The view for the header
	/// - Returns: header view
	@ViewBuilder func heading() -> some View {
		
		Text(viewModel.state.heading)
			.typography(.headingExtraLarge)
			.foregroundColor(theme.labels.primary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
			.accessibilityIdentifier("healthcare_organizations.heading")
			.padding(.top, ViewTraits.Navigation.padding)
	}
	
	/// The view for the sub heading
	/// - Returns: sub heading view
	@ViewBuilder func subHeading() -> some View {
		
		Text(viewModel.state.subheading)
			.typography(.bodyMedium)
			.foregroundColor(theme.labels.primary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityIdentifier("overview.subheading")
	}
	
	/// The view for the categories
	/// - Returns: category view
	@ViewBuilder func categoriesView() -> some View {
		
		List {
			
			if viewModel.state.canTitleCollapse {
				favorites()
			} else {
				listHeader()
			}
			
			ForEach(viewModel.state.mainCategories) { mainCategoryView($0) }
		} // List
		.backport.scrollContentBackground(.hidden)
		.listStyle(.insetGrouped)
	}
	
	/// The view for a main category
	/// - Parameter mainCategory: the main category
	/// - Returns: the main category view
	@ViewBuilder private func mainCategoryView(
		_ mainCategory: SharedHealthCategories.MainCategory
	) -> some View {
		
		// We should not show the categories that are marked
		// as favorite in this view. If a main category has all
		// its categories marked, we should hide it from view.
		let filteredCategories = viewModel.state.canTitleCollapse ? mainCategory.categories.filter { !viewModel.state.favorites.contains($0) } : mainCategory.categories
		
		if filteredCategories.isNotEmpty {
			
			Section {
				Text(mainCategory.localized())
					.typography(.headingMedium)
					.foregroundColor(theme.labels.primary)
					.accessibilityAddTraits(.isHeader)
			}
			.listRowBackground(Color.clear)
			.listRowInsets(listHeaderInset(for: mainCategory))
			
			Section {
				ForEach(filteredCategories) { categoryView($0) }
			}
		}
	}
	
	/// Calculate the header inset (the first header on the organization page has a smaller inset)
	/// - Parameter mainCategory: the main category
	/// - Returns: the inset
	func listHeaderInset(for mainCategory: SharedHealthCategories.MainCategory) -> EdgeInsets {
		
		if !viewModel.state.canTitleCollapse && mainCategory == viewModel.state.mainCategories.first {
			return ViewTraits.List.alternativeInset
		}
		return ViewTraits.List.headerInset
	}
	
	/// View for a category
	/// - Parameter category: the category
	/// - Returns: category view
	@ViewBuilder private func categoryView(
		_ category: SharedHealthCategories.Category,
		asFavorite: Bool = false
	) -> some View {
		
		if asFavorite {
			
			FavoriteRowView(
				category: category,
				state: viewModel.state.buttonState[category.id] ?? .notAvailable,
				perform: {
					viewModel.reduce(.categorySelected(category))
				}
			)
			
		} else {
			Button {
				viewModel.reduce(.categorySelected(category))
			} label: {
				HealthCategoryRowView(
					category: category,
					state: viewModel.state.buttonState[category.id] ?? .notAvailable
				)
			}
			.padding(.vertical, ViewTraits.List.padding)
			.accessibilityIdentifier(category.id)
			.contentShape(Rectangle())
			
		}
	}
	
	/// The list header
	/// - Returns: list header
	@ViewBuilder private func listHeader() -> some View {
		
		Section {
			VStack(spacing: ViewTraits.General.padding) {
				heading()
				subHeading()
					.padding(.bottom, ViewTraits.General.padding)
			}
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.rowInset)
	}
	
	/// The favorites section
	/// - Returns: list header
	@ViewBuilder private func favorites() -> some View {
		
		favoritesHeader()
		
		if viewModel.state.favorites.isEmpty {
			
			favoritesEmptyView()
		} else {
			
			let horizontalPadding = 2 * ViewTraits.General.padding
			let availableWidth = max(0, contentSize.width - horizontalPadding)
			let numberOfColumns = max(2, Int(availableWidth / ViewTraits.Favorites.minWidth))
			let columns = Array(repeating: GridItem(.flexible()), count: numberOfColumns)
			
			LazyVGrid(columns: columns, spacing: ViewTraits.Favorites.gridSpacing) {
				ForEach(viewModel.state.favorites) {
					categoryView($0, asFavorite: true)
						.cornerRadius(ViewTraits.Favorites.cornerRadius)
				}
			}
			.clipShape(Rectangle())
			.listRowInsets(ViewTraits.List.rowInset)
			.listRowBackground(Color.clear)
		}
	}
	
	/// The heading for the favorite section
	/// - Returns: view for the favorite header
	@ViewBuilder private func favoritesHeader() -> some View {
		Section {
			Text("overview.favorites.heading")
				.typography(.headingMedium)
				.foregroundColor(theme.labels.primary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.rowInset)
	}
	
	/// The empty state when the user has no favorite categories
	/// - Returns: view for the empty state
	@ViewBuilder private func favoritesEmptyView() -> some View {
		
		Section {
			addFavoriteCategoriesButton()
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.Favorites.rowInset)
	}
	
	/// The dashed button to add favorite categories
	/// - Returns: view for the add favorites button
	@ViewBuilder private func addFavoriteCategoriesButton() -> some View {
		
		VStack(spacing: 0) {
			
			Text("overview.favorites.empty.heading")
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.primary)
				.padding(.top, 2 * ViewTraits.General.padding)
				.multilineTextAlignment(.center)
			
			CallToActionButton(emptyActionKey, style: .ghost) {
				viewModel.reduce(.showFavorites)
			}
			.accessibilityIdentifier(emptyActionKey.stringKey)
			.padding(.bottom, ViewTraits.General.padding)
		}
		.overlay(
			RoundedRectangle(cornerRadius: ViewTraits.Favorites.cornerRadius)
				.inset(by: ViewTraits.Favorites.inset)
				.stroke(
					theme.separators.primary,
					style: ViewTraits.Favorites.style
				)
		)
	}
	
	/// The language key for adding favorite categories
	let emptyActionKey: LocalizedStringKey = "overview.favorites.empty.action"
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare organizations
	@ViewBuilder private func noHealthcareOrganizationView() -> some View {
		
		ScrollViewWithFixedBottom {
			
			ImageContentView(
				icon: Image(ImageResource.Woman.womanWithPhone),
				heading: "common.no_organizations_heading",
				subHeading: "common.no_organizations_subheading",
				subHeadingForegroundColor: theme.labels.primary
			)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.top, ViewTraits.NoResults.top)
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			
			CallToActionButton(
				Container.shared.featureFlagManager().isAutomaticLocalizationEnabled ? "common.search_organizations" : "common.add_organizations",
				style: .solid(rounded: osVersionChecker.available(version: .iOS(.v26)))
			) {
				viewModel.reduce(.search)
			}
			.accessibilityIdentifier("common.add_organizations")
			.padding(ViewTraits.Button.insets)
		}
	}
	
	/// Get the toolbar content (favorites)
	/// - Returns: the toolbar content
	@ToolbarContentBuilder private func toolbarContent() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {
				
				if viewModel.state.canTitleCollapse && !viewModel.state.showRemoveHealthcareProvider {
					// Show more button, but immediately show the favorites sheet
					Button {
						viewModel.reduce(.showFavorites)
					} label: {
						moreIcon()
					}
				} else {
					Menu {
						if viewModel.state.canTitleCollapse {
							menuFavoritesOption()
						}
						if viewModel.state.showRemoveHealthcareProvider {
							menuRemoveHealthcareOrganizationOption()
						}
					} label: {
						moreIcon()
					}
					.buttonStyle(ToolbarButtonStyle())
					.accessibilityLabel("overview.menu")
				}
			}
		)
	}
	
	@ViewBuilder func moreIcon() -> some View {
		
		if osVersionChecker.available(version: .iOS(.v26)) {
			Image(ImageResource.Icon.more26)
				.foregroundStyle(theme.labels.primary)
		} else {
			Image(ImageResource.Icon.more)
		}
	}
	
	/// The favorites option
	/// - Returns: view
	@ViewBuilder func menuFavoritesOption() -> some View {
		
		Button {
			viewModel.reduce(.showFavorites)
		} label: {
			Label(emptyActionKey, systemImage: "star")
				.tint(theme.labels.primary)
		}
	}
	
	/// The remove healthcare organization option
	/// - Returns: view
	@ViewBuilder func menuRemoveHealthcareOrganizationOption() -> some View {
		
		Button(role: .destructive) {
			viewModel.reduce(.removeHealthcareOrganization)
		} label: {
			Label("organizations.remove_organization", systemImage: "trash")
				.tint(theme.states.critical)
		}
	}
}
// swiftlint: enable type_body_length

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthCategoriesView(
			viewModel: HealthCategoriesViewModel(
				coordinator: nil,
				mode: .single(PreviewContent.healthcareOrganization)
			)
		)
	}
}
