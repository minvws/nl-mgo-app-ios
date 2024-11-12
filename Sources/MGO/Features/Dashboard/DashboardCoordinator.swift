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
	static let showHealthCategoryData = Coordination.Action(identifier: "showHealthCategoryData")
	
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
		case showHealthCategory(category: HealthCategories.Category, organization: MgoOrganization?)
		case showHealthCategoryData(heading: String, schema: UISchema)
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
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Coordination.Action) {
		
		guard !handleSearchFlow(action) else { return }
		guard !handleHealthDataFlow(action) else { return }
		
		switch action.identifier {
			
			// General
				
			case Coordination.Action.closeSheet.identifier, Coordination.Action.finishedSearchingHealthcareOrganizations.identifier:
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
				selectedTab = DashboardTab.healthCategories.rawValue
			
			default:
				// Unhandled
				logWarning("Dashboard Coordinator does not handle \(action)")
		}
	}
	
	/// Handle the search flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	private func handleSearchFlow(_ action: Coordination.Action) -> Bool {
		
		switch action.identifier {
			
				// Healthcare Organization Search Flow
				
			case Coordination.Action.addHealthcareOrganization.identifier:
				rootStateForSheet = DashboardCoordination.State.addHealthcareOrganization
				return true
				
			case Coordination.Action.showHealthcareOrganizationSearchResults.identifier:
				if action.params.count == 2,
				   let city = action.params["city"] as? String,
				   let name = action.params["name"] as? String {
					pathForSheet.append(DashboardCoordination.State.healthcareOrganizationSearchResults(city: city, name: name))
				} else {
					logError("Dashboard Coordinator, missing params for \(action)")
					}
				return true
				
			case Coordination.Action.listHealthcareOrganizations.identifier:
				pathForSheet.append(DashboardCoordination.State.listHealthcareOrganizations)
				return true
				
			case Coordination.Action.backToAddHealthcareOrganization.identifier:
				pathForSheet.removeLast(pathForSheet.count)
				return true
				
			default:
				return false
		}
	}
	
	/// Handle the detail flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	func handleHealthDataFlow(_ action: Coordination.Action) -> Bool {
		
		switch action.identifier {
			
			case Coordination.Action.showHealthcareOrganization.identifier:
				if action.params.count == 1,
				   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization {
					
					setState(DashboardCoordination.State.showHealthcareOrganization(healthcareOrganization: healthcareOrganization))
					return true
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
				
			case Coordination.Action.showHealthCategory.identifier:
				if action.params.count == 2,
				   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization,
				   let category = action.params["category"] as? HealthCategories.Category {
					setState(DashboardCoordination.State.showHealthCategory(category: category, organization: healthcareOrganization))
					return true
				} else if action.params.count == 1,
						  let category = action.params["category"] as? HealthCategories.Category {
					setState(DashboardCoordination.State.showHealthCategory(category: category, organization: nil))
					return true
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
				
			case Coordination.Action.showHealthCategoryData.identifier:
				if action.params.count == 3,
				   //				   let resource = action.params["resource"] as? MgoResouce,
				   let heading = action.params["heading"] as? String,
				   let schema = action.params["uiSchema"] as? UISchema {
					setState(DashboardCoordination.State.showHealthCategoryData(heading: heading, schema: schema))
					return true
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
				
			case Coordination.Action.removeHealthcareOrganization.identifier:
				if action.params.count == 1,
				   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization {
					
					rootStateForSheet = DashboardCoordination.State.removeHealthcareOrganization(healthcareOrganization: healthcareOrganization)
					return true
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
				
			case Coordination.Action.removedHealthcareOrganization.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
				secondTabPath.removeLast()
				return true
				
			default:
				return false
		}
		return false
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
				
			case let .showHealthCategoryData(heading: heading, schema: schema):
				HealthCategoryDataView(
					viewModel: HealthCategoryDataViewModel(
						coordinator: self,
						title: heading,
						schema: schema
					)
				)
				
			case let .showHealthCategory(category: category, organization: organization):
				
				viewState(for: category, organization: organization)
				
			default:
				EmptyView()
					.logError("DashboardCoordinator, no view for", state as Any)
		}
	}
	
	@ViewBuilder private func viewState(for category: HealthCategories.Category, organization: MgoOrganization? = nil) -> some View {

		switch category {
			case HealthCategories.Category.medication:
				HealthCategoryView(viewModel: MedicationHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.measurements:
				HealthCategoryView(viewModel: MeasurementsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.labresults:
				HealthCategoryView(viewModel: LabResultsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.allergies:
				HealthCategoryView(viewModel: AllergiesHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.treatments:
				HealthCategoryView(viewModel: TreatmentsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.appointments:
				HealthCategoryView(viewModel: AppointmentsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.vaccinations:
				HealthCategoryView(viewModel: VaccinationsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.documents:
				HealthCategoryView(viewModel: DocumentsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.complaints:
				HealthCategoryView(viewModel: ComplaintsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.patient:
				HealthCategoryView(viewModel: PatientHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.alerts:
				HealthCategoryView(viewModel: AlertsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.payment:
				HealthCategoryView(viewModel: PaymentHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.plans:
				HealthCategoryView(viewModel: PlansHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.devices:
				HealthCategoryView(viewModel: DevicesHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.functionalOrMentalStatus:
				HealthCategoryView(viewModel: MentalStatusHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.lifestyle:
				HealthCategoryView(viewModel: LifestyleHealthCategoryViewModel(coordinator: self, organization: organization))
		}
	}
}
