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
	static let nextButtonPressedOnIntroduction = Coordination.Action(identifier: "nextButtonPressedOnIntroduction")
	static let nextButtonPressedOnProposition = Coordination.Action(identifier: "nextButtonPressedOnProposition")
	static let showPrivacyStatement = Coordination.Action(identifier: "showPrivacyStatement")
	
	// Local Authentication
	static let pinCodeEntered = Coordination.Action(identifier: "pinCodeEntered")
	static let pinCodeConfirmed = Coordination.Action(identifier: "pinCodeConfirmed")
	static let didFinishLocalAuthentication = Coordination.Action(identifier: "didFinishLocalAuthentication")
	static let pinCodeValidated = Coordination.Action(identifier: "pinCodeValidated")
	static let forgotPinCode = Coordination.Action(identifier: "forgotPinCode")
	static let dismissForgotPinCode = Coordination.Action(identifier: "dismissForgotPinCode")
	static let recreateAccount = Coordination.Action(identifier: "recreateAccount")
	
	// Remote Authentication
	static let loggedInWithDigiD = Coordination.Action(identifier: "loggedInWithDigiD")
	
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
		case introduction(recreated: Bool)
		case proposition
		case privacyStatement
		
		// Local Authentication
		case pinCodeEntry
		case pinCodeConfirmation
		case pinCodeValidation
		case bioMetricSetup
		case forgotPinCode
		
		// Remote Authentication
		case login
		
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
			
			case Coordination.Action.nextButtonPressedOnIntroduction.identifier:
				path.append(AppCoordination.State.proposition)
				
			case Coordination.Action.nextButtonPressedOnProposition.identifier:
				// Mark AppIntroduction Flow as seen.
				Current.secureUserSettings.userHasSeenAppIntroduction = true
				resetNavigationStack(with: AppCoordination.State.pinCodeEntry)
				
			case Coordination.Action.showPrivacyStatement.identifier:
				
				guard let privacyURL else { return }
				
				if browser.isDomainAllowed(privacyURL) {
					path.append(AppCoordination.State.privacyStatement)
				} else {
					browser.handleUnallowedDomain(privacyURL)
				}
				
			// Local Authentication
				
			case Coordination.Action.pinCodeEntered.identifier:
				path.append(AppCoordination.State.pinCodeConfirmation)
				
			case Coordination.Action.pinCodeConfirmed.identifier:
				handlePinCodeConfirmed()
				
			case Coordination.Action.pinCodeValidated.identifier:
				showChildCoordinator = true
				
			case Coordination.Action.didFinishLocalAuthentication.identifier:
				resetNavigationStack(with: AppCoordination.State.login)
				
			case Coordination.Action.forgotPinCode.identifier:
				rootStateForSheet = AppCoordination.State.forgotPinCode
				
			case Coordination.Action.recreateAccount.identifier:
				if rootStateForSheet != nil {
					rootStateForSheet = nil
					pathForSheet = NavigationStackBackport.NavigationPath()
				}
				// Wipe Account
				Current.wipePersistedData()
				resetNavigationStack(with: AppCoordination.State.introduction(recreated: true))
				
				// Remote Authentication
				
			case Coordination.Action.loggedInWithDigiD.identifier:
				
				Current.secureUserSettings.userHasRemoteAuthentication = true
				showChildCoordinator = true
				
			// General
				
			case Coordination.Action.closeSheet.identifier,
				Coordination.Action.dismissForgotPinCode.identifier:
				
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
			resetNavigationStack(with: AppCoordination.State.introduction(recreated: false))
		} else if Current.secureUserSettings.pinCode == nil {
			// User must set an pin code
			resetNavigationStack(with: AppCoordination.State.pinCodeEntry)
		} else {
			// Repeat login, user must authenticate with pin code
			resetNavigationStack(with: AppCoordination.State.pinCodeValidation)
		}
	}
	
	/// Handle the pin code confirmed state
	private func handlePinCodeConfirmed() {
		
		if Current.localAuthenticationProvider.biometricType() == .none {
			resetNavigationStack(with: AppCoordination.State.login)
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
				
			case let .introduction(recreated):
				IntroductionView(viewModel: IntroductionViewModel(coordinator: self, showAccountDeletedToast: recreated))
				
			case .proposition:
				PropositionView(viewModel: PropositionViewModel(coordinator: self))
				
			case .privacyStatement:
				if let privacyURL {
					InAppBrowserView(viewModel: InAppBrowserViewModel(url: privacyURL, browser: self.browser, title: "Mijn gezondheidsoverzicht", coordinator: self))
				} else {
					EmptyView()
				}
				
			// Local Authentication
				
			case .pinCodeEntry:
				PinCodeView(viewModel: PinCodeViewModel(coordinator: self, mode: .creation, bioMetricType: Current.localAuthenticationProvider.biometricType))
				
			case .pinCodeConfirmation:
				PinCodeView(viewModel: PinCodeViewModel(coordinator: self, mode: .confirmation, bioMetricType: Current.localAuthenticationProvider.biometricType))
				
			case .pinCodeValidation:
				PinCodeView(viewModel: PinCodeViewModel(coordinator: self, mode: .validation, bioMetricType: Current.localAuthenticationProvider.biometricType))
				
			case .bioMetricSetup:
				BioMetricSetupView(viewModel: BioMetricSetupViewModel(coordinator: self, bioMetricType: Current.localAuthenticationProvider.biometricType))
				
			case .forgotPinCode:
				ForgotPinCodeView(viewModel: ForgotPinCodeViewModel(coordinator: self))
				
			// Remote Authentication
				
			case .login:
				LoginView(viewModel: LoginViewModel(coordinator: self))
				
			// Dashboard
				
			case .dashboard:
				DashboardCoordinatorView(coordinator: DashboardCoordinator(parentCoordinator: self))
			
			// Fallback
				
			case .none:
				EmptyView()
		}
	}
}
