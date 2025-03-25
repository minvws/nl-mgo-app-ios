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
	static let showSecuritySettings = Coordination.Action(identifier: "showSecuritySettings")
	static let showAdvancedSettings = Coordination.Action(identifier: "showAdvancedSettings")
	static let showAboutTheApp = Coordination.Action(identifier: "showAboutTheApp")
	static let lockApplication = Coordination.Action(identifier: "lockApplication")
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
		case securitySettings
		case advancedSettings
		case aboutTheApp
	}
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
	
	/// The navigation path
	@Published var path = NavigationStackBackport.NavigationPath()
	
	/// The parent coordinator for routing
	private weak var parentCoordinator: (any DashboardCoordinatorProtocol)?
	
	/// Create a Settings Coordinator
	/// - Parameter coordinator: the coordinator
	init(parentCoordinator: (any DashboardCoordinatorProtocol)?) {
		
		self.parentCoordinator = parentCoordinator
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Coordination.Action) {
		
		switch action {
			case .backButtonPressed:
				path.removeLast()
			
			case .lockApplication:
				Current.notificationCenter.post(name: .showLocalAuthentication, object: nil)
			
			case .showAboutTheApp:
				path.append(SettingsCoordination.State.aboutTheApp)
	
			case .showAdvancedSettings:
				path.append(SettingsCoordination.State.advancedSettings)
			
			case .showDisplaySettings:
				path.append(SettingsCoordination.State.displaySettings)
				
			case .showSecuritySettings:
				path.append(SettingsCoordination.State.securitySettings)
			
			default:
				logWarning("Settings Coordinator does not handle \(action)")
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the SettingsCoordination State
	/// - Returns: A view for that state
	@ViewBuilder func view(for state: SettingsCoordination.State?) -> some View {
		
		switch state {
			
			case .advancedSettings:
				AdvancedSettingsView(
					viewModel: AdvancedSettingsViewModel(coordinator: self)
				)
			
			case .aboutTheApp:
				Text(verbatim: "Todo: About the app")
			
			case .displaySettings:
				DisplaySettingsView()
			
			case .securitySettings:
				SecuritySettingsView(
					viewModel: SecuritySettingsViewModel(
						coordinator: self,
						bioMetricType: Current.localAuthenticationProvider.biometricType
					)
				)
			
			case .settings:
				SettingsView(viewModel: SettingsViewModel(coordinator: self))
			
			default:
				EmptyView()
				.logError("SettingsCoordinator, no view for", state as Any)
		}
	}
}
