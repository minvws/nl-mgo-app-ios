/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import LocalAuthentication
import RestrictedBrowser

protocol AppCoordinatorProtocol: Coordinator, ObservableObject {
	
	associatedtype Body: View
	
	/// The navigation path
	var path: NavigationStackBackport.NavigationPath { get set }
	
	/// The content type for the sheet
	var pathForSheet: NavigationStackBackport.NavigationPath { get set }
	
	/// The state for the root view of the sheet
	var rootStateForSheet: AppCoordination.State? { get set }
	
	/// The state for the root view of the page
	var rootState: AppCoordination.State { get set }
	
	/// Should we show the child coordinator?
	var showChildCoordinator: Bool { get set }
	
	/// Get a View for the State
	/// - Parameter state: the AppCoordination State
	/// - Returns: A view for that state
	func view(for: AppCoordination.State?) -> Body
}

extension Coordination.Action {
	
	// Launch
	static let finishedLoading = Coordination.Action(identifier: "finishedLoading")
	
	// Onboarding
	static let nextButtonPressedOnAppIntroduction = Coordination.Action(identifier: "nextButtonPressedOnAppIntroduction")
	static let nextButtonPressedOnPrivacyOverview = Coordination.Action(identifier: "nextButtonPressedOnPrivacyOverview")
	static let showPrivacyStatement = Coordination.Action(identifier: "showPrivacyStatement")
	
	// Local Authentication
	static let accessCodeEntered = Coordination.Action(identifier: "accessCodeEntered")
	static let accessCodeConfirmed = Coordination.Action(identifier: "accessCodeConfirmed")
	static let didFinishLocalAuthentication = Coordination.Action(identifier: "didFinishLocalAuthentication")
	static let accessCodeValidated = Coordination.Action(identifier: "accessCodeValidated")
	static let forgotAccessCode = Coordination.Action(identifier: "forgotAccessCode")
	static let dismissForgotAccessCode = Coordination.Action(identifier: "dismissForgotAccessCode")
	static let recreateAccount = Coordination.Action(identifier: "recreateAccount")
	
	// Remote Authentication
	static let loggedInWithDigiD = Coordination.Action(identifier: "loggedInWithDigiD")
	
	// Healthcare Provider flow
	static let search = Coordination.Action(identifier: "search")
	static let backToSearchHealthcareProvider = Coordination.Action(identifier: "backToSearchHealthcareProvider")
	static let storeHealthcareProvider = Coordination.Action(identifier: "storeHealthcareProvider")
	static let finishedSearchingHealthcareProviders = Coordination.Action(identifier: "finishedSearchingHealthcareProviders")
	
	// Other
	static let closeSheet = Coordination.Action(identifier: "closeSheet")
	static let backButtonPressed = Coordination.Action(identifier: "backButtonPressed")
	static let resetApplication = Coordination.Action(identifier: "resetApplication")
}

enum AppCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable {
		case launch
		
		// Onboarding
		case appIntroduction(recreated: Bool)
		case privacyOverview
		case privacyStatement
		
		// Local Authentication
		case accessCodeEntry
		case accessCodeConfirmation
		case accessCodeValidation
		case bioMetricSetup
		case forgotAccessCode
		
		// Remote Authentication
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
	@Published var pathForSheet: NavigationStackBackport.NavigationPath = NavigationStackBackport.NavigationPath()
	
	/// the root state for the sheet
	@Published var rootStateForSheet: AppCoordination.State?
	
	/// The state for the root view of the page
	@Published var rootState: AppCoordination.State
	
	/// Should we show the child coordinator instead of ourself?
	@Published var showChildCoordinator = false
	
	/// the browser to open allowed domains in
	private var browser = RestrictedBrowser(allowedDomains: Configuration().getAllowedDomains(for: Configuration().getRelease()))
	
	/// The localisation client
	private var localisationServiceClient: LocalisationServiceClientProtocol?
	
	/// Initializer
	/// - Parameter path: Navigation Path
	init(
		path: NavigationStackBackport.NavigationPath,
		localisationServiceClient: LocalisationServiceClientProtocol? = LocalisationServiceClient()) {
			
			if LaunchArgumentsHandler.shouldResetOnStart() {
				Current.wipePersistedData()
			}
			
			self.path = path
			self.localisationServiceClient = localisationServiceClient
			self.rootState = .launch
		}
	
	/// the URL for the privacy page
	private var privacyURL: URL? {
		
		switch Configuration().getRelease() {
			case .production:
				return URL(string: String(localized: "privacy_statement_overview_prod"))
			case .acceptance:
				return URL(string: String(localized: "privacy_statement_overview_acc"))
			case .test, .development:
				return URL(string: String(localized: "privacy_statement_overview_tst"))
		}
	}
		
