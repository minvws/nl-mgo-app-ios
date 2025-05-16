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
	var healthCategories: [CategoryButton]
	var backButtonTitle: LocalizedStringKey?
	var belowIOS18: Bool
	
	mutating func updateCategoryState(id: Int, state: CategoryButtonState) {
		withAnimation {
			for index in 0..<healthCategories.count where healthCategories[index].id == id {
				if healthCategories[index].state != .notAvailable {
					healthCategories[index].state = state
				}
			}
		}
	}
}

class HealthCategoriesViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The mode we are in (single, multiple)
	private var mode: HealthCategoriesViewMode
	
	/// The state of the view
	@Published var state: HealthCategoriesViewState
	
	/// Token for the data store observatory
	private var dataStoreToken: Observatory.ObserverToken?
	
	/// Token for the healthcare organization observatory
	private var healthcareOrganizationStoreToken: Observatory.ObserverToken?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case refresh
		case categorySelected(CategoryButton)
		case removeHealthcareOrganization
		case onAppear
		case search
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil, mode: HealthCategoriesViewMode) {
		
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
		
		// The categories could be divided into several boxes, currently 1 box for enabled categories. 
		// Disabled box 1 means same box as the enabled categories
		let disabledForDemoBox: Int = Current.featureFlagManager.isDemo ? 2 : 1
		
		self.state = HealthCategoriesViewState(
			heading: heading,
			subheading: subheading,
			canTitleCollapse: canTitleCollapse,
			showEmptyView: Current.healthcareOrganizationStore.organizations.isEmpty,
			showRemoveHealthcareProvider: showRemoveHealthcareProvider,
			healthCategories: [
				CategoryButton(category: .medication, title: "hc_medication.heading", box: 1),
				CategoryButton(category: .measurements, title: "hc_measurements.heading", box: disabledForDemoBox),
				CategoryButton(category: .labResults, title: "hc_lab_results.heading", box: 1),
				CategoryButton(category: .allergies, title: "hc_allergies.heading", box: disabledForDemoBox),
				CategoryButton(category: .treatments, title: "hc_treatments.heading", box: disabledForDemoBox),
				CategoryButton(category: .appointments, title: "hc_appointments.heading", box: disabledForDemoBox),
				CategoryButton(category: .vaccinations, title: "hc_vaccinations.heading", box: 1),
				CategoryButton(category: .documents, title: "hc_documents.heading", box: 1),
				CategoryButton(category: .medicalComplaints, title: "hc_complaints.heading", box: disabledForDemoBox),
				CategoryButton(category: .personalDetails, title: "hc_patient.heading", box: disabledForDemoBox),
				CategoryButton(category: .alerts, title: "hc_alerts.heading", box: disabledForDemoBox),
				CategoryButton(category: .payment, title: "hc_payment.heading", box: disabledForDemoBox),
				CategoryButton(category: .plans, title: "hc_plans.heading", box: disabledForDemoBox),
				CategoryButton(category: .medicalDevices, title: "hc_devices.heading", box: disabledForDemoBox),
				CategoryButton(category: .mentalWellbeing, title: "hc_mental.heading", box: disabledForDemoBox),
				CategoryButton(category: .lifestyle, title: "hc_lifestyle.heading", box: disabledForDemoBox)
			],
			backButtonTitle: backbuttonTitle,
			belowIOS18: belowIOS18
		)
		
		registerObservers()
	}
	
	private func registerObservers() {
		self.dataStoreToken = Current.dataStore.observatory.append { [weak self] changed in
			if changed {
				// Handle updates in the fetched data
				self?.updateState()
			}
		}
		self.healthcareOrganizationStoreToken = Current.healthcareOrganizationStore.observatory.append { [weak self] _ in
			// Check if there are any healthcare organizations left.
			self?.state.showEmptyView = Current.healthcareOrganizationStore.organizations.isEmpty
		}
	}
	
	deinit {
		// Remove as observer
		dataStoreToken.map(Current.dataStore.observatory.remove)
		healthcareOrganizationStoreToken.map(Current.healthcareOrganizationStore.observatory.remove)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: HealthCategoriesViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
				
			case .search:
				coordinator?.handle(Coordination.Action.addHealthcareOrganization)
				
			case .refresh:
				if case let .single(healthcareOrganization) = mode {
					Current.dataStore.removeRecords(for: healthcareOrganization.identifier)
					Current.resourceRepository.loadFor(healthcareOrganization)
				} else {
					Current.dataStore.removeAllRecords()
					Current.resourceRepository.load()
				}
				reduce(.onAppear)
			
			case let .categorySelected(categoryButton):
				
				if let category = HealthCategories.Category(rawValue: categoryButton.id) {
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
				} else {
					logError("Can't create a category for", categoryButton)
				}
				
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
		}
	}
	
	/// The store has changed, update the
	private func updateState() {
		
		for button in state.healthCategories {
			// Only update if the category is enabled.
			guard button.state != .notAvailable else { continue }
			
			let cacheResult: Result<[MgoResourceRecord], Error> = {
				switch mode {
					case .single(let healthcareOrganization):
						return Current.dataStore.get(categoryId: "\(button.id)", organizationId: healthcareOrganization.identifier)
					case .all:
						return Current.dataStore.get(categoryId: "\(button.id)")
				}
			}()
			
			handleCacheResult(cacheResult, button: button)
		}
	}

	/// Update the state
	/// - Parameter button: the button to update
	private func handleCacheResult(_ cacheResult: Result<[MgoResourceRecord], Error>, button: CategoryButton) {
		
		// There better be a category for this button
		guard let category = HealthCategories.Category(rawValue: button.id) else {
			logError("HealthCategoriesViewModel, unknown category for", button)
			return
		}
	
		let expectedNumberOfResults: Int = {
			switch mode {
				case .single(let organization):
					// All the services for that category
					return organization.servicesForCategory(category)
				case .all:
					// All the services for that category * the number of organizations
					var result = 0
					for organization in Current.healthcareOrganizationStore.organizations {
						result += organization.servicesForCategory(category)
					}
					return result
			}
		}()
		logVerbose("HealthCategoriesViewModel: expectedNumberOfResults = \(expectedNumberOfResults) for \(category)")
		
		guard expectedNumberOfResults > 0 else {
			state.updateCategoryState(id: button.id, state: .empty)
			return
		}
		
		switch cacheResult {
			case let .success(records):
				handleCacheHit(button, records: records, expectedNumberOfResults: expectedNumberOfResults)
			case let .failure(error):
				handleCacheMiss(button, error: error)
		}
	}
	
	/// Handle the success path of the cache
	/// - Parameters:
	///   - button: the category button
	///   - records: the records for the category
	///   - expectedNumberOfResults: the expected number of results
	private func handleCacheHit(_ button: CategoryButton, records: [MgoResourceRecord], expectedNumberOfResults: Int) {
		
		// Success, there was some records for this category
		if records.count >= expectedNumberOfResults {
			// There are records for all organizations. Let's check if any of them has data
			var found = false
			for record in records where record.resources.isNotEmpty {
				found = true
			}
			state.updateCategoryState(id: button.id, state: found ? .loaded : .empty)
		} else {
			// We don't have data for all organizations. Keep loading
			state.updateCategoryState(id: button.id, state: .loading)
		}
	}
	
	/// handle the failure path of the cache
	/// - Parameters:
	///   - button: the category button
	///   - error: the error
	private func handleCacheMiss(_ button: CategoryButton, error: Error) {
		
		// No records available. Keep in loading state.
		guard case DataStoreError.noData = error else {
			logError("Error", error)
			state.updateCategoryState(id: button.id, state: .empty)
			return
		}
		state.updateCategoryState(id: button.id, state: .loading)
	}
}

