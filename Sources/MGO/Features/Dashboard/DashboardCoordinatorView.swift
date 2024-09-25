/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import Zibs

extension Coordination.Action {
	
	// Healthcare Organization flow
	static let showHealthcareOrganizationSearchResults = Coordination.Action(identifier: "showHealthcareOrganizationSearchResults")
	static let backToAddHealthcareOrganization = Coordination.Action(identifier: "backToAddHealthcareOrganization")
	static let listHealthcareOrganizations = Coordination.Action(identifier: "listHealthcareOrganizations")
	static let finishedSearchingHealthcareOrganizations = Coordination.Action(identifier: "finishedSearchingHealthcareOrganizations")
	
	static let addHealthcareOrganization = Coordination.Action(identifier: "addHealthcareOrganization") // Show Search Form
	static let showHealthcareOrganization = Coordination.Action(identifier: "showHealthcareOrganization")
	
	static let showHealthCategory = Coordination.Action(identifier: "showHealthCategory")
	static let showZibDetails = Coordination.Action(identifier: "showZibDetails")
	
	static let removeHealthcareOrganization = Coordination.Action(identifier: "removeHealthcareOrganization")
	static let removedHealthcareOrganization = Coordination.Action(identifier: "removedHealthcareOrganization")
}

protocol DashboardCoordinatorProtocol: Coordinator, ObservableObject {
	
	associatedtype Body: View
	
	/// The navigation path for the first tab
	var firstTabPath: NavigationStackBackport.NavigationPath { get set }

	/// The navigation path for the second tab
	var secondTabPath: NavigationStackBackport.NavigationPath { get set }
	
	/// The navigation path for the third tab
	var thirdTabPath: NavigationStackBackport.NavigationPath { get set }
	
	/// The content type for the sheet
	var pathForSheet: NavigationStackBackport.NavigationPath { get set }
	
	/// The state for the root view of the sheet
	var rootStateForSheet: DashboardCoordination.State? { get set }
	
	/// Get a View for the State
	/// - Parameter state: the DashboardCoordination State
	/// - Returns: A view for that state
	func viewState(for: DashboardCoordination.State?) -> Body
	
	/// The selected tab
	var selectedTab: Int { get set }
}

enum DashboardTab: Int {
	case healthCategories = 0
	case overview = 1
	case about = 2
}

enum DashboardCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable {
		
		case aboutTheApp
		case overview
		
		// Search & Store Healthcare Organization flow
		case addHealthcareOrganization
		case healthcareOrganizationSearchResults(city: String, name: String)
		case listHealthcareOrganizations
		
		// Details Flow
		case showHealthCategories
		case showHealthcareOrganization(healthcareOrganization: MgoOrganization)
		case showHealthCategory(category: HealthCategories.Category, organizationId: String?)
		case showZibDetails(heading: String, schema: UISchema)
		case removeHealthcareOrganization(healthcareOrganization: MgoOrganization)
	}
}

class DashboardCoordinator: DashboardCoordinatorProtocol {
	
	/// The navigation path for the first tab
	@Published var firstTabPath = NavigationStackBackport.NavigationPath()

	/// The navigation path for the second tab
	@Published var secondTabPath = NavigationStackBackport.NavigationPath()
	
	/// The navigation path for the third tab
	@Published var thirdTabPath = NavigationStackBackport.NavigationPath()

	/// The navigation path for the sheet.
	@Published var pathForSheet = NavigationStackBackport.NavigationPath()
	
	/// The root state for a sheet.
	@Published var rootStateForSheet: DashboardCoordination.State?
	
	/// The flow coordinator for routing
	private weak var parentCoordinator: (any AppCoordinatorProtocol)?
	
