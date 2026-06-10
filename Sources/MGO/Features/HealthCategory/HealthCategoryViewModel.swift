/*
 *  SPDX-FileCopyrightText: 2026 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

/// A small struct for each category result
struct HealthCategoryRow: Equatable, Identifiable {
	
	/// Equality
	/// - Parameters:
	///   - lhs: the left hand block
	///   - rhs: the right hand block
	/// - Returns: True is both blocks are equal
	static func == (lhs: HealthCategoryRow, rhs: HealthCategoryRow) -> Bool {
		return lhs.heading == rhs.heading &&
		lhs.subHeading == rhs.subHeading &&
		lhs.details == rhs.details &&
		lhs.schema == rhs.schema &&
		lhs.id == rhs.id
	}
	
	/// Identifier of a block
	let id = UUID()
	
	/// The title heading of a block
	let heading: String
	
	/// The subtitle of a block
	let subHeading: String?
	
	/// The underlying schema (needed for pdf generation)
	let schema: HealthUISchema
	
	/// The details of a block
	let details: String?
	
	/// action to perform when the user taps on this block
	var action: (() -> Void)?
}

struct HealthCategoryBlock: Equatable, Identifiable {
	
	/// Identifier of a sub category
	let id = UUID()
	
	/// The heading for a sub category
	let heading: String
	
	/// The health category rows
	var rows: [HealthCategoryRow]
	
	/// `true` for the trailing "unknown date" bucket produced by the timeline
	/// layout. Such a block opts out of the timeline column even when the
	/// surrounding view is rendering in `.timeline` mode.
	var isUnknownDate: Bool = false
}

/// The state of the view
enum HealthCategoryViewState: Equatable {
	
	/// The data is being loading
	case loading
	
	/// The data is available (with errors)
	case list(items: [HealthCategoryBlock], errorState: HealthCategoriesErrorState)
	
	/// Equality
	/// - Parameters:
	///   - lhs: left hand state
	///   - rhs: right hand state
	/// - Returns: True if both states are equal
	static func == (lhs: HealthCategoryViewState, rhs: HealthCategoryViewState) -> Bool {
		switch (lhs, rhs) {
				
			case (.loading, .loading):
				return true
				
			case let(.list(lhsList, lhsError), .list(rhsList, rhsError)):
				
				guard lhsError == rhsError, lhsList.count == rhsList.count else { return false }
				var result = true
				for index in lhsList.indices {
					result = result && lhsList[index] == rhsList[index]
				}
				return result
				
			default:
				return false
		}
	}
}

enum HealthCategoryViewType {
	case regular
	case timeline
}

class HealthCategoryViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: HealthCategoryViewState
	
	/// Show the export dialog
	@Published var showExportAlert: Bool = false
	
	/// The category to show
	@Published var category: SharedHealthCategories.Category
	
	/// The display type, regular or timeline
	@Published var type: HealthCategoryViewType
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The organization to show the categories for (optional, if nil, then show all organizations)
	private var organization: OrganizationSearch.Organization?
	
	/// Token for the data store observatory
	private var dataStoreToken: Observatory.ObserverToken?
	
	private var handleDataStoreChangesDebounceTask: Task<Void, Never>?
	
	/// The file storage
	private let fileStorage: FileStorageProtocol
	
	/// Dependency Healthcare Organization Store
	@Injected(\.healthcareOrganizationRepository) private var healthcareOrganizationRepository
	
	/// Dependency Injectable Data Store
	@Injected(\.dataStore) private var dataStore
	
	/// Dependency Injectable Resource Repository
	@Injected(\.resourceRepository) private var resourceRepository
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case exportHealthData
		case onAppear
		case retry
		case showExportAlert
	}
	
	/// Create a Health category view model
	/// - Parameter coordinator: the app coordinator
	@MainActor init(
		coordinator: (any Coordinator)? = nil,
		category: SharedHealthCategories.Category,
		organization: OrganizationSearch.Organization?,
		type: HealthCategoryViewType = .regular,
		fileStorage: FileStorageProtocol = FileStorage()
	) {
		self.coordinator = coordinator
		self.category = category
		self.organization = organization
		self.state = .loading
		self.type = type
		self.fileStorage = fileStorage
		registerObservers()
	}
	
	deinit {
		// Remove as observer
		dataStoreToken.map(dataStore.observatory.remove)
	}
	
	@MainActor private func registerObservers() {
		
		self.dataStoreToken = dataStore.observatory.append { [weak self] changed in
			if changed {
				Task { @MainActor in
					// Handle updates in the fetched data — debounced to avoid flooding the main
					// thread when many records are stored in rapid succession (e.g. many providers).
					self?.scheduleHandleDataStoreChanges()
				}
			}
		}
	}
	
	@MainActor private func scheduleHandleDataStoreChanges() {
		
		handleDataStoreChangesDebounceTask?.cancel()
		handleDataStoreChangesDebounceTask = Task { [weak self] in
			do {
				try await Task.sleep(nanoseconds: 150_000_000)
			} catch {
				return
			}
			self?.handleDataStoreChanges()
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthCategoryViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
				
			case .onAppear:
				guard case .loading = state else { return }
				fileStorage.remove(HealthDirectory.binary)
				fileStorage.remove(HealthDirectory.export)
				_Concurrency.Task(priority: .userInitiated) {
					await loadResources()
				}
				
			case .retry:
				Haptic.light()
				retry()
				
			case .showExportAlert:
				var transaction = Transaction()
				transaction.disablesAnimations = true
				withTransaction(transaction) { showExportAlert = true }
				
			case .exportHealthData:
				
				var blocks = [HealthCategoryBlock]()
				if case let .list(items, _) = state {
					blocks = items
				}
				
				let data = HealthDataMapper().map(
					category.localizedHeading(),
					blocks: blocks
				)
				
				coordinator?.handle(
					Coordination.Action(
						identifier: Coordination.Action.exportHealthData.identifier,
						params: [
							"healthData": data
						]
					)
				)
		}
	}
	
	/// Retry the failed category
	@MainActor private func retry() {
		
		if case let .list(items, _) = state {
			if items.flatMap({ $0.rows }).isNotEmpty {
				// Partial
				state = .list(items: items, errorState: .loading)
			} else {
				state = .loading
			}
		}
		
		let cacheResult = getStoredResourceRecords()
		if case let .success(records) = cacheResult {
			let faultyRecords = records.filter { $0.error != nil }
			
			faultyRecords.forEach { record in
				
				guard let faultyOrganization = getOrganization(record.organizationId) else {
					return
				}
				dataStore.removeRecords(
					for: record.categoryId,
					organizationId: record.organizationId
				)
				resourceRepository.loadResource(faultyOrganization, categories: [category])
			}
		}
	}
	
	/// Get the stored resourced from the caches
	/// - Returns: cache results
	@MainActor
	private func getStoredResourceRecords() -> Result<[MgoResourceRecord], Error> {
		
		if let organization {
			return dataStore.get(
				categoryId: category.id,
				organizationId: organization.identifier
			)
		} else {
			return dataStore.get(categoryId: category.id)
		}
	}
	
	@MainActor
	func handleDataStoreChanges() {
		
		let expectedNumberOfResults: Int = {
			if organization == nil {
				var result = 0
				for organizationItem in healthcareOrganizationRepository.organizations {
					result += organizationItem.servicesForCategory(category)
				}
				return result
			} else {
				return organization?.servicesForCategory(category) ?? 0
			}
		}()
		_Concurrency.Task(priority: .high) {
			await loadResources(threshold: expectedNumberOfResults)
		}
	}
	
	@MainActor
	private func loadResources(threshold: Int = 0) async {
		
		switch getStoredResourceRecords() {
			case .success(let records):
				guard records.count >= threshold else {
					// Not all results are in. Keep loading state
					return
				}
				
				let sorter = HealthCategoryRecordSorter(
					category: category,
					resolveOrganization: { [weak self] in self?.getOrganization($0) },
					makeRowAction: { resource, uiSchema, organizationId in
						return { [weak self] in
							guard let self else { return }
							self.coordinator?.handle(Coordination.Action(
								identifier: Coordination.Action.showHealthData.identifier,
								params: [
									"healthcareOrganization": self.getOrganization(organizationId),
									"backButtonTitle": "common.previous",
									"resource": resource,
									"uiSchema": uiSchema,
									"inSheet": false
								])
							)
						}
					}
				)
				let sorted = sorter.sort(records: records, type: type)
				
				withAnimation {
					if sorted.clientError || sorted.serverError {
						
						state =
							.list(
								items: sorted.blocks,
								errorState: .error(
									heading: String(
										localized: sorted.blocks.flatMap { $0.rows }.isNotEmpty ? "errorstate.partial_error" : "errorstate.error"
									),
									subHeading: String(
										localized: sorted.clientError ? "errorstate.clientside.heading" : "errorstate.serverside.heading"
									)
								)
							)
					} else {
						state =
							.list(
								items: sorted.blocks,
								errorState: .none
							)
					}
				}
			case .failure:
				if threshold == 0 {
					// No data yet; stay loading until the observer delivers it
					return
				}
				state = .list(items: [], errorState: .none)
		}
	}
	
	/// Resolve a healthcare organization by identifier.
	/// - Parameter identifier: the identifier of the organization
	/// - Returns: the matching organization, or `nil` if none is registered
	func getOrganization(_ identifier: String) -> OrganizationSearch.Organization? {
		
		return healthcareOrganizationRepository.organizations
			.first { $0.identifier == identifier }
	}
}
