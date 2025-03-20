/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

extension Coordination.Action {
	
	static let showDisplaySettings = Coordination.Action(identifier: "showDisplaySettings")
}

protocol SettingsCoordinatorProtocol: Coordinator, ObservableObject {
	
	associatedtype Body: View
	
	/// The navigation path
	var path: NavigationStackBackport.NavigationPath { get set }
	
	/// Get a View for the State
	/// - Parameter state: the DashboardCoordination State
	/// - Returns: A view for that state
	func view(for state: SettingsCoordination.State?) -> Body
}

enum SettingsCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable {
		
		case settings
		case displaySettings
	}
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
	
	/// The navigation path
	@Published var path = NavigationStackBackport.NavigationPath()
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Coordination.Action) {
		
		switch action {
			case .showDisplaySettings:
				path.append(SettingsCoordination.State.displaySettings)
			
			default:
				logWarning("Settings Coordinator does not handle \(action)")
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the SettingsCoordination State
	/// - Returns: A view for that state
	@ViewBuilder func view(for state: SettingsCoordination.State?) -> some View {
		
		switch state {
			
			case .settings:
				SettingsView(viewModel: SettingsViewModel(coordinator: self))
			
			case .displaySettings:
				DisplaySettingsView()
			
			default:
				EmptyView()
				.logError("SettingsCoordinator, no view for", state as Any)
		}
	}
}
