/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import PdfExport

extension Coordination.Action {
	
	// Healthcare Organization flow
	@MainActor static let addHealthcareOrganization = Coordination.Action(identifier: "addHealthcareOrganization") // Show Search Form
	@MainActor static let showHealthcareOrganization = Coordination.Action(identifier: "showHealthcareOrganization")
	
	@MainActor static let showHealthCategory = Coordination.Action(identifier: "showHealthCategory")
	@MainActor static let showHealthData = Coordination.Action(identifier: "showHealthData")
	
	@MainActor static let removeHealthcareOrganization = Coordination.Action(identifier: "removeHealthcareOrganization")
	@MainActor static let removedHealthcareOrganization = Coordination.Action(identifier: "removedHealthcareOrganization")
	
	@MainActor static let exportHealthData = Coordination.Action(identifier: "exportHealthData")
	
	@MainActor static let showFavorites = Coordination.Action(identifier: "showFavorites")
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
	@MainActor func view(for: HealthcareCoordination.State?) -> Body
}

struct HealthcareCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Decodable, Sendable {
		
		// Organizations
		case organizations
		
		// Search & Store Healthcare Organization flow
		case manualLocalization
		
		// Details Flow
		case showHealthCategories
		case showHealthcareOrganization(healthcareOrganization: OrganizationSearch.Organization)
		case showHealthCategory(category: SharedHealthCategories.Category, organization: OrganizationSearch.Organization?)
		case showHealthData(config: HealthDataViewConfig, schema: HealthUISchema, organization: OrganizationSearch.Organization)
		case removeHealthcareOrganization(healthcareOrganization: OrganizationSearch.Organization)
		
		// Favorites
		case showFavorites
		
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
	@MainActor func handle(_ action: Coordination.Action) {
		
		guard !handleSearchFlow(action) else { return }
		guard !handleHealthDataFlow(action) else { return }
		guard !handleExportFlow(action) else { return }
		guard !handleFavorites(action) else { return }
		
		switch action.identifier {
			
			// General
			
			case Coordination.Action.closeSheet.identifier:
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
	@MainActor private func handleSearchFlow(_ action: Coordination.Action) -> Bool {

		if action.identifier == Coordination.Action.addHealthcareOrganization.identifier {
			rootStateForSheet = HealthcareCoordination.State.manualLocalization
			return true
		}
		return false
	}
	
	/// Handle the detail flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	@MainActor func handleHealthDataFlow(_ action: Coordination.Action) -> Bool {
		
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
	@MainActor private func handleExportFlow(_ action: Coordination.Action) -> Bool {
		
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

	/// Handle the show favorites action
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	@MainActor private func handleFavorites(_ action: Coordination.Action) -> Bool {
		
		if action.identifier == Coordination.Action.showFavorites.identifier {
			rootStateForSheet = HealthcareCoordination.State.showFavorites
			return true
		} else {
			return false
		}
	}
	
	/// Handle the `showHealthcareOrganization` action
	/// - Parameter action: the action
	/// - Returns: true if handled successfully
	@MainActor private func handleShowHealthcareOrganization(_ action: Coordination.Action) -> Bool {
		
		guard action.identifier == Coordination.Action.showHealthcareOrganization.identifier else { return false }
		
		if action.params.count == 1,
		   let healthcareOrganization = action.params["healthcareOrganization"] as? OrganizationSearch.Organization {
			
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
	@MainActor private func handleShowHealthCategory(_ action: Coordination.Action) -> Bool {
		
		guard action.identifier == Coordination.Action.showHealthCategory.identifier else { return false }
		
		if action.params.count == 2,
		   let healthcareOrganization = action.params["healthcareOrganization"] as? OrganizationSearch.Organization,
		   let category = action.params["category"] as? SharedHealthCategories.Category {
			path.append(HealthcareCoordination.State.showHealthCategory(category: category, organization: healthcareOrganization))
			return true
		} else if action.params.count == 1,
				  let category = action.params["category"] as? SharedHealthCategories.Category {
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
	@MainActor private func handleShowHealthData(_ action: Coordination.Action) -> Bool {
		
		guard action.identifier == Coordination.Action.showHealthData.identifier else { return false }
		
		if action.params.count == 5,
		   // let resource = action.params["resource"] as? MgoResouce,
		   let healthcareOrganization = action.params["healthcareOrganization"] as? OrganizationSearch.Organization,
		   let backButtonTitle = action.params["backButtonTitle"] as? String,
		   let inSheet = action.params["inSheet"] as? Bool,
		   let schema = action.params["uiSchema"] as? HealthUISchema {
			
			let newState = HealthcareCoordination.State.showHealthData(
				config: HealthDataViewConfig(
					backButtonTitle: inSheet && rootStateForSheet == nil ? nil : backButtonTitle,
					inSheet: inSheet)
				,
				schema: schema,
				organization: healthcareOrganization,
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
	@MainActor private func handleRemoveHealthcareOrganization(_ action: Coordination.Action) -> Bool {
		
		guard action.identifier == Coordination.Action.removeHealthcareOrganization.identifier else { return false }
		
		if action.params.count == 1,
		   let healthcareOrganization = action.params["healthcareOrganization"] as? OrganizationSearch.Organization {
			
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
	@ViewBuilder @MainActor func view(for state: HealthcareCoordination.State?) -> some View {
		
		switch state {
			
			// Healthcare Organization Flow
			
			case .organizations:
				OrganizationsView(viewModel: OrganizationsViewModel(coordinator: self)).isPresentedAsSheet(false)
				
			case .manualLocalization:
				SearchOrganizationView(
					viewModel: SearchOrganizationViewModel(
						coordinator: self,
						firstVisitor: false
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
				
			case let .showHealthData(config: config, schema: schema, organization: organization):
				
				HealthDataView(
					viewModel: HealthDataViewModel(
						coordinator: self,
						config: config,
						schema: schema,
						healthcareOrganization: organization
					)
				)
				.isPresentedAsSheet(config.inSheet)
				
			case let .exportHealthData(healthData):
				HealthExportView(
					viewModel: HealthExportViewModel(
						coordinator: self,
						healthData: healthData
					)
				)
				.isPresentedAsSheet(!isIOS15)
			
			case .showFavorites:
				FavoritesView(viewModel: FavoritesViewModel(coordinator: self))
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
	@MainActor @ViewBuilder private func viewState(
		for category: SharedHealthCategories.Category,
		organization: OrganizationSearch.Organization? = nil
	) -> some View {
		
		if category.id == "documents" {
			// Documents has an override method for sortRecords.
			HealthCategoryView(
				viewModel: DocumentsHealthCategoryViewModel(
					coordinator: self,
					category: category,
					organization: organization
				)
			)
		} else {
			if let translations = HealthCategoryViewTranslationsFactory.makeTranslations(for: category) {
				HealthCategoryView(
					viewModel: HealthCategoryViewModel(
						coordinator: self,
						category: category,
						organization: organization,
						translations: translations
					)
				)
			} else {
				EmptyView()
					.logError("HealthcareCoordinator, no translations for category", category.id)
			}
		}
	}
}
