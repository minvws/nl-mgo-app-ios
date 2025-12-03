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

/// The error state for the overview
enum HealthCategoriesErrorState: Equatable {
	
	/// No error
	case none
	
	/// We are reloading
	case loading
	
	/// There is an error
	case error(heading: String, subHeading: String)
}

struct HealthCategoriesViewState {
	
	var heading: String
	var subheading: String
	var canTitleCollapse: Bool
	var showEmptyView: Bool
	var showRemoveHealthcareProvider: Bool
	var errorState: HealthCategoriesErrorState
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
	
	private var observationTokens = Tokens()
	
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
		case retry
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
			showEmptyView: true,
			showRemoveHealthcareProvider: showRemoveHealthcareProvider,
			errorState: .none,
			mainCategories: sharedHealthCategories?.mainCategories ?? [],
			buttonState: initialButtonState,
			favorites: [],
			backButtonTitle: backbuttonTitle,
			belowIOS18: belowIOS18
		)
		self.state.showEmptyView = healthcareOrganizationRepository.organizations.isEmpty
		prepareFavorites()
		registerObservers()
	}
	
	@MainActor private func registerObservers() {
		self.observationTokens.dataStoreToken = dataStore.observatory.append { [weak self] changed in
			if changed {
				Task { @MainActor in
					// Handle updates in the fetched data
					self?.updateState()
				}
			}
		}
		
		self.observationTokens.healthcareOrganizationStoreToken = healthcareOrganizationRepository.observatory.append { [weak self] _ in
			Task { @MainActor in
				// Check if there are any healthcare organizations left.
				self?.state.showEmptyView = self?.healthcareOrganizationRepository.organizations.isEmpty ?? true
			}
		}
		
		self.observationTokens.favoritesStoreToken = favoritesRepository.observatory.append { [weak self] _ in
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
		observationTokens.dataStoreToken.map(dataStore.observatory.remove)
		observationTokens.healthcareOrganizationStoreToken.map(healthcareOrganizationRepository.observatory.remove)
		observationTokens.favoritesStoreToken.map(favoritesRepository.observatory.remove)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthCategoriesViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
				
			case .search:
				coordinator?.handle(Coordination.Action.addHealthcareOrganization)
			
			case .retry:
				withAnimation {
					state.errorState = .loading
				}
				reduce(.refresh)
				
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
		updateErrorState()
	}
	
	/// Update the error state
	@MainActor private func updateErrorState() {
		
		var hasClientError = false
		var hasServerError = false
		var hasContent = false
		var stillLoading = false
		
		for (_, buttonState) in state.buttonState {
			switch buttonState {
				case .clientError:
					hasClientError = true
				case .serverError:
					hasServerError = true
				case .loaded:
					hasContent = true
				case .loading:
					stillLoading = true
				default:
					// empty and notAvailable
					break
			}
		}
		
		guard !stillLoading else {
			return
		}
		
		if hasClientError || hasServerError {
			state.errorState = .error(
				heading: String(localized: hasContent ? "errorstate.partial_error" : "errorstate.error"),
				subHeading: String(localized: hasClientError ? "errorstate.clientside.heading" : "errorstate.serverside.heading")
			)
		} else {
			state.errorState = .none
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
		var hasClientError = false
		var hasServerError = false
		for record in records where record.error != nil {
			hasClientError = record.error == ResourceRepositoryError.client.rawValue
			hasServerError = record.error == ResourceRepositoryError.server.rawValue
		}
		for record in records where record.resources.isNotEmpty {
			for resource in record.resources {
				for profile in category.profiles() where resource.hasProfile(profile) {
					hasAcceptedProfile = true
				}
			}
		}
		switch (hasClientError, hasServerError, hasAcceptedProfile) {
			case (true, _, _):
				state.buttonState[category.id] = .clientError
			case (false, true, _):
				state.buttonState[category.id] = .serverError
			case (false, false, true):
				state.buttonState[category.id] = .loaded
			case (false, false, false):
				state.buttonState[category.id] = .empty
		}
	}
	
	/// handle the failure path of the cache
	/// - Parameters:
	///   - category: the category
	///   - error: the error
	private func handleCacheMiss(
		_ category: SharedHealthCategories.Category,
		error: Error
	) {
		
		// No records available. Keep in loading state.
		guard case DataStoreError.noData = error else {
			logError("Error", error)
			state.buttonState[category.id] = .serverError
			return
		}
		state.buttonState[category.id] = .loading
	}
}
