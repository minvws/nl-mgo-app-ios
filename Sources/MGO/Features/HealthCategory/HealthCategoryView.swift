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
	let heading: String
	
	/// The subtitle of a block
	let subHeading: String?
	
	/// The underlying schema
	let schema: HealthUISchema
	
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
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The organization to show the categories for (optional, if nil, then show all organizations)
	private var organization: MgoOrganization?
	
	/// The category to show
	@Published var category: SharedHealthCategories.Category
	
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
				
				coordinator?.handle(
					Coordination.Action(
						identifier: Coordination.Action.exportHealthData.identifier,
						params: [
							"healthData": HealthDataMapper().map(category, data: blocks)
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
			if let uiSchema = parser.getSummary(resource, organizationName: orginizationName) {
				// Add a HealthCategoryBlock to the display list
				items.append(
					HealthCategoryRow(
						heading: Sanitizer.sanitize(uiSchema.label),
						subHeading: orginizationName,
						schema: uiSchema
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
		
		return getOrganization(identifier)?.display_name
	}
	
	/// Get the name of a healthcare organisation
	/// - Parameter identifier: the identifier of the organization
	/// - Returns: optional name
	func getOrganization(_ identifier: String) -> MgoOrganization? {
		
		return healthcareOrganizationRepository.organizations
			.first { $0.identifier == identifier }
	}
}

struct HealthCategoryView: View {
	
	/// The View Model
	@StateObject var viewModel: HealthCategoryViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum List {
			static let inset: EdgeInsets = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let headerInset: EdgeInsets = EdgeInsets(top: 24, leading: 16, bottom: 2, trailing: 16)
		}
		enum FullScreen {
			static let textSpacing: CGFloat = 8
			static let iconSize: CGFloat = 50
		}
	}
	
	var body: some View {
		
		Group {
			
			switch viewModel.state {
				case .loading:
					fullScreenLoadingScreen()
					
				case let .list(items, errorState):
					if items.flatMap({ $0.rows }).isEmpty {
						fullScreenEmptyScreen(errorState)
					} else {
						listOverview(
							list: items,
							errorState: errorState
						)
					}
			}
		}
		.backport.scrollContentBackground(.hidden)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("overview.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationTitle(String(localized: viewModel.translations.heading))
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
	
	/// The full screen loading state
	/// - Returns: the full screen loading state
	@ViewBuilder private func fullScreenLoadingScreen() -> some View {
		
		VStack {
			Spacer()
			ErrorStateCardView(state: .loading)
			Spacer()
		}
	}
	
	/// The full screen empty screens
	/// - Parameter errorState: the error state
	/// - Returns: the full screen empty screen for the error state
	@ViewBuilder private func fullScreenEmptyScreen(
		_ errorState: HealthCategoriesErrorState
	) -> some View {
		
		switch errorState {
			case .none:
				fullScreenPage(
					image: viewModel.category.getEmptyIcon(),
					heading: String(localized: "health_category.empty.heading"),
					subHeading: String(localized: "health_category.empty.subheading"),
					actionTitle: "health_category.empty.action"
				) {
					viewModel.reduce(.backButtonPressed)
				}
				
			case .loading:
				// Should not happen
				fullScreenLoadingScreen()
				
			case .error(let heading, let subHeading):
				
				fullScreenPage(
					image: Image(ImageResource.Icon.syncProblem),
					heading: heading,
					subHeading: subHeading,
					actionTitle: "common.try_again"
				) {
					viewModel.reduce(.retry)
				}
		}
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverview(
		list: [HealthCategoryBlock],
		errorState: HealthCategoriesErrorState
	) -> some View {
		
		List {
			
			switch errorState {
				case .none:
					EmptyView()
				case .loading:
					Section {
						ErrorStateCardView(state: .loading)
					}
				case .error(let heading, let subHeading):
					Section {
						ErrorStateCardView(state: .error(heading: heading, subHeading: subHeading)) {
							viewModel.reduce(.retry)
						}
					}
			}
			
			listOverviewBlocks(list: list)
				.backport.listSectionSpacing(8)
				.backport.contentMargins(0)
				.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		}
		.toolbar(content: pdfExportToolbarContent)
		.alert(
			String(localized: "export_pdf.dialog.heading"),
			isPresented: $viewModel.showExportAlert
		) {
			Button("export_pdf.dialog.create_document") { viewModel.reduce(.exportHealthData) }
				.keyboardShortcut(.defaultAction)
			Button("common.cancel") { viewModel.reduce(.cancelExportAlert) }
				.keyboardShortcut(.cancelAction)
		} message: {
			Text("export_pdf.dialog.subheading")
		}
	}
	
	/// Create the list state view
	/// - Returns: View when the user has some stored healthcare organizations
	@ViewBuilder func listOverviewBlocks(list: [HealthCategoryBlock]) -> some View {
		
		ForEach(Array(list.enumerated()), id: \.offset) { subCategoryIndex, subCategory in
			
			if subCategory.rows.isNotEmpty {
				blockView(
					showHeading: Container.shared.featureFlagManager().isDemo ? true : list.filter { $0.rows.isNotEmpty }.count != 1,
					subCategory: subCategory,
					subCategoryIndex: subCategoryIndex
				)
			}
		}
	}
	
	/// Block view for a subcategory
	/// - Parameters:
	///   - list: the list of categories
	///   - subCategory: a sub category
	///   - subCategoryIndex: the index of the subcategory
	/// - Returns: view
	@ViewBuilder private func blockView(
		showHeading: Bool,
		subCategory: HealthCategoryBlock,
		subCategoryIndex: Int
	) -> some View {
		
		if showHeading {
			
			Section {
				Text(subCategory.heading)
					.typography(.headingMedium)
					.foregroundColor(theme.labels.primary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
			}
			.listRowBackground(Color.clear)
			.listRowInsets(ViewTraits.List.headerInset)
		}
		
		ForEach(Array(subCategory.rows.enumerated()), id: \.offset) { index, element in
			Section {
				ActionCardView(
					title: LocalizedStringKey(stringLiteral: element.heading),
					message: LocalizedStringKey(stringLiteral: element.subHeading ?? ""),
					perform: element.action
				)
				.listRowInsets(ViewTraits.List.inset)
				.accessibilityIdentifier("category_element_\(subCategoryIndex)_\(index)")
			}
		}
	}
	
	/// Get the toolbar content (export to pdf)
	/// - Returns: the toolbar content
	@ToolbarContentBuilder private func pdfExportToolbarContent() -> some ToolbarContent {
		ToolbarItemGroup(
			placement: .topBarTrailing,
			content: {
				
				Menu {
					menuExportPDFOption()
				} label: {
					if osVersionChecker.available(version: .iOS(.v26)) {
						Image(ImageResource.Icon.more26)
							.foregroundStyle(theme.labels.primary)
					} else {
						Image(ImageResource.Icon.more)
					}
				}
				.buttonStyle(ToolbarButtonStyle())
				.accessibilityLabel("export_pdf.menu")
			}
		)
	}
	
	/// The export pdf option
	/// - Returns: view
	@ViewBuilder func menuExportPDFOption() -> some View {
		
		Button {
			viewModel.reduce(.showExportAlert)
		} label: {
			Label("export_pdf.menu.save_pdf", systemImage: "arrow.down.document")
				.tint(theme.labels.primary)
		}
	}

	/// Full Screen page
	/// - Parameters:
	///   - image: the image to display
	///   - heading: the heading of the page
	///   - subHeading: the sub heading of the page
	///   - actionTitle: the title of the action
	///   - action: the action
	/// - Returns: Full Screen page
	@ViewBuilder private func fullScreenPage(
		image: Image,
		heading: String,
		subHeading: String,
		actionTitle: LocalizedStringKey,
		action: (() -> Void)?
	) -> some View {
		
		VStack(alignment: .center, spacing: ViewTraits.FullScreen.textSpacing, content: {
			Spacer()
			
			HStack {
				Spacer()
				image
					.resizable()
					.frame(
						width: ViewTraits.FullScreen.iconSize,
						height: ViewTraits.FullScreen.iconSize,
						alignment: .center
					)
					.foregroundStyle(theme.symbols.primary)
				Spacer()
			}
			.padding(.bottom, ViewTraits.General.padding)
			
			Text(heading)
				.typography(.headingSmall)
				.foregroundStyle(theme.labels.primary)
				.accessibilityAddTraits(.isHeader)
			
			Text(subHeading)
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.secondary)
				.multilineTextAlignment(.center)
			
			Spacer()
			
			CallToActionButton(
				actionTitle,
				style: .solid(
					rounded: osVersionChecker.available(version: .iOS(.v26)),
					narrow: false
				)
			) {
				action?()
			}
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.bottom, ViewTraits.General.padding)
		})
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		HealthCategoryView(
			viewModel: HealthCategoryViewModel(
				coordinator: nil,
				category: PreviewContent.category,
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