/// The view for an overview of all the health categories
struct HealthCategoriesView: View {

	/// The View Model
	@StateObject var viewModel: HealthCategoriesViewModel
	
	/// Are we scrolling
	@State private var isScrolling: Bool = false
	
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
			static let rowInset = EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
			static let spacing: CGFloat = Current.featureFlagManager.isDemo ? 16 : 4
			static let bottom: CGFloat = 16
		}
		enum NoResults {
			static let top: CGFloat = 44
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
					.backportListSectionSpacing(ViewTraits.List.spacing)
					.backportContentMargins(0)
					.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
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
		.navigationBarHidden(false)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
		.refreshable {
			viewModel.reduce(.refresh)
		}
		.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
	
	/// The view for the header
	/// - Returns: header view
	@ViewBuilder func heading() -> some View {
		
		Text(viewModel.state.heading)
			.rijksoverheidStyle(font: .bold, style: .title)
			.foregroundColor(theme.contentPrimary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityAddTraits(.isHeader)
			.accessibilityIdentifier("healthcare_organizations.heading")
			.padding(.top, ViewTraits.Navigation.padding)
	}
	
	/// The view for the sub heading
	/// - Returns: sub heading view
	@ViewBuilder func subHeading() -> some View {
		
		Text(viewModel.state.subheading)
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundColor(theme.contentPrimary)
			.frame(maxWidth: .infinity, alignment: .topLeading)
			.accessibilityIdentifier("overview.subheading")
	}
	
	/// The view for the categories
	/// - Returns: category view
	@ViewBuilder func categoriesView() -> some View {
		
		List {
			listHeader()

			ForEach(1..<4) { box in
				
				sectionView(box)
			}
			
			Section { /* Empty section */ }
			footer: {
				listFooter()
			}
		} // List
		.backportScrollContentBackground(.hidden)
		.listStyle(.insetGrouped)
	}
	
	/// View for a section
	/// - Parameter box: the number of the section
	/// - Returns: section view
	@ViewBuilder private func sectionView(_ box: Int) -> some View {
		
		Section {
		
			let list = viewModel.state.healthCategories
				.filter { $0.box == box }
				.sorted(by: { $0.id < $1.id })
			
			ForEach(list, id: \.id) { block in
				
				categoryView(block)
			}
		}
		.listRowInsets(ViewTraits.List.rowInset)
	}
	
	/// View for a category
	/// - Parameter category: the category
	/// - Returns: category view
	@ViewBuilder private func categoryView(_ category: CategoryButton) -> some View {
		
		VStack(spacing: 0) {
			Button {
				viewModel.reduce(.categorySelected(category))
			} label: {
				HealthCategoryRowView(block: category)
			}
			.frame( maxWidth: .infinity, alignment: .leading)
			.buttonStyle(HoverButtonStyle())
			.accessibilityIdentifier(category.title.stringKey)
		}
	}

	/// The list header
	/// - Returns: list header
	@ViewBuilder private func listHeader() -> some View {
		
		Section {
			VStack(spacing: ViewTraits.General.padding) {
				if !viewModel.state.canTitleCollapse {
					heading()
				}
				subHeading()
					.padding(.bottom, viewModel.state.canTitleCollapse ? 0 : ViewTraits.General.padding / 2)
			}
		}
		.listRowBackground(Color.clear)
		.listRowInsets(ViewTraits.List.rowInset)
	}
	
	/// The footer
	/// - Returns: the footer
	@ViewBuilder private func listFooter() -> some View {
		
		if viewModel.state.showRemoveHealthcareProvider {
			// Button in footer of an empty section so it is
			// at the bottom of the list, and without a rounded list background
			CallToActionButton(
				"organizations.remove_organization",
				style: .tertiaryCritical) {
					viewModel.reduce(.removeHealthcareOrganization)
				}
				.accessibilityIdentifier("organizations.remove_organization")
		} else {
			Spacer(minLength: ViewTraits.List.bottom)
		}
	}
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare organizations
	@ViewBuilder private func noHealthcareOrganizationView() -> some View {
		
		ScrollViewWithFixedBottom {
			
			ImageContentView(
				icon: Image(ImageResource.Woman.womanWithPhone),
				heading: "common.no_organizations_heading",
				subHeading: "common.no_organizations_subheading",
				subHeadingForegroundColor: theme.contentPrimary
			)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.top, ViewTraits.NoResults.top)
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			
			CallToActionButton(Current.featureFlagManager.isAutomaticLocalizationEnabled ? "common.search_organizations" : "common.add_organizations") {
				viewModel.reduce(.search)
			}
			.accessibilityIdentifier("common.add_organizations")
			.padding(ViewTraits.Button.insets)
		}
	}
}

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