	/// The selected tab
	@Published var selectedTab: Int = DashboardTab.healthCategories.rawValue {
		didSet {
			if selectedTab == 0 {
				secondTabPath.reset()
				thirdTabPath.reset()
			} else if selectedTab == 1 {
				firstTabPath.reset()
				thirdTabPath.reset()
			} else if selectedTab == 2 {
				firstTabPath.reset()
				secondTabPath.reset()
			}
		}
	}
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(parentCoordinator: (any AppCoordinatorProtocol)?) {
		
		self.parentCoordinator = parentCoordinator
		
		// Load all the resources
		Current.resourceRepository.load()
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Coordination.Action) {
		
		switch action.identifier {
			
			// Healthcare Organization Search Flow
			
			case Coordination.Action.addHealthcareOrganization.identifier:
				rootStateForSheet = DashboardCoordination.State.addHealthcareOrganization
				
			case Coordination.Action.showHealthcareOrganizationSearchResults.identifier:
				if action.params.count == 2,
					let city = action.params["city"] as? String,
					let name = action.params["name"] as? String {
					pathForSheet.append(DashboardCoordination.State.healthcareOrganizationSearchResults(city: city, name: name))
				} else {
					logError("Dashboard Coordinator, missing params for \(action)")
				}
					
			case Coordination.Action.listHealthcareOrganizations.identifier:
				pathForSheet.append(DashboardCoordination.State.listHealthcareOrganizations)
			
			case Coordination.Action.backToAddHealthcareOrganization.identifier:
				pathForSheet.removeLast(pathForSheet.count)
			
			case Coordination.Action.finishedSearchingHealthcareOrganizations.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
			
			// Healthcare Organization Details
			
			case Coordination.Action.showHealthcareOrganization.identifier:
				if action.params.count == 1,
				   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization {
					
					setState(DashboardCoordination.State.showHealthcareOrganization(healthcareOrganization: healthcareOrganization))
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
			
			case Coordination.Action.showHealthCategory.identifier:
				if action.params.count == 2,
				   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization,
				   let category = action.params["category"] as? HealthCategories.Category {
					setState(DashboardCoordination.State.showHealthCategory(category: category, organizationId: healthcareOrganization.identifier))
				} else if action.params.count == 1,
					let category = action.params["category"] as? HealthCategories.Category {
					setState(DashboardCoordination.State.showHealthCategory(category: category, organizationId: nil))
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
			
			case Coordination.Action.showZibDetails.identifier:
				if action.params.count == 3,
//				   let resource = action.params["resource"] as? MgoResouce,
				   let heading = action.params["heading"] as? String,
				   let schema = action.params["uiSchema"] as? UISchema {
					setState(DashboardCoordination.State.showZibDetails(heading: heading, schema: schema))
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}

			case Coordination.Action.removeHealthcareOrganization.identifier:
				if action.params.count == 1,
				   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization {
				
					rootStateForSheet = DashboardCoordination.State.removeHealthcareOrganization(healthcareOrganization: healthcareOrganization)
					
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
			
			case Coordination.Action.removedHealthcareOrganization.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
				secondTabPath.removeLast()
			
			// General
			
			case Coordination.Action.closeSheet.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
					
			case Coordination.Action.backButtonPressed.identifier:
				if !pathForSheet.isEmpty {
					pathForSheet.removeLast()
				} else {
					if selectedTab == DashboardTab.healthCategories.rawValue {
						guard !firstTabPath.isEmpty else { return }
						firstTabPath.removeLast()
					} else if selectedTab == DashboardTab.overview.rawValue {
						guard !secondTabPath.isEmpty else { return }
						secondTabPath.removeLast()
					}
				}
					
			case Coordination.Action.resetApplication.identifier:
				parentCoordinator?.handle(Coordination.Action.resetApplication)
				
			default:
				// Unhandled
				logWarning("Dashboard Coordinator does not handle \(action)")
		}
	}
	
	/// Add the new state to the active tab
	/// - Parameter target: the new state
	private func setState(_ target: DashboardCoordination.State) {
		if selectedTab == DashboardTab.healthCategories.rawValue {
			firstTabPath.append(target)
		} else if selectedTab == DashboardTab.overview.rawValue {
			secondTabPath.append(target)
		} else if selectedTab == DashboardTab.about.rawValue {
			thirdTabPath.append(target)
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the DashboardCoordination State
	/// - Returns: A view for that state
	@ViewBuilder func viewState(for state: DashboardCoordination.State?) -> some View {
		
		switch state {
			
			// Initial states
			case .aboutTheApp:
				AboutTheAppView(viewModel: AboutTheAppViewModel(coordinator: self))
			
			case .overview:
				OrganizationsView(viewModel: OrganizationsViewModel(coordinator: self)).isPresentedAsSheet(false)
			
			// Healthcare Organization Flow
			case .addHealthcareOrganization:
				AddOrganizationView(viewModel: AddOrganizationViewModel(coordinator: self)).isPresentedAsSheet(true)
			
			case let .healthcareOrganizationSearchResults(city, name):
				let username = Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String
				let password = Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String
				let client: LocalisationServiceClientProtocol? = LocalisationServiceClient(
					serverUrl: Configuration().urlForLocalisation(),
					username: username,
					password: password
				)
				OrganizationSearchResultsView(viewModel: OrganizationSearchResultsViewModel(
					coordinator: self,
					city: city,
					name: name,
					localisationServiceClient: client)
				).isPresentedAsSheet(true)
			
			case .listHealthcareOrganizations:
				OrganizationListView(viewModel: OrganizationListViewModel(coordinator: self)).isPresentedAsSheet(true)
			
			case let .showHealthcareOrganization(healthcareOrganization):
				HealthCategoriesView(
					viewModel:
						HealthCategoriesViewModel(
							coordinator: self,
							mode: .single( healthcareOrganization)
						)
					)
			
			case .showHealthCategories:
			
				HealthCategoriesView(
					viewModel:
						HealthCategoriesViewModel(
							coordinator: self,
							mode: .all
						)
					)
			
			case let .removeHealthcareOrganization(healthcareOrganization):
				RemoveHealthcareOrganizationView(viewModel: RemoveHealthcareOrganizationViewModel(coordinator: self, healthcareOrganization: healthcareOrganization)).isPresentedAsSheet(true)
			
			case let .showZibDetails(heading: heading, schema: schema):
				ZibDetailsView(
					viewModel: ZibDetailsViewModel(
						coordinator: self,
						title: heading,
						schema: schema
					)
				)
			
			case let .showHealthCategory(category: category, organizationId: organizationId):
			
				switch category {
					case HealthCategories.Category.medication:
						HealthCategoryView(viewModel: MedicationHealthCategoryViewModel(coordinator: self, organizationId: organizationId))
					
					case HealthCategories.Category.allergies:
						HealthCategoryView(viewModel: AllergiesHealthCategoryViewModel(coordinator: self, organizationId: organizationId))
					
					case HealthCategories.Category.complaints:
						HealthCategoryView(viewModel: ComplaintsHealthCategoryViewModel(coordinator: self, organizationId: organizationId))
					
					case HealthCategories.Category.alerts:
						HealthCategoryView(viewModel: AlertsHealthCategoryViewModel(coordinator: self, organizationId: organizationId))
					
					case HealthCategories.Category.devices:
						HealthCategoryView(viewModel: DevicesHealthCategoryViewModel(coordinator: self, organizationId: organizationId))
					
					case HealthCategories.Category.functionalOrMentalStatus:
						HealthCategoryView(viewModel: MentalStatusHealthCategoryViewModel(coordinator: self, organizationId: organizationId))
					
					case HealthCategories.Category.lifestyle:
						HealthCategoryView(viewModel: LifestyleHealthCategoryViewModel(coordinator: self, organizationId: organizationId))
					
					default:
						Text(verbatim: "Todo, Overview for Category \(category)")
				}
			
			default:
				EmptyView()
				.logError("DashboardCoordinator, no view for", state as Any)
		}
	}
}

struct DashboardCoordinatorView<T: DashboardCoordinatorProtocol>: View {
	
	/// The coordinator for handling state
	@StateObject private var coordinator: T
	
	/// Initializer
	/// - Parameter appCoordinator: An DashboardCoordinatorProtocol class
	init(coordinator: T) {
		self._coordinator = StateObject(wrappedValue: coordinator)
	}
	
	// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
		
		TabView(selection: $coordinator.selectedTab) {
				
				Group {
					// First Tab, Overview
					NavigationStackBackport.NavigationStack(path: $coordinator.firstTabPath) {
						coordinator.viewState(for: .showHealthCategories)
							.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
								coordinator.viewState(for: state)
							}
							.navigationBarTitleDisplayMode(.inline)
					}
					.tabItem {
						Image(coordinator.selectedTab == DashboardTab.healthCategories.rawValue ? ImageResource.Tab.Selected.overview : ImageResource.Tab.Unselected.overview)
						Text("bottombar.overview")
							.rijksoverheidStyle(font: .bold, style: .body)
					}
					.tag(DashboardTab.healthCategories.rawValue)
					.accessibilityIdentifier("bottombar.overview")
					
					// Second Tab, Healthcare organizations
					NavigationStackBackport.NavigationStack(path: $coordinator.secondTabPath) {
						coordinator.viewState(for: .overview)
							.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
								coordinator.viewState(for: state)
							}
							.navigationBarTitleDisplayMode(.inline)
					}
					.tabItem {
						Image(coordinator.selectedTab == DashboardTab.overview.rawValue ? ImageResource.Tab.Selected.providers : ImageResource.Tab.Unselected.providers)
						Text("bottombar.healthcareproviders")
							.rijksoverheidStyle(font: .bold, style: .body)
					}
					.tag(DashboardTab.overview.rawValue)
					.accessibilityIdentifier("bottombar.healthcareproviders")
					
					// Third Tab, About
					NavigationStackBackport.NavigationStack(path: $coordinator.thirdTabPath) {
						coordinator.viewState(for: .aboutTheApp)
							.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
								coordinator.viewState(for: state)
							}
							.navigationBarTitleDisplayMode(.inline)
					}
					.tabItem {
						Image(coordinator.selectedTab == DashboardTab.about.rawValue ? ImageResource.Tab.Selected.about : ImageResource.Tab.Unselected.about)
						Text("bottombar.about_this_app")
							.rijksoverheidStyle(font: .bold, style: .body)
					}
					.tag(DashboardTab.about.rawValue)
					.accessibilityIdentifier("bottombar.about_this_app")
				}
			}
			.onAppear(perform: {
				// Brute force styling
				let tabBarAppearance = UITabBarAppearance()
				tabBarAppearance.shadowColor = UIColor(theme.strokesTertiary)
				tabBarAppearance.backgroundColor = UIColor(theme.backgroundSecondary)
				
				for appearance in [tabBarAppearance.stackedLayoutAppearance,
								   tabBarAppearance.inlineLayoutAppearance,
								   tabBarAppearance.compactInlineLayoutAppearance] {
					
					appearance.selected.iconColor = UIColor(theme.actionTertiaryDefaultText)
					appearance.selected.titleTextAttributes =
					[
						.foregroundColor: UIColor(theme.actionTertiaryDefaultText),
						.paragraphStyle: NSParagraphStyle.default
					]
					appearance.normal.titleTextAttributes = [
						.foregroundColor: UIColor(theme.iconsPrimary),
						.paragraphStyle: NSParagraphStyle.default
					]
					appearance.normal.iconColor = UIColor(theme.iconsPrimary)
				}
				
				// Apply
				UITabBar.appearance().standardAppearance = tabBarAppearance
				UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

			})
			.navigationBarHidden(true)
			.navigationBarBackButtonHidden()
			.inspectableSheet(
				isPresented: $coordinator.rootStateForSheet.presence(),
				onDismiss: {
					// Called when the sheet is closed by dragging.
					coordinator.handle(Coordination.Action.closeSheet)
				},
				content: {
					NavigationStackBackport.NavigationStack(path: $coordinator.pathForSheet) {
						coordinator.viewState(for: coordinator.rootStateForSheet)
							.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
								coordinator.viewState(for: state)
							}
							.navigationBarBackButtonHidden(true)
							.navigationBarTitleDisplayMode(.inline)
					}
				}
			)
	}
}

#Preview {
	DashboardCoordinatorView(coordinator: DashboardCoordinator(parentCoordinator: nil))
}
