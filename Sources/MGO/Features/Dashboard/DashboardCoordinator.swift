/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

protocol DashboardCoordinatorProtocol: Coordinator, ObservableObject {
	
	associatedtype Body: View
	
	/// Get a View for the State
	/// - Parameter state: the Dashboard Coordination State
	/// - Returns: A view for that state
	func viewState(for: DashboardCoordination.State?) -> Body
	
	/// The selected tab
	var selectedTab: Int { get set }
}

/// The 3 tabs for the dashboard
enum DashboardTab: Int {
	case healthCategories = 0
	case healthcareOrganizations = 1
	case settings = 2
}

enum DashboardCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable {
		
		case healthCategories
		case healthcareOrganizations
		case settings
	}
}

class DashboardCoordinator: DashboardCoordinatorProtocol {
	
	/// The flow coordinator for routing
	private weak var parentCoordinator: (any AppCoordinatorProtocol)?
	
	/// The coordinator for all categories activities
	private var healthCategoriesCoordinator: HealthcareCoordinator!
	
	/// The coordinator for all healthcare organizations activities
	private var healthcareOrganizationsCoordinator: HealthcareCoordinator!
	
	/// The coordinator for all setting activities
	private var settingsCoordinator: SettingsCoordinator!
	
	/// The selected tab
	@Published var selectedTab: Int = DashboardTab.healthCategories.rawValue
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(parentCoordinator: (any AppCoordinatorProtocol)?) {
		
		self.parentCoordinator = parentCoordinator
		self.settingsCoordinator = SettingsCoordinator(parentCoordinator: self)
		self.healthCategoriesCoordinator = HealthcareCoordinator(parentCoordinator: self, rootState: .showHealthCategories)
		self.healthcareOrganizationsCoordinator = HealthcareCoordinator(parentCoordinator: self, rootState: .organizations)
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Coordination.Action) {
		
		if action == .resetApplication {
			parentCoordinator?.handle(.resetApplication)
			selectedTab = 0
			return
		}
		logWarning("Dashboard Coordinator does not handle \(action)")
	}
	
	/// Get a View for the State
	/// - Parameter state: the DashboardCoordination State
	/// - Returns: A view for that state
	@ViewBuilder func viewState(for state: DashboardCoordination.State?) -> some View {
		
		switch state {
			
			// Initial states
			
			case .settings:
				SettingsCoordinatorView(coordinator: settingsCoordinator)
			
			case .healthCategories:
				HealthcareCoordinatorView(coordinator: healthCategoriesCoordinator)
			
			case .healthcareOrganizations:
				HealthcareCoordinatorView(coordinator: healthcareOrganizationsCoordinator)
			
			default:
				EmptyView()
					.logError("Dashboard Coordinator, no view for", state as Any)
		}
	}
}
