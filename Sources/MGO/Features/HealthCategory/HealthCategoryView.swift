/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import JavaScriptCore
import Zibs

/// A small struct for each category result
struct HealthCategoryBlock: Equatable, Identifiable {
	
	/// Equality
	/// - Parameters:
	///   - lhs: the left hand block
	///   - rhs: the right hand block
	/// - Returns: True is both blocks are equal
	static func == (lhs: HealthCategoryBlock, rhs: HealthCategoryBlock) -> Bool {
		return lhs.heading == rhs.heading &&
		lhs.subHeading == rhs.subHeading &&
		lhs.id == rhs.id
	}

	let id = UUID()
	
	var heading: String?
	
	var subHeading: String?
	
	var action: (() -> Void)?
}

/// The state of the view
enum HealthCategoryViewState: Equatable {

	/// The data is being loading
	case loading
	
	/// All the data is available
	case list(items: [HealthCategoryBlock])
	
	/// Only partial data is available
	case partial(items: [HealthCategoryBlock])
	
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
	var detailsHeading: String.LocalizationValue
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
				_Concurrency.Task {
					 await loadResources()
				}
			case .retry:
				retry()
				Haptic.light()
		}
	}
	
	func retry() {
		
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
				return category.services.count * Current.healthcareOrganizationStore.organizations.count
			} else {
				return category.services.count
			}
		}()
		_Concurrency.Task {
			 await loadResources(threshold: expectedNumberOfResults)
		}
	}
	
	@MainActor
	func loadResources(threshold: Int = 0) async {
		
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
			
				var items = [HealthCategoryBlock]()
				var partial = false
				for record in records {
					items.append(contentsOf: parseRecord(record))
					partial = partial || record.error
				}
				if partial {
					state = .partial(items: items)
				} else {
					state = .list(items: items)
				}
			case .failure:
				state = .partial(items: [])
		}
	}
	
	/// Extract items from the data store records
	/// - Parameter record: the record
	/// - Returns: displayable items
	private func parseRecord(_ record: MgoResourceRecord) -> [HealthCategoryBlock] {
		
		var items = [HealthCategoryBlock]()
		// For all the MgoResources
		for resource in record.resources {
			if let uiSchema = FHIRParser().getUiSchemaJson(resource) {
				// Add a OverviewBlock to the display list
				items.append(
					HealthCategoryBlock(
						heading: Sanitizer.strip(uiSchema.label),
						subHeading: Sanitizer.strip(getOrganizationName(record.organizationId))) {
							self.coordinator?.handle(Coordination.Action(
								identifier: Coordination.Action.showZibDetails.identifier,
								params: [
									"heading": String(localized: self.translations.detailsHeading),
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
		
		return Current.healthcareOrganizationStore.organizations.first { $0.identifier == identifier }?.display_name
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
			static let cornerRadius: CGFloat = 8
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
								title: String(localized: "health_category.error.banner.heading"),
								subtitle: String(localized: "health_category.error.banner.subheading"),
								actionTitle: String(localized: "health_category.error.banner.try_again"),
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
					}
					listOverview(list: items)
			}
			
			Spacer()
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("health_categories.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.large)
		.navigationTitle(viewModel.translations.heading)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
		.layoutForIPad()
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverview(list: [HealthCategoryBlock]) -> some View {
	
		if list.isNotEmpty {
			listOverviewBlocks(list: list)
		} else {
			noItems()
		}
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverviewBlocks(list: [HealthCategoryBlock]) -> some View {
		
		var searchResults: [HealthCategoryBlock] {
			if viewModel.searchText.isEmpty {
				return list
			} else {
				return list.filter {
					($0.heading?.localizedCaseInsensitiveContains(viewModel.searchText.lowercased()) ?? false) ||
					$0.subHeading?.localizedCaseInsensitiveContains(viewModel.searchText.lowercased()) ?? false
				}
			}
		}
		
		Group {
			
			if searchResults.isEmpty {
				noSearchItems()
			} else {
				LazyVStack(spacing: ViewTraits.List.spacing, content: {
					
					ForEach(Array(searchResults.enumerated()), id: \.offset) { index, element in
						
						ZStack {
							Rectangle()
								.foregroundStyle(.clear)
								.accessibilityLabel(String(
									format: String(localized: "medication_overview.voiceover"),
									arguments: ["\(element.heading ?? "")", "\(element.subHeading ?? "")"]
								))
								.accessibilityAddTraits(.isButton)
							
							ActionCardView(
								title: LocalizedStringKey(stringLiteral: element.heading ?? ""),
								message: LocalizedStringKey(stringLiteral: element.subHeading ?? ""),
								perform: element.action
							)
							.cornerRadius(ViewTraits.List.cornerRadius)
						}
						.accessibilityIdentifier("block_\(index)")
						.onTapGesture {
							element.action?()
						}
					}
				})
				.padding(.top, ViewTraits.Navigation.padding)
			}
		}
		.searchable(text: $viewModel.searchText, prompt: viewModel.translations.search)
		.padding(.top, ViewTraits.List.top)
		.rijksoverheidStyle(font: .regular, style: .body)
		.foregroundColor(theme.contentTertiary)
	}
	
	/// The view for no search items
	/// - Returns: view
	@ViewBuilder func noSearchItems() -> some View {
		
		EmptyListView(
			icon: Image(ImageResource.Woman.womanWithPhoneInCircleExclamation),
			heading: viewModel.translations.noSearchResults,
			subHeading: "health_category.search_again"
		)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.top, ViewTraits.NoResults.top)
	}
	
	/// The view for no  items
	/// - Returns: view
	@ViewBuilder func noItems() -> some View {
		
		EmptyListView(
			icon: Image(ImageResource.Woman.womanWithPhone),
			heading: "health_category.empty.heading",
			subHeading: "health_category.empty.subheading"
		)
			.fixedSize(horizontal: false, vertical: true)
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
					heading: "health_category.medication",
					search: "health_category.medication.search",
					noSearchResults: "health_category.medication.no_search_results",
					detailsHeading: "health_category.medication.details_heading"
				)
			)
		)
	}
}
