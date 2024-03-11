/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import LocalAuthentication

protocol AppCoordinatorProtocol: ObservableObject {
	
	associatedtype Body: View
	
	/// The navigation path
	var path: NavigationStackBackport.NavigationPath { get set }
	
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
		// Launch
		case finishedLoading
		
		// Onboarding
		case nextButtonPressedOnAppIntroduction
		case nextButtonPressedOnPrivacyOverview
		case showPrivacyStatement
		
		// Local Authentication
		case accessCodeEntered
		case accessCodeConfirmed
		
		// Other
		case backButtonPressed
		case resetApplication
	}
	
	/// A list of all the view states the app coordinator can show
	enum State: Codable {
		case launch
		case appIntroduction
		case privacyOverview
		case privacyStatement
		case accessCodeEntry
		case accessCodeConfirmation
		case dashboard
	}
}

extension Notification.Name {
	static let resetApplication = Notification.Name("nl.mijngezondheidsomgeving.resetApplication")
}

final class AppCoordinator: AppCoordinatorProtocol {
	
	/// The navigation path
	@Published var path: NavigationStackBackport.NavigationPath
	
	/// Initializer
	/// - Parameter path: Navigation Path
	init(path: NavigationStackBackport.NavigationPath) {
		
		self.path = path
	}
	
	/// Handle an action
	/// - Parameter action: an action, i.e. finishedLoading
	func handle(_ action: AppCoordination.Action) {
		
		switch action {
			
			case .finishedLoading:
				if !Current.secureUserSettings.userHasSeenAppIntroduction {
					// Only show the appIntroduction once
					path.append(AppCoordination.State.appIntroduction)
				} else if Current.secureUserSettings.accessCode == nil {
					path.append(AppCoordination.State.accessCodeEntry)
				} else {
					path.append(AppCoordination.State.dashboard)
				}
			case .nextButtonPressedOnAppIntroduction:
				path.append(AppCoordination.State.privacyOverview)
			
			case .nextButtonPressedOnPrivacyOverview:
				// Mark AppIntroduction Flow as seen.
				Current.secureUserSettings.userHasSeenAppIntroduction = true
				path.append(AppCoordination.State.accessCodeEntry)
			
			case .showPrivacyStatement:
				path.append(AppCoordination.State.privacyStatement)
			
			case .accessCodeEntered:
				path.append(AppCoordination.State.accessCodeConfirmation)
			
			case .accessCodeConfirmed:
				#warning("Todo: BioMetric Setup")
				path.append(AppCoordination.State.dashboard)
			
			case .backButtonPressed:
				guard !path.isEmpty else { return }
				path.removeLast()
			
			case .resetApplication:
				// Clear everything
				Current.wipePersistedData()
				path.removeLast(path.count)
				Current.notificationCenter.post(name: .resetApplication, object: nil)
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

			case .accessCodeEntry:
				AccessCodeView(viewModel: AccessCodeViewModel(coordinator: self, mode: .creation, bioMetricType: {
					// LAContext().biometricType
					.touchID
				}))
				
			case .accessCodeConfirmation:
				AccessCodeView(viewModel: AccessCodeViewModel(coordinator: self, mode: .confirmation, bioMetricType: {
					// LAContext().biometricType
					.touchID
				}))
			
			case .dashboard:
//				DashboardView(viewModel: DashboardViewModel(coordinator: self))
				PatientView(viewModel: PatientViewModel(coordinator: self))

		}
	}
}
