/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import PdfExport

extension Coordination.Action {
	
	// Healthcare Organization flow
	static let showHealthcareOrganizationSearchResults = Coordination.Action(identifier: "showHealthcareOrganizationSearchResults")
	static let backToAddHealthcareOrganization = Coordination.Action(identifier: "backToAddHealthcareOrganization")
	static let finishedSearchingHealthcareOrganizations = Coordination.Action(identifier: "finishedSearchingHealthcareOrganizations")
	
	static let addHealthcareOrganization = Coordination.Action(identifier: "addHealthcareOrganization") // Show Search Form
	static let showHealthcareOrganization = Coordination.Action(identifier: "showHealthcareOrganization")
	
	static let showHealthCategory = Coordination.Action(identifier: "showHealthCategory")
	static let showHealthData = Coordination.Action(identifier: "showHealthData")
	
	static let removeHealthcareOrganization = Coordination.Action(identifier: "removeHealthcareOrganization")
	static let removedHealthcareOrganization = Coordination.Action(identifier: "removedHealthcareOrganization")
	
	static let exportHealthData = Coordination.Action(identifier: "exportHealthData")
}

protocol HealthcareCoordinatorProtocol: Coordinator, ObservableObject {
	
	associatedtype Body: View
	
	/// The navigation path
	var path: NavigationStackBackport.NavigationPath { get set }
	
	/// The content type for the sheet
	var pathForSheet: NavigationStackBackport.NavigationPath { get set }
	
	/// The state for the root view
	var rootState: HealthcareCoordination.State? { get set }
	
	/// The state for the root view of the sheet
	var rootStateForSheet: HealthcareCoordination.State? { get set }
	
	/// Get a View for the State
	/// - Parameter state: the HealthcareCoordination State
	/// - Returns: A view for that state
	func viewState(for: HealthcareCoordination.State?) -> Body
}

struct HealthcareCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable {
		
		// Organizations
		case organizations
		
		// Search & Store Healthcare Organization flow
		case automaticLocalization
		case manualLocalization
		case healthcareOrganizationSearchResults(city: String, name: String)
		
		// Details Flow
		case showHealthCategories
		case showHealthcareOrganization(healthcareOrganization: MgoOrganization)
		case showHealthCategory(category: HealthCategories.Category, organization: MgoOrganization?)
		case showHealthData(backButtonTitle: String?, schema: HealthUISchema, organization: MgoOrganization, inSheet: Bool)
		case removeHealthcareOrganization(healthcareOrganization: MgoOrganization)
		
		// Export
		case exportHealthData(PdfData)
	}
}

class HealthcareCoordinator: HealthcareCoordinatorProtocol {
	
	/// The navigation path for the first tab
	@Published var path = NavigationStackBackport.NavigationPath()
	
	/// The navigation path for the sheet.
	@Published var pathForSheet = NavigationStackBackport.NavigationPath()
	
	/// The root state
	@Published var rootState: HealthcareCoordination.State?
	
	/// The root state for a sheet.
	@Published var rootStateForSheet: HealthcareCoordination.State?
	
	/// The flow coordinator for routing
	private weak var parentCoordinator: (any DashboardCoordinatorProtocol)?
	
	/// Create a healthcare coordinator
	/// - Parameter coordinator: the coordinator
	init(parentCoordinator: (any DashboardCoordinatorProtocol)?, rootState: HealthcareCoordination.State) {
		
		self.parentCoordinator = parentCoordinator
		self.rootState = rootState
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Coordination.Action) {
		
		guard !handleSearchFlow(action) else { return }
		guard !handleHealthDataFlow(action) else { return }
		guard !handleExportFlow(action) else { return }
		
		switch action.identifier {
			
			// General
			
			case Coordination.Action.closeSheet.identifier,
				Coordination.Action.finishedSearchingHealthcareOrganizations.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
				
			case Coordination.Action.backButtonPressed.identifier:
				if !pathForSheet.isEmpty {
					pathForSheet.removeLast()
				} else {
					path.removeLast()
				}
				
			default:
				// Unhandled
				logWarning("Healthcare Coordinator does not handle \(action)")
		}
	}
	
	/// Handle the search flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	private func handleSearchFlow(_ action: Coordination.Action) -> Bool {
		
