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
	
	/// The content type for the sheet
	var sheet: AppCoordination.State? { get set }
	
	/// Handle an incoming action from any of the view models
	/// - Parameter action: an AppCoordination Action
	func handle(_ action: AppCoordination.Action)
	
	/// Get a View for the State
	/// - Parameter state: the AppCoordination State
	/// - Returns: A view for that state
	func view(for: AppCoordination.State?) -> Body
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
		case didFinishLocalAuthentication
		case accessCodeValidated
		case forgotAccessCode
		
		// Remote Authentication
		case loginWithDigiD
		case loginWithAccessCode
		
		// Other
		case sheetClosed
		case backButtonPressed
		case resetApplication
	}
	
	/// A list of all the view states the app coordinator can show
	enum State: Codable {
		case launch
		
		// Onboarding
		case appIntroduction
		case privacyOverview
		case privacyStatement
		
		// Local Authentication
		case accessCodeEntry
		case accessCodeConfirmation
		case accessCodeValidation
		case bioMetricSetup
		case forgotAccessCode
		
		// Remote Auhtentication
		case remoteAuthentication
		
		// Dashboard
		case dashboard
	}
}

extension Notification.Name {
	static let resetApplication = Notification.Name("nl.mijngezondheidsomgeving.resetApplication")
}

final class AppCoordinator: AppCoordinatorProtocol {
	
	/// The navigation path
	@Published var path: NavigationStackBackport.NavigationPath
	
	/// The content type for the sheet
	@Published var sheet: AppCoordination.State?
	
	/// Initializer
	/// - Parameter path: Navigation Path
	init(path: NavigationStackBackport.NavigationPath) {
		
		self.path = path
	}
	
	/// Handle an action
	/// - Parameter action: an action, i.e. finishedLoading
	func handle(_ action: AppCoordination.Action) {
		
		switch action {
			
			// Onboarding
			
			case .finishedLoading:
				if !Current.secureUserSettings.userHasSeenAppIntroduction {
					// Only show the appIntroduction once
					path.append(AppCoordination.State.appIntroduction)
				} else if Current.secureUserSettings.accessCode == nil {
					path.append(AppCoordination.State.accessCodeEntry)
					
				} else {
					path.append(AppCoordination.State.remoteAuthentication)
				}
			case .nextButtonPressedOnAppIntroduction:
				path.append(AppCoordination.State.privacyOverview)
			
			case .nextButtonPressedOnPrivacyOverview:
				// Mark AppIntroduction Flow as seen.
				Current.secureUserSettings.userHasSeenAppIntroduction = true
				path.append(AppCoordination.State.accessCodeEntry)
			
			case .showPrivacyStatement:
				path.append(AppCoordination.State.privacyStatement)
			
			// Local Authentication
			
			case .accessCodeEntered:
				path.append(AppCoordination.State.accessCodeConfirmation)
			
			case .accessCodeConfirmed:
			
				if Current.localAuthenticationProvider.biometricType() == .none {
					path.append(AppCoordination.State.remoteAuthentication)
				} else {
					path.append(AppCoordination.State.bioMetricSetup)
				}
			
			case .accessCodeValidated:
				path.append(AppCoordination.State.dashboard)
			
			case .didFinishLocalAuthentication:
				path.append(AppCoordination.State.remoteAuthentication)
			
			case .forgotAccessCode:
				sheet = AppCoordination.State.forgotAccessCode
			
			// Remote Authentication
			
			case .loginWithDigiD:
				Current.secureUserSettings.userHasRemoteAuthentication = true
				path.append(AppCoordination.State.dashboard)
			
			case .loginWithAccessCode:
				path.append(AppCoordination.State.accessCodeValidation)
			
			// General
			
			case .sheetClosed:
				sheet = nil
			
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
	@ViewBuilder func view(for state: AppCoordination.State?) -> some View {
		
		switch state {
			case .launch:
				LaunchView(viewModel: LaunchViewModel(coordinator: self))
		
			// Onboarding
			
			case .appIntroduction:
				AppIntroductionView(viewModel: AppIntroductionViewModel(coordinator: self))
		
			case .privacyOverview:
				PrivacyOverviewView(viewModel: PrivacyOverviewViewModel(coordinator: self))

			case .privacyStatement:
				PrivacyStatementView(viewModel: PrivacyStatementViewModel(coordinator: self))

			// Local Authentication
			
			case .accessCodeEntry:
				AccessCodeView(viewModel: AccessCodeViewModel(coordinator: self, mode: .creation, bioMetricType: Current.localAuthenticationProvider.biometricType))
				
			case .accessCodeConfirmation:
				AccessCodeView(viewModel: AccessCodeViewModel(coordinator: self, mode: .confirmation, bioMetricType: Current.localAuthenticationProvider.biometricType))
			
			case .accessCodeValidation:
				AccessCodeView(viewModel: AccessCodeViewModel(coordinator: self, mode: .validation, bioMetricType: Current.localAuthenticationProvider.biometricType))
			
			case .bioMetricSetup:
				BioMetricSetupView(viewModel: BioMetricSetupViewModel(coordinator: self, bioMetricType: Current.localAuthenticationProvider.biometricType))
			
			case .forgotAccessCode:
				Text("Todo")
			
			// Remote Authentication
	
			case .remoteAuthentication:
				RemoteAuthenticationView(viewModel: RemoteAuthenticationViewModel(coordinator: self))
			
			// Dashboard
	
			case .dashboard:
//				DashboardView(viewModel: DashboardViewModel(coordinator: self))
				PatientView(viewModel: PatientViewModel(coordinator: self))

			// Fallback
			
			case .none:
				EmptyView()
		}
	}
}
