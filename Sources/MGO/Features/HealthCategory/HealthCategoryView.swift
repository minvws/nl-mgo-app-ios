/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
		lhs.id == rhs.id
	}

	/// Identifier of a block
	let id = UUID()
	
	/// The title heading of a block
	let heading: String?
	
	/// The subtitle of a block
	let subHeading: String?
	
	/// action to perform when the user taps on this block
	var action: (() -> Void)?
}

struct HealthSubCategory: Equatable, Identifiable {
	
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
	
	/// All the data is available
	case list(items: [HealthSubCategory])
	
	/// Only partial data is available
	case partial(items: [HealthSubCategory])
	
	/// Equality
	/// - Parameters:
	///   - lhs: left hand state
	///   - rhs: right hand state
	/// - Returns: True if both states are equal
	static func == (lhs: HealthCategoryViewState, rhs: HealthCategoryViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
			
			case let(.list(lhsList), .list(rhsList)):
			
				guard lhsList.count == rhsList.count else { return false }
				var result = true
				for index in lhsList.indices {
					result = result && lhsList[index] == rhsList[index]
				}
				return result
			
			case let(.partial(lhsList), .partial(rhsList)):
		
				guard lhsList.count == rhsList.count else { return false }
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

// A small struct for the various translations for each category
struct HealthCategoryViewTranslations {

	/// the title key of the page
	var heading: LocalizedStringKey

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
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The organization to show the categories for (optional, if nil, then show all organizations)
	private var organization: MgoOrganization?
	
	/// The category to show
	private var category: HealthCategories.Category
	
	/// The text to filter the results on. 
	@Published var searchText = ""
	
	/// Token for the data store observatory
	private var dataStoreToken: Observatory.ObserverToken?
	
	/// The FHIR Parser
	private let parser = FHIRParser()
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case onAppear
		case retry
	}
	
	/// Create a MedicationOverview VM
	/// - Parameter coordinator: the app coordinator
	init(
		coordinator: (any Coordinator)? = nil,
		category: HealthCategories.Category,
		organization: MgoOrganization?,
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
		dataStoreToken.map(Current.dataStore.observatory.remove)
	}
	
	private func registerObservers() {
		self.dataStoreToken = Current.dataStore.observatory.append { [weak self] changed in
			if changed {
				// Handle updates in the fetched data
				self?.handleDataStoreChanges()
			}
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthCategoryViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .onAppear:
				BinaryRepository().clear()
				_Concurrency.Task {
					 await loadResources()
				}
			case .retry:
				retry()
				Haptic.light()
		}
	}
	
	private func retry() {
		
		state = .loading
		Current.dataStore.removeRecords(for: "\(category.rawValue)", organizationId: organization?.identifier)
		
		guard category.services.isNotEmpty else {
			_Concurrency.Task.delayed(byTimeInterval: 1.5) { [weak self] in
				await self?.loadResources()
			}
			return
		}
		
		_Concurrency.Task {
			if let organization {
				await Current.resourceRepository.loadResource(organization, category: category)
			} else {
				await Current.resourceRepository.loadFor(category)
			}
		}
	}
	
	func handleDataStoreChanges() {
		let expectedNumberOfResults: Int = {
			if organization == nil {
				var result = 0
				for organizationItem in Current.healthcareOrganizationStore.organizations {
					result += organizationItem.servicesForCategory(category)
				}
				return result
			} else {
				return organization?.servicesForCategory(category) ?? 0
			}
		}()
		_Concurrency.Task {
			 await loadResources(threshold: expectedNumberOfResults)
		}
	}
	
	@MainActor
	private func loadResources(threshold: Int = 0) async {
		
		let cacheResult: Result<[MgoResourceRecord], Error> = {
			if let organization {
				return Current.dataStore.get(categoryId: "\(category.rawValue)", organizationId: organization.identifier)
			} else {
				return Current.dataStore.get(categoryId: "\(category.rawValue)")
			}
		}()
		
		switch cacheResult {
			case .success(let records):
				guard records.count >= threshold else {
					// Not all results are in. Keep loading
					state = .loading
					return
				}
				
				let sorted = sortRecords(records: records)

				if sorted.partial {
					state = .partial(items: sorted.subCategories)
				} else {
					state = .list(items: sorted.subCategories)
				}
			case .failure:
				state = .list(items: [])
		}
	}
	
	/// Sort the records on subcategory
	/// - Parameter records: the records to sort
	/// - Returns: sorted sub categories
	private func sortRecords(records: [MgoResourceRecord]) -> (partial: Bool, subCategories: [HealthSubCategory]) {
		
		var items = [HealthSubCategory]()
		var partial = false
		
		// Create list of subcategories
		for profile in category.acceptedProfiles {
			if let heading = category.subCategory(profile) {
				var subCat = HealthSubCategory(heading: String(localized: heading), rows: [])
				for record in records {
					subCat.rows.append(contentsOf: parseRecord(record, acceptedProfile: profile))
					partial = partial || record.error
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
				if !existingSubCategory && subCat.rows.isNotEmpty {
					items.append(subCat)
				}
			}
		}
		
		return (partial, items)
	}
	
	/// Extract rows from the data store records
	/// - Parameter record: the record
	/// - Returns: displayable rows
	private func parseRecord(_ record: MgoResourceRecord, acceptedProfile: String) -> [HealthCategoryRow] {
		
		var items = [HealthCategoryRow]()
		// For all the MgoResources
		for resource in record.resources where resource.hasProfile(acceptedProfile) {
			
			if let uiSchema = parser.getSummary(resource) {
				// Add a HealthCategoryBlock to the display list
				items.append(
					HealthCategoryRow(
						heading: Sanitizer.strip(uiSchema.label),
						subHeading: Sanitizer.strip(getOrganizationName(record.organizationId))) { [weak self] in
							
							guard let self else { return }
							
							self.coordinator?.handle(Coordination.Action(
								identifier: Coordination.Action.showHealthData.identifier,
								params: [
									"healthcareOrganization": self.getOrganization(record.organizationId),
									"backButtonTitle": String(localized: self.translations.backButtonTitle),
									"resource": resource,
									"uiSchema": uiSchema
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
		
		return getOrganization(identifier)?.display_name
	}
	
	/// Get the name of a healthcare organisation
	/// - Parameter identifier: the identifier of the organization
	/// - Returns: optional name
	func getOrganization(_ identifier: String) -> MgoOrganization? {
		
		return Current.healthcareOrganizationStore.organizations.first { $0.identifier == identifier }
	}
}

struct HealthCategoryView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthCategoryViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	@State private var showBanner = true
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let top: CGFloat = 8
			static let spacing: CGFloat = 8
			static let cornerRadius: CGFloat = 10
		}
		enum NoResults {
			static let width: CGFloat = 0.5
			static let padding: CGFloat = 16
			static let top: CGFloat = 50
			static let spacing: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollView {
			
			switch viewModel.state {
				case .loading:
					
					Spacer()
					LoadingCardView(
						title: "common.loading",
						showBorder: false
					)
					
				case let .list(items):
					
					listOverview(list: items)
				
				case let .partial(items: items):
				
					if showBanner {
						BannerView(
							Feedback(
								title: String(localized: "common.failed_to_load_data"),
								subtitle: String(localized: "common.error_in_system"),
								actionTitle: String(localized: "common.try_again"),
								type: .warning,
								perform: {
									viewModel.reduce(.retry)
								}
							)
						) {
							withAnimation {
								showBanner = false
							}
						}
						.padding(.horizontal, ViewTraits.General.padding)
					}
					listOverview(list: items)
			}
			Spacer()
		}
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("overview.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationTitle(viewModel.translations.heading)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.layoutForIPad()
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverview(list: [HealthSubCategory]) -> some View {
	
		VStack {
			if list.isNotEmpty {
				listOverviewBlocks(list: filterList(list))
			} else {
				noItems()
			}
		}
		.padding(.horizontal, ViewTraits.General.padding)
	}
	
	/// Get the filtered search result list
	/// - Parameter list: the original list
	/// - Returns: filtered list
	private func filterList(_ list: [HealthSubCategory]) -> [HealthSubCategory] {
		
		guard viewModel.searchText.isNotEmpty else {
			return list
		}
		
		var result = [HealthSubCategory]()
		for sub in list {
			let filteredItems = sub.rows.filter {
				($0.heading?.localizedCaseInsensitiveContains(viewModel.searchText.lowercased()) ?? false) ||
				$0.subHeading?.localizedCaseInsensitiveContains(viewModel.searchText.lowercased()) ?? false
			}
			if filteredItems.isNotEmpty {
				result.append(HealthSubCategory(heading: sub.heading, rows: filteredItems))
			}
		}
		return result
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverviewBlocks(list: [HealthSubCategory]) -> some View {
		
		VStack {
			
			if list.isEmpty {
				noSearchItems()
			} else {
				VStack(alignment: .leading, spacing: ViewTraits.List.spacing, content: {
					
					ForEach(Array(list.enumerated()), id: \.offset) { subCategoryIndex, subCategory in
					
						if subCategory.rows.isNotEmpty {
							if list.count != 1 {
								Text(subCategory.heading)
									.rijksoverheidStyle(font: .regular, style: .body)
									.foregroundColor(theme.contentPrimary)
									.padding(.top, ViewTraits.List.top)
							}
							
							ForEach(Array(subCategory.rows.enumerated()), id: \.offset) { index, element in
								
								ZStack {
									Rectangle()
										.foregroundStyle(.clear)
										.accessibilityLabel(String(
											format: String(localized: "medication_overview.voiceover"),
											arguments: ["\(element.heading ?? "")", "\(element.subHeading ?? "")"]
										))
										.accessibilityIdentifier("category_element_\(subCategoryIndex)_\(index)")
										.accessibilityAddTraits(.isButton)
									
									ActionCardView(
										title: LocalizedStringKey(stringLiteral: element.heading ?? ""),
										message: LocalizedStringKey(stringLiteral: element.subHeading ?? ""),
										perform: element.action
									)
									.cornerRadius(ViewTraits.List.cornerRadius)
								}
								.onTapGesture {
									element.action?()
								}
							}
						}
					}
				})
				.padding(.top, ViewTraits.Navigation.padding)
			}
		}
		.when(Configuration().getRelease() != .demo) { view in
			view
				.searchable(text: $viewModel.searchText, prompt: viewModel.translations.search)
		}
		.rijksoverheidStyle(font: .regular, style: .body)
		.foregroundColor(theme.contentSecondary)
	}
	
	/// The view for no search items
	/// - Returns: view
	@ViewBuilder func noSearchItems() -> some View {
		
		ImageContentView(
			icon: Image(ImageResource.Woman.womanWithPhoneExclamation),
			heading: viewModel.translations.noSearchResults,
			subHeading: "health_category.search_again",
			subHeadingForegroundColor: theme.contentPrimary
		)
			.frame(maxWidth: .infinity)
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.top, ViewTraits.NoResults.top)
	}
	
	/// The view for no  items
	/// - Returns: view
	@ViewBuilder func noItems() -> some View {
		
		ImageContentView(
			icon: Image(ImageResource.Woman.womanWithPhone),
			heading: "health_category.empty.heading",
			subHeading: "health_category.empty.subheading",
			subHeadingForegroundColor: theme.contentPrimary
		)
			.frame(maxWidth: .infinity)
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.top, ViewTraits.NoResults.top)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthCategoryView(
			viewModel: HealthCategoryViewModel(
				coordinator: nil,
				category: HealthCategories.Category.medication,
				organization: PreviewContent.healthcareOrganization,
				translations: HealthCategoryViewTranslations(
					heading: "hc_medication.heading",
					search: "hc_medication.search",
					noSearchResults: "hc_medication.no_search_results",
					backButtonTitle: "hc_medication.heading_detail"
				)
			)
		)
	}
}
