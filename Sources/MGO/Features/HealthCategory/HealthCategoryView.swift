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

struct HealthCategoryBlock: Equatable, Identifiable {
	
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

enum HealthCategoryViewState: Equatable {
	
	case loading
	case failure
	case empty
	case success(items: [HealthCategoryBlock])

	static func == (lhs: HealthCategoryViewState, rhs: HealthCategoryViewState) -> Bool {
		switch (lhs, rhs) {
			
			case (.loading, .loading):
				return true
				
			case (.failure, .failure):
				return true
				
			case (.empty, .empty):
				return true
			
			case let(.success(lhsList), .success(rhsList)):
			
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

class AllergiesHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organizationId: String?) {
		super.init(
			coordinator: coordinator,
			categoryId: "\(HealthCategories.Category.allergies.rawValue)",
			organizationId: organizationId,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.allergies",
				search: "health_category.allergies.search",
				noSearchResults: "health_category.allergies.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.allergies.details_heading")
			)
		)
	}
}

class ComplaintsHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organizationId: String?) {
		super.init(
			coordinator: coordinator,
			categoryId: "\(HealthCategories.Category.complaints.rawValue)",
			organizationId: organizationId,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.complaints",
				search: "health_category.complaints.search",
				noSearchResults: "health_category.complaints.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.complaints.details_heading")
			)
		)
	}
}

class MedicationHealthCategoryViewModel: HealthCategoryViewModel {
	
	init(coordinator: (any Coordinator)? = nil, organizationId: String?) {
		super.init(
			coordinator: coordinator,
			categoryId: "\(HealthCategories.Category.medication.rawValue)",
			organizationId: organizationId,
			translations: HealthCategoryViewTranslations(
				heading: "health_category.medication",
				search: "health_category.medication.search",
				noSearchResults: "health_category.medication.no_search_results",
				detailsHeading: String.LocalizationValue(stringLiteral: "health_category.medication.details_heading")
			)
		)
	}
}

class HealthCategoryViewModel: ObservableObject {
	
	/// The state of the view
	@Published var state: HealthCategoryViewState
	
	/// All the translated copy
	@Published var translations: HealthCategoryViewTranslations
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The organization to show the categories for (optional, if nil, then show all organizations)
	private var organizationId: String?
	
	/// The category to show
	private var categoryId: String
	
	/// The text to filter the results on. 
	@Published var searchText = ""
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case onAppear
	}
	
	/// Create a MedicationOverview VM
	/// - Parameter coordinator: the app coordinator
	init(
		coordinator: (any Coordinator)? = nil,
		categoryId: String,
		organizationId: String?,
		translations: HealthCategoryViewTranslations
	) {
		self.coordinator = coordinator
		self.categoryId = categoryId
		self.organizationId = organizationId
		self.state = .loading
		self.translations = translations
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
		}
	}
	
	@MainActor
	func loadResources() async {
		
		let cacheResult: Result<[MgoResourceRecord], Error> = {
			if let organizationId {
				return Current.dataStore.get(categoryId: categoryId, organizationId: organizationId)
			} else {
				return Current.dataStore.get(categoryId: categoryId)
			}
		}()
		switch cacheResult {
			case .success(let records):
				var items = [HealthCategoryBlock]()
				for record in records {
					items.append(contentsOf: parseRecord(record))
				}
				if items.isEmpty {
					state = .empty
				} else {
					state = .success(items: items)
				}
			case .failure:
				state = .failure
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
		
		return 	Current.healthcareOrganizationStore.organizations.first { $0.identifier == identifier }?.display_name
	}
}

struct HealthCategoryView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthCategoryViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
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
					
				case .empty:
					
					NotificationCardView(
						icon: Image(ImageResource.Woman.womanOnCouch),
						title: "common.no_results_heading",
						message: "common.no_results_subheading"
					)
					
				case .failure:
					
					NotificationCardView(
						icon: Image(ImageResource.Woman.womanOnCouchExclamation),
						title: "common.failure_heading",
						message: "common.failure_subheading"
					)
					
				case let .success(items):
					
					listOverviewBlocks(list: items)
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
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthCategoryView(
			viewModel: HealthCategoryViewModel(
				coordinator: nil,
				categoryId: "1",
				organizationId: "1",
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
