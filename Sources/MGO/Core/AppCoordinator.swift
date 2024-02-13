/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

protocol AppCoordinatorProtocol: ObservableObject {
	
	associatedtype Body: View
	
	/// The navigation path
	var path: NavigationStackBackport.NavigationPath { get set }
	
	/// The content type for the sheet
	var sheet: AppCoordination.Sheet? { get set }
	
	/// Handle an incoming action from any of the view models
	/// - Parameter action: an AppCoordination Action
	func handle(_ action: AppCoordination.Action)
	
	/// Get a View for the State
	/// - Parameter state: the AppCoordination State
	/// - Returns: A view for that state
	func view(for: AppCoordination.State) -> Body
}

enum AppCoordination {
	
	/// A list of all the action an app coordinator can do
	enum Action {
		case finishedLoading
		case nextButtonPressedOnAppIntroduction
		case nextButtonPressedOnPrivacyOverview
		case showPrivacyStatement
		case backButtonPressed
	}
	
	/// A list of all the view states the app coordinator can show
	enum State: Codable {
		case launch
		case appIntroduction
		case privacyOverview
		case privacyStatement
		case dashboard
	}
	
	/// A list of all the sheets the app coordinator can show
	enum Sheet: Codable {
		case privacyStatement
	}
}

final class AppCoordinator: AppCoordinatorProtocol {
	
	/// The navigation path
	@Published var path: NavigationStackBackport.NavigationPath
	
	/// The content type for the sheet
	@Published var sheet: AppCoordination.Sheet?
	
	/// Initializer
	/// - Parameter path: Navigation Path
	init(path: NavigationStackBackport.NavigationPath) {
		Current.secureUserSettings.wipePersistedData()
		self.path = path
	}
	
	/// Handle an action
	/// - Parameter action: an action, i.e. finishedLoading
	func handle(_ action: AppCoordination.Action) {
		
		switch action {
			case .finishedLoading:
				guard !Current.secureUserSettings.userHasSeenAppIntroduction else {
					path.append(AppCoordination.State.dashboard)
					return
				}
				// Only show the appIntroduction once
				path.append(AppCoordination.State.appIntroduction)
			
			case .nextButtonPressedOnAppIntroduction:
				path.append(AppCoordination.State.privacyOverview)
			
			case .nextButtonPressedOnPrivacyOverview:
				// Mark AppIntroduction Flow as seen.
				Current.secureUserSettings.userHasSeenAppIntroduction = true
				path.append(AppCoordination.State.dashboard)
			
			case .showPrivacyStatement:
				path.append(AppCoordination.State.privacyStatement)
			
			case .backButtonPressed:
				guard !path.isEmpty else { return }
				path.removeLast()
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the AppCoordination State
	/// - Returns: A view for that state
	@ViewBuilder func view(for state: AppCoordination.State) -> some View {
		
		switch state {
			case .launch:
				LaunchView(viewModel: LaunchViewModel(coordinator: self))
		
			case .appIntroduction:
				AppIntroductionView(viewModel: AppIntroductionViewModel(coordinator: self))
		
			case .privacyOverview:
				PrivacyView(viewModel: PrivacyViewModel(coordinator: self))

			case .privacyStatement:
				PrivacyStatementView(viewModel: PrivacyStatementViewModel(coordinator: self))

			case .dashboard:
				DashboardView()
		}
	}
}
