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

/// A small struct for the various translations for each category
struct HealthCategoryViewTranslations {

	/// the title key of the page
	var heading: String.LocalizationValue

	/// the text key for the search bar
	var search: LocalizedStringKey

	/// the text key for no search results
	var noSearchResults: LocalizedStringKey

	/// The text key for the heading of the details
	var backButtonTitle: String.LocalizationValue
}

class HealthCategoryViewModel: ObservableObject {

	/// The state of the view
	@Published var state: HealthCategoryViewState

	/// All the translated copy
	@Published var translations: HealthCategoryViewTranslations

	/// Show the export dialog
	@Published var showExportAlert: Bool = false

	/// The category to show
	@Published var category: SharedHealthCategories.Category

	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?

	/// The organization to show the categories for (optional, if nil, then show all organizations)
	private var organization: OrganizationSearch.Organization?

	/// Token for the data store observatory
	private var dataStoreToken: Observatory.ObserverToken?

	/// The HCIM parser
	private let parser = HCIMParser()

	/// Dependency Healthcare Organization Store
	@Injected(\.healthcareOrganizationRepository) private var healthcareOrganizationRepository

	/// Dependency Injectable Data Store
	@Injected(\.dataStore) private var dataStore

	/// Dependency Injectable Resource Repository
	@Injected(\.resourceRepository) private var resourceRepository

	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case cancelExportAlert
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
		translations: HealthCategoryViewTranslations
	) {
		self.coordinator = coordinator
		self.category = category
		self.organization = organization
		self.state = .loading
		self.translations = translations
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
					// Handle updates in the fetched data
					self?.handleDataStoreChanges()
				}
			}
		}
	}

	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: HealthCategoryViewModel.Action) {

		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)

			case .onAppear:
				FileStorage().remove(HealthDirectory.binary)
				FileStorage().remove(HealthDirectory.export)
				_Concurrency.Task(priority: .userInitiated) {
					 await loadResources()
				}

			case .retry:
				Haptic.light()
				retry()

			case .showExportAlert:
				showExportAlert = true

			case .cancelExportAlert:
				showExportAlert = false

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

				let sorted = sortRecords(records: records)

				withAnimation {
					if sorted.clientError || sorted.serverError {

						state =
							.list(
								items: sorted.subCategories,
								errorState: .error(
									heading: String(
										localized: sorted.subCategories.flatMap { $0.rows }.isNotEmpty ? "errorstate.partial_error" : "errorstate.error"
									),
									subHeading: String(
										localized: sorted.clientError ? "errorstate.clientside.heading" : "errorstate.serverside.heading"
									)
								)
							)
					} else {
						state =
							.list(
								items: sorted.subCategories,
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

	/// Sort the records on subcategory
	/// - Parameter records: the records to sort
	/// - Returns: sorted sub categories
	@MainActor internal func sortRecords(
		records: [MgoResourceRecord]
	) -> (subCategories: [HealthCategoryBlock], clientError: Bool, serverError: Bool) {

		var items = [HealthCategoryBlock]()
		var hasClientError = false
		var hasServerError = false

		// Create list of subcategories
		for subcategory in category.subcategories {
			for profile in subcategory.profiles {
				var subCat = HealthCategoryBlock(
					heading: subcategory.localized(),
					rows: []
				)
				for record in records {
					subCat.rows.append(contentsOf: parseRecord(record, acceptedProfile: profile))
					hasClientError = hasClientError || record.error == ResourceRepositoryError.client.rawValue
					hasServerError = hasServerError || record.error == ResourceRepositoryError.server.rawValue

				}
				// There might be another subcategory with the same heading.
				// Append to that subcategory rather then append as a new subcategory
				var existingSubCategory = false
				items.enumerated().forEach { index, item in
					if item.heading == subCat.heading {
						items[index].rows.append(contentsOf: subCat.rows)
						existingSubCategory = true
					}
				}
				if !existingSubCategory {
					items.append(subCat)
				}
			}
		}
		return (items, hasClientError, hasServerError)
	}

	/// Extract rows from the data store records
	/// - Parameter record: the record
	/// - Returns: displayable rows
	@MainActor private func parseRecord(
		_ record: MgoResourceRecord,
		acceptedProfile: String
	) -> [HealthCategoryRow] {

		var items = [HealthCategoryRow]()
		// For all the MgoResources
		for resource in record.resources where resource.hasProfile(acceptedProfile) {
			let orginizationName = Sanitizer.strip(getOrganizationName(record.organizationId))
			if let uiSchema = parser.getSummary(resource, organizationName: orginizationName),
			   let cardInfo = parser.getCard(resource, organizationName: orginizationName) {
				// Add a HealthCategoryBlock to the display list
				items.append(
					HealthCategoryRow(
						heading: Sanitizer.sanitize(cardInfo.title),
						subHeading: cardInfo.description,
						schema: uiSchema,
						details: cardInfo.detail
					) { [weak self] in

						guard let self else { return }

						self.coordinator?.handle(Coordination.Action(
							identifier: Coordination.Action.showHealthData.identifier,
							params: [
								"healthcareOrganization": self.getOrganization(record.organizationId),
								"backButtonTitle": String(localized: self.translations.backButtonTitle),
								"titleInline": false,
								"resource": resource,
								"uiSchema": uiSchema,
								"inSheet": false
							])
						)
					}
				)
			}
		}
		return items
	}

	/// Get the name of a healthcare organisation
	/// - Parameter identifier: the identifier of the organization
	/// - Returns: optional name
	func getOrganizationName(_ identifier: String) -> String? {

		return getOrganization(identifier)?.name
	}

	/// Get the name of a healthcare organisation
	/// - Parameter identifier: the identifier of the organization
	/// - Returns: optional name
	func getOrganization(_ identifier: String) -> OrganizationSearch.Organization? {

		return healthcareOrganizationRepository.organizations
			.first { $0.identifier == identifier }
	}
}
