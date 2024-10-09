/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
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
	
	var title: String
	var showAccount: Bool
	var showEmptyView: Bool
	var showRemoveHealthcareProvider: Bool
	var healthCategories: [CategoryButton]
	var backButtonTitle: LocalizedStringKey?
	
	mutating func updateCategoryState(id: Int, state: CategoryButtonState) {
		withAnimation {
			for index in 0..<healthCategories.count where healthCategories[index].id == id {
				if healthCategories[index].state != .notAvailabe {
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
	private var healtcareOrganizationStoreToken: Observatory.ObserverToken?
	
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
		
		let title: String = switch mode {
			case .single(let mgoOrganization):
				mgoOrganization.display_name
			case .all:
				String(localized: "health_categories.heading")
		}
		
		let backbuttonTitle: LocalizedStringKey? = switch mode {
			case .single: "healthcare_organizations.heading"
			case .all: nil
		}
		
		let showRemoveHealthcareProvider: Bool = switch mode {
			case .single: true
			case .all: false
		}

		let showAccount: Bool = switch mode {
			case .single: false
			case .all: true
		}
		
		self.state = HealthCategoriesViewState(
			title: title,
			showAccount: showAccount,
			showEmptyView: Current.healthcareOrganizationStore.organizations.isEmpty,
			showRemoveHealthcareProvider: showRemoveHealthcareProvider,
			healthCategories: [
				CategoryButton(id: HealthCategories.Category.medication.rawValue, title: "health_category.medication", state: .loading, box: 1),
				CategoryButton(id: HealthCategories.Category.measurements.rawValue, title: "health_category.measurements", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.labresults.rawValue, title: "health_category.labresults", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.allergies.rawValue, title: "health_category.allergies", state: .loading, box: 1),
				CategoryButton(id: HealthCategories.Category.treatments.rawValue, title: "health_category.treatments", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.appointments.rawValue, title: "health_category.appointments", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.vaccinations.rawValue, title: "health_category.vaccinations", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.documents.rawValue, title: "health_category.documents", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.complaints.rawValue, title: "health_category.complaints", state: .loading, box: 1),
				CategoryButton(id: HealthCategories.Category.patient.rawValue, title: "health_category.patient", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.alerts.rawValue, title: "health_category.alerts", state: .loading, box: 1),
				CategoryButton(id: HealthCategories.Category.payment.rawValue, title: "health_category.payment", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.plans.rawValue, title: "health_category.plans", state: .notAvailabe, box: 1),
				CategoryButton(id: HealthCategories.Category.devices.rawValue, title: "health_category.devices", state: .loading, box: 1),
				CategoryButton(id: HealthCategories.Category.functionalOrMentalStatus.rawValue, title: "health_category.mental", state: .loading, box: 1),
				CategoryButton(id: HealthCategories.Category.lifestyle.rawValue, title: "health_category.lifestyle", state: .loading, box: 1)
			],
			backButtonTitle: backbuttonTitle
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
		self.healtcareOrganizationStoreToken = Current.healthcareOrganizationStore.observatory.append { [weak self] _ in
			// Check if there are any healthcare organizations left.
			self?.state.showEmptyView = Current.healthcareOrganizationStore.organizations.isEmpty
		}
	}
	
	deinit {
		// Remove as observer
		dataStoreToken.map(Current.dataStore.observatory.remove)
		healtcareOrganizationStoreToken.map(Current.healthcareOrganizationStore.observatory.remove)
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
				
				guard categoryButton.state != .loading else {
					logError("Trying to select a category with invalid state", categoryButton)
					return
				}
				
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
			guard button.state != .notAvailabe else { continue }
			
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
		
		switch cacheResult {
			case let .success(records):
			
				// There better be a category for this button
				guard let category = HealthCategories.Category(rawValue: button.id) else {
					logError("HealthCategoriesViewModel, unknown category for", button)
					return
				}
			
				let expectedNumberOfResults: Int = {
					switch mode {
						case .single:
							// All the services for that category
							return category.services.count
						case .all:
							// All the services for that category * the number of organizations
							return category.services.count * Current.healthcareOrganizationStore.organizations.count
					}
				}()
				logVerbose("HealthCategoriesViewModel: expectedNumberOfResults = \(expectedNumberOfResults)")
			
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
			case let .failure(error):
				// No records available. Keep in loading state.
				guard case DataStoreError.noData = error else {
					logError("Error", error)
					state.updateCategoryState(id: button.id, state: .empty)
					return
				}
				state.updateCategoryState(id: button.id, state: .loading)
		}
	}
}

struct HealthCategoriesView: View {

	/// The View Model
	@StateObject var viewModel: HealthCategoriesViewModel
	
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
			static let spacing: CGFloat = 16
		}
		enum Account {
			static let size: CGFloat = 32
		}
		enum NoResults {
			static let top: CGFloat = 36
		}
	}
	
	var body: some View {
			
		VStack(alignment: .leading, spacing: 0) {
			
			headerView()
			
			if viewModel.state.showEmptyView {
				noHealthcareOrganizationView()
					.padding(.top, ViewTraits.Navigation.padding)
					.padding(.horizontal, ViewTraits.General.padding)
				Spacer()
			} else {
				
				List {
					
					ForEach(1..<4) { box in
						
						Section {
							
							let list = viewModel.state.healthCategories
								.filter { $0.box == box }
								.sorted(by: { $0.id < $1.id })
							
							ForEach(list, id: \.id) { block in
								
								VStack(spacing: 0) {
									HealthCategoryRowView(block: block)
										.when(block.state != .loading) { view in
											Button(action: {
												viewModel.reduce(.categorySelected(block))
											}, label: {
												view
											})
										}
								}
							}
						}
						.listRowInsets(ViewTraits.List.rowInset)
					}
					
					if viewModel.state.showRemoveHealthcareProvider {
						Section { /* Empty section */ }
					footer: {
						// Button in footer of an empty section so it is
						// at the bottom of the list, and without a rounded list background
						CallToActionButton(
							"health_categories.remove_organization",
							style: .tertiaryNegative) {
								viewModel.reduce(.removeHealthcareOrganization)
							}
							.accessibilityIdentifier("health_categories.remove_organization")
					}
					}
				} // List
				.listStyle(.insetGrouped)
				.backportListSectionSpacing(ViewTraits.List.spacing)
				
				Spacer()
			}

		} // VStack
		.navigationBarBackButtonHidden()
		.when(viewModel.state.backButtonTitle != nil, transform: { view in
			view
				.navigationBarItems(leading: BackButton(viewModel.state.backButtonTitle!) {
					viewModel.reduce(.backButtonPressed)
				})
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
		.refreshable {
			viewModel.reduce(.refresh)
		}.onAppear {
			viewModel.reduce(.onAppear)
		}
	}
	
	@ViewBuilder func headerView() -> some View {
	
		HStack {
			Text(viewModel.state.title)
				.rijksoverheidStyle(font: .bold, style: .title)
				.foregroundColor(theme.contentPrimary)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityAddTraits(.isHeader)
				.accessibilityIdentifier("healthcare_organizations.heading")
			
			Spacer()
			
			if viewModel.state.showAccount {
				Image(ImageResource.Overview.accountCircle)
					.resizable()
					.frame(width: ViewTraits.Account.size, height: ViewTraits.Account.size)
					.accessibilityHidden(true)
			}
		}
		.padding(.horizontal, ViewTraits.General.padding)
		.padding(.top, ViewTraits.Navigation.padding)
	}
	
	/// Create the empty state view
	/// - Returns: View when the user has no stored healthcare organizations
	@ViewBuilder func noHealthcareOrganizationView() -> some View {
		
		ImageContentView(
			icon: Image(ImageResource.Woman.womanWithPhone),
			heading: "overview.empty.heading",
			subHeading: "overview.empty.subheading"
		)
			.fixedSize(horizontal: false, vertical: true)
			.padding(.top, ViewTraits.NoResults.top)
		
		CallToActionButton("overview.empty.action") {
			viewModel.reduce(.search)
		}
		.accessibilityIdentifier("overview.empty.action")
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