		switch action.identifier {
			
			// Healthcare Organization Search Flow
			
			case Coordination.Action.addHealthcareOrganization.identifier:
				if Current.featureFlagManager.isAutomaticLocalizationEnabled {
					rootStateForSheet = HealthcareCoordination.State.automaticLocalization
				} else {
					rootStateForSheet = HealthcareCoordination.State.manualLocalization
				}
				return true
				
			case Coordination.Action.showHealthcareOrganizationSearchResults.identifier:
				if action.params.count == 2,
				   let city = action.params["city"] as? String,
				   let name = action.params["name"] as? String {
					pathForSheet.append(HealthcareCoordination.State.healthcareOrganizationSearchResults(city: city, name: name))
				} else {
					logError("Healthcare Coordinator, missing params for \(action)")
				}
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
				return handleShowHealthcareOrganization(action)
				
			case Coordination.Action.showHealthCategory.identifier:
				return handleShowHealthCategory(action)
				
			case Coordination.Action.showHealthData.identifier:
				return handleShowHealthData(action)
				
			case Coordination.Action.removeHealthcareOrganization.identifier:
				return handleRemoveHealthcareOrganization(action)
				
			case Coordination.Action.removedHealthcareOrganization.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
				path.removeLast()
				return true
				
			default:
				return false
		}
	}
	
	/// Handle the search flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	private func handleExportFlow(_ action: Coordination.Action) -> Bool {
		
		if action.identifier == Coordination.Action.exportHealthData.identifier {
			
			if action.params.count == 1,
			   let data = action.params["healthData"] as? PdfData {
				let state = HealthcareCoordination.State.exportHealthData(data)
				if isIOS15 {
					path.append(state)
				} else {
					rootStateForSheet = state
				}
				return true
				
			} else {
				logError("HealthcareCoordinator Coordinator, missing params for \(action)")
				return false
			}
		} else {
			return false
		}
	}
	
	/// Handle the `showHealthcareOrganization` action
	/// - Parameter action: the action
	/// - Returns: true if handled successfully
	private func handleShowHealthcareOrganization(_ action: Coordination.Action) -> Bool {
		
		guard action.identifier == Coordination.Action.showHealthcareOrganization.identifier else { return false }
		
		if action.params.count == 1,
		   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization {
			
			path.append(HealthcareCoordination.State.showHealthcareOrganization(healthcareOrganization: healthcareOrganization))
			return true
		} else {
			logError("HealthcareCoordinator Coordinator, missing params for \(action)")
			return false
		}
	}
	
	/// Handle the `showHealthCategory` action
	/// - Parameter action: the action
	/// - Returns: true if handled successfully
	private func handleShowHealthCategory(_ action: Coordination.Action) -> Bool {
		
		guard action.identifier == Coordination.Action.showHealthCategory.identifier else { return false }
		
		if action.params.count == 2,
		   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization,
		   let category = action.params["category"] as? HealthCategories.Category {
			path.append(HealthcareCoordination.State.showHealthCategory(category: category, organization: healthcareOrganization))
			return true
		} else if action.params.count == 1,
				  let category = action.params["category"] as? HealthCategories.Category {
			path.append(HealthcareCoordination.State.showHealthCategory(category: category, organization: nil))
			return true
		} else {
			logError("HealthcareCoordinator Coordinator, missing params for \(action)")
			return false
		}
	}
	
	/// Handle the `showHealthData` action
	/// - Parameter action: the action
	/// - Returns: true if handled successfully
	private func handleShowHealthData(_ action: Coordination.Action) -> Bool {
		
		guard action.identifier == Coordination.Action.showHealthData.identifier else { return false }
		
		if action.params.count == 5,
		   // let resource = action.params["resource"] as? MgoResouce,
		   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization,
		   let backButtonTitle = action.params["backButtonTitle"] as? String,
		   let inSheet = action.params["inSheet"] as? Bool,
		   let schema = action.params["uiSchema"] as? HealthUISchema {
			
			let newState = HealthcareCoordination.State.showHealthData(
				backButtonTitle: inSheet && rootStateForSheet == nil ? nil : backButtonTitle,
				schema: schema,
				organization: healthcareOrganization,
				inSheet: inSheet
			)
			if inSheet {
				if rootStateForSheet == nil {
					rootStateForSheet = newState
				} else {
					pathForSheet.append(newState)
				}
			} else {
				path.append(newState)
			}
			return true
		} else {
			logError("HealthcareCoordinator Coordinator, missing params for \(action)")
			return false
		}
	}
	
	/// Handle the `removeHealthcareOrganization` action
	/// - Parameter action: the action
	/// - Returns: true if handled successfully
	private func handleRemoveHealthcareOrganization(_ action: Coordination.Action) -> Bool {
		
		guard action.identifier == Coordination.Action.removeHealthcareOrganization.identifier else { return false }
		
		if action.params.count == 1,
		   let healthcareOrganization = action.params["healthcareOrganization"] as? MgoOrganization {
			
			rootStateForSheet = HealthcareCoordination.State.removeHealthcareOrganization(healthcareOrganization: healthcareOrganization)
			return true
		} else {
			logError("HealthcareCoordinator Coordinator, missing params for \(action)")
			return false
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the HealthcareCoordination State
	/// - Returns: A view for that state
	@MainActor @ViewBuilder func viewState(for state: HealthcareCoordination.State?) -> some View {
		
		switch state {
			
			// Healthcare Organization Flow
			
			case .organizations:
				OrganizationsView(viewModel: OrganizationsViewModel(coordinator: self)).isPresentedAsSheet(false)
				
			case .manualLocalization:
				AddOrganizationView(viewModel: AddOrganizationViewModel(coordinator: self)).isPresentedAsSheet(true)
				
			case .automaticLocalization:
				OrganizationListAutomaticView(
					viewModel: OrganizationListAutomaticViewModel(
						coordinator: self,
						localisationServiceClient: Current.localisationServiceClient,
						preselectAllOrganizations: false
					)
				)
				.isPresentedAsSheet(true)
				
			case let .healthcareOrganizationSearchResults(city, name):
				OrganizationListManualView(
					viewModel: OrganizationListManualViewModel(
						coordinator: self,
						city: city,
						name: name,
						localisationServiceClient: Current.localisationServiceClient
					)
				)
				.isPresentedAsSheet(true)
				
			case let .showHealthcareOrganization(healthcareOrganization):
				HealthCategoriesView(
					viewModel:
						HealthCategoriesViewModel(
							coordinator: self,
							mode: .single( healthcareOrganization)
						)
				)
				.isPresentedAsSheet(false)
				
			case let .removeHealthcareOrganization(healthcareOrganization):
				RemoveHealthcareOrganizationView(
					viewModel: RemoveHealthcareOrganizationViewModel(
						coordinator: self,
						healthcareOrganization: healthcareOrganization
					)
				)
				.isPresentedAsSheet(true)
				
				// Health Categories and Data
				
			case .showHealthCategories:
				HealthCategoriesView(
					viewModel:
						HealthCategoriesViewModel(
							coordinator: self,
							mode: .all
						)
				)
				.isPresentedAsSheet(false)
				
			case let .showHealthCategory(category: category, organization: organization):
				viewState(for: category, organization: organization)
				.isPresentedAsSheet(false)
				
			case let .showHealthData(backButtonTitle: backButtonTitle, schema: schema, organization: healthcareOrganization, inSheet: inSheet):
				HealthDataView(
					viewModel: HealthDataViewModel(
						coordinator: self,
						schema: schema,
						backButtonTitle: backButtonTitle,
						healthcareOrganization: healthcareOrganization
					)
				)
				.isPresentedAsSheet(inSheet)
				
			case let .exportHealthData(healthData):
				HealthExportView(
					viewModel: HealthExportViewModel(
						coordinator: self,
						healthData: healthData
					)
				)
				.isPresentedAsSheet(!isIOS15)
			
			default:
				EmptyView()
					.logError("DashboardCoordinator, no view for", state as Any)
		}
	}
	
	/// Get a View for a category
	/// - Parameter category: the health category
	/// - Parameter organization: optional healthcare organization
	/// - Returns: A view for that state
	@ViewBuilder private func viewState(for category: HealthCategories.Category, organization: MgoOrganization? = nil) -> some View {
		
		switch category {
			case HealthCategories.Category.medication:
				HealthCategoryView(viewModel: MedicationHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.measurements:
				HealthCategoryView(viewModel: MeasurementsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.labResults:
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
				
			case HealthCategories.Category.medicalComplaints:
				HealthCategoryView(viewModel: ComplaintsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.personalDetails:
				HealthCategoryView(viewModel: PatientHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.alerts:
				HealthCategoryView(viewModel: AlertsHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.payment:
				HealthCategoryView(viewModel: PaymentHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.plans:
				HealthCategoryView(viewModel: PlansHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.medicalDevices:
				HealthCategoryView(viewModel: DevicesHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.mentalWellbeing:
				HealthCategoryView(viewModel: MentalStatusHealthCategoryViewModel(coordinator: self, organization: organization))
				
			case HealthCategories.Category.lifestyle:
				HealthCategoryView(viewModel: LifestyleHealthCategoryViewModel(coordinator: self, organization: organization))
		}
	}
}