	func handle(_ action: Coordination.Action) {
		
		switch action.identifier {
			// Onboarding
			
			case Coordination.Action.finishedLoading.identifier:
				handleStartup()
			
			case Coordination.Action.nextButtonPressedOnAppIntroduction.identifier:
				path.append(AppCoordination.State.privacyOverview)
				
			case Coordination.Action.nextButtonPressedOnPrivacyOverview.identifier:
				// Mark AppIntroduction Flow as seen.
				Current.secureUserSettings.userHasSeenAppIntroduction = true
				resetNavigationStack(with: AppCoordination.State.accessCodeEntry)
				
			case Coordination.Action.showPrivacyStatement.identifier:
				
				guard let privacyURL else { return }
				
				if browser.isDomainAllowed(privacyURL) {
					path.append(AppCoordination.State.privacyStatement)
				} else {
					browser.handleUnallowedDomain(privacyURL)
				}
				
			// Local Authentication
				
			case Coordination.Action.accessCodeEntered.identifier:
				path.append(AppCoordination.State.accessCodeConfirmation)
				
			case Coordination.Action.accessCodeConfirmed.identifier:
				handleAccessCodeConfirmed()
				
			case Coordination.Action.accessCodeValidated.identifier:
				showChildCoordinator = true
				
			case Coordination.Action.didFinishLocalAuthentication.identifier:
				resetNavigationStack(with: AppCoordination.State.remoteAuthentication)
				
			case Coordination.Action.forgotAccessCode.identifier:
				rootStateForSheet = AppCoordination.State.forgotAccessCode
				
			case Coordination.Action.recreateAccount.identifier:
				if rootStateForSheet != nil {
					rootStateForSheet = nil
					pathForSheet = NavigationStackBackport.NavigationPath()
				}
				// Wipe Account
				Current.wipePersistedData()
				resetNavigationStack(with: AppCoordination.State.appIntroduction(recreated: true))
				
				// Remote Authentication
				
			case Coordination.Action.loggedInWithDigiD.identifier:
				
				Current.secureUserSettings.userHasRemoteAuthentication = true
				showChildCoordinator = true
				
			// General
				
			case Coordination.Action.closeSheet.identifier,
				Coordination.Action.dismissForgotAccessCode.identifier:
				
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
				
			case Coordination.Action.backButtonPressed.identifier:
				guard !path.isEmpty else { return }
				path.removeLast()
				
			case Coordination.Action.resetApplication.identifier:
				// Clear everything
				showChildCoordinator = false
				Current.wipePersistedData()
				path.removeLast(path.count)
				Current.notificationCenter.post(name: .resetApplication, object: nil)
			
			default:
				logWarning("AppCoordinator does not handle \(action)")
		}
	}
	
	/// Handle the complex startup logic
	private func handleStartup() {
		
		if !Current.secureUserSettings.userHasSeenAppIntroduction {
			// Only show the appIntroduction once
			resetNavigationStack(with: AppCoordination.State.appIntroduction(recreated: false))
		} else if Current.secureUserSettings.accessCode == nil {
			// User must set an access code
			resetNavigationStack(with: AppCoordination.State.accessCodeEntry)
		} else {
			// Repeat login, user must authenticate with access code
			resetNavigationStack(with: AppCoordination.State.accessCodeValidation)
		}
	}
	
	/// Handle the access code confirmed state
	private func handleAccessCodeConfirmed() {
		
		if Current.localAuthenticationProvider.biometricType() == .none {
			resetNavigationStack(with: AppCoordination.State.remoteAuthentication)
		} else {
			resetNavigationStack(with: AppCoordination.State.bioMetricSetup)
		}
	}
	
	private func resetNavigationStack(with state: AppCoordination.State) {
		
		var transaction = Transaction()
		transaction.disablesAnimations = true
		withTransaction(transaction) {
			path.removeLast(path.count)
			rootState = state
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
				
			case let .appIntroduction(recreated):
				AppIntroductionView(viewModel: AppIntroductionViewModel(coordinator: self, showAccountDeletedToast: recreated))
				
			case .privacyOverview:
				PrivacyOverviewView(viewModel: PrivacyOverviewViewModel(coordinator: self))
				
			case .privacyStatement:
				if let privacyURL {
					InAppBrowserView(viewModel: InAppBrowserViewModel(url: privacyURL, browser: self.browser, title: "Mijn gezondheidsoverzicht", coordinator: self))
				} else {
					EmptyView()
				}
				
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
				ForgotAccessCodeView(viewModel: ForgotAccessCodeViewModel(coordinator: self))
				
			// Remote Authentication
				
			case .remoteAuthentication:
				RemoteAuthenticationView(viewModel: RemoteAuthenticationViewModel(coordinator: self))
				
			// Dashboard
				
			case .dashboard:
				DashboardCoordinatorView(coordinator: DashboardCoordinator(parentCoordinator: self))
			
			// Fallback
				
			case .none:
				EmptyView()
		}
	}
}
