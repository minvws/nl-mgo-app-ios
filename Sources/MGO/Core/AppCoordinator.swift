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
	static let updateRequired = Coordination.Action(identifier: "updateRequired")
	static let showAppStore = Coordination.Action(identifier: "showAppStore")
	
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
	static let restart = Coordination.Action(identifier: "restart")
	
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
		case splash
		case updateRequired
		
		// Onboarding
		case introduction
		case proposition
		case privacyStatement
		
		// Local Authentication
		case pinCodeEntry
		case pinCodeConfirmation
		case pinCodeValidation
		case bioMetricSetup
		case forgotPinCode
		case accountRemoved
		
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
	private var browser: RestrictedBrowser!
	
	/// Token for the observatory 
	private var observerToken: Observatory.ObserverToken?
	
	/// The version supplier
	private var versionSupplier: AppVersionSupplierProtocol!
	
	/// Are we forced into update required mode?
	private var updateRequired: Bool = false
	
	private var dashboardCoordinator: DashboardCoordinator!
	
	/// Initializer
	/// - Parameter path: Navigation Path
	init(
		path: NavigationStackBackport.NavigationPath,
		versionSupplier: AppVersionSupplierProtocol = AppVersionSupplier(),
		browser: RestrictedBrowser = RestrictedBrowser(allowedDomains: Configuration().getAllowedDomains(for: Configuration().getRelease()))
	) {
		self.path = path
		self.versionSupplier = versionSupplier
		self.browser = browser
		self.rootState = .splash
		self.dashboardCoordinator = DashboardCoordinator(parentCoordinator: self)
		registerObservers()
	}
	
	private func registerObservers() {
		
		// Listen to changes in the remote configuration
		
		self.observerToken = Current.remoteConfigurationRepository.observatory.append { [weak self] remoteConfiguration in
			
			guard let self else { return }
			_Concurrency.Task { @MainActor in
				self.handleRemoteConfigChanges(remoteConfiguration: remoteConfiguration)
			}
		}
	}
	
	deinit {
		// Remove as observer
		observerToken.map(Current.remoteConfigurationRepository.observatory.remove)
	}
	
	internal func handleRemoteConfigChanges(remoteConfiguration: RemoteConfig) {
		// Updated configuration
		
		let minimumVersion = remoteConfiguration.iosMinimumVersion.semanticVersion()
		let currentVersion = versionSupplier.getCurrentVersion().semanticVersion()
		
		logDebug("AppCoordinator: Updated config, we are \(currentVersion), minimum is \(minimumVersion)")
		
		if minimumVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
			self.handle(.updateRequired)
		} else {
			updateRequired = false
		}
	}
	
	/// the URL for the privacy page
	private var privacyURL: URL? {
		
		switch Configuration().getRelease() {
			case .production:
				return URL(string: String(localized: "proposition.link.prod"))
			case .acceptance:
				return URL(string: String(localized: "proposition.link.acc"))
			case .test, .development:
				return URL(string: String(localized: "proposition.link.test"))
		}
	}
	
	/// Handle any Coordination Action
	/// - Parameter action: Coordination Action
	func handle(_ action: Coordination.Action) {

		// Always allow the update app action
		if action.identifier == Coordination.Action.showAppStore.identifier {
			#warning("The appstore url needs to be updated (MGO-548)")
			guard let appStoreUrl = URL(string: "https://apps.apple.com") else { return }
			browser.handleUnallowedDomain(appStoreUrl)
			return
		}
		
		guard !updateRequired else {
			logWarning("AppCoordinator: Skipping \(action), update is required")
			return
		}
		
		switch action.identifier {
			// Onboarding
			
			case Coordination.Action.finishedLoading.identifier:
				handleStartup()
			
			case Coordination.Action.updateRequired.identifier:
				updateRequired = true
				resetNavigationStack(with: .updateRequired)
			
			case Coordination.Action.nextButtonPressedOnIntroduction.identifier:
				path.append(AppCoordination.State.proposition)
				
			case Coordination.Action.nextButtonPressedOnProposition.identifier:
				// Mark AppIntroduction Flow as seen.
				Current.secureUserSettings.userHasSeenAppIntroduction = true
				resetNavigationStack(with: AppCoordination.State.pinCodeEntry)
				
			case Coordination.Action.showPrivacyStatement.identifier:
				handleShowPrivacyStatement()
				
			// Local Authentication
				
			case Coordination.Action.pinCodeEntered.identifier:
				path.append(AppCoordination.State.pinCodeConfirmation)
				
			case Coordination.Action.pinCodeConfirmed.identifier:
				handlePinCodeConfirmed()
				
			case Coordination.Action.pinCodeValidated.identifier:
				handlePinCodeValidated()
				
			case Coordination.Action.didFinishLocalAuthentication.identifier:
				resetNavigationStack(with: AppCoordination.State.login)
				
			case Coordination.Action.forgotPinCode.identifier:
				rootStateForSheet = AppCoordination.State.forgotPinCode
				
			case Coordination.Action.recreateAccount.identifier:
				handleRecreateAccount()
			
			case Coordination.Action.restart.identifier:
				restart()
				
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
				self.rootState = .splash
				Current.notificationCenter.post(name: .resetApplication, object: nil)
			
			default:
				logWarning("AppCoordinator does not handle \(action)")
		}
	}
	
	/// Handle the complex startup logic
	private func handleStartup() {
		
		if !Current.secureUserSettings.userHasSeenAppIntroduction {
			// Only show the appIntroduction once
			resetNavigationStack(with: AppCoordination.State.introduction)
		} else if Current.secureUserSettings.pinCode == nil {
			// User must set an pin code, but show introduction first.
			resetNavigationStack(with: AppCoordination.State.introduction)
		} else {
			// Repeat login, user must authenticate with pin code
			resetNavigationStack(with: AppCoordination.State.pinCodeValidation)
		}
	}
	
	/// Handle the pin code confirmed action
	private func handlePinCodeConfirmed() {
		
		if Current.localAuthenticationProvider.biometricType() == .none {
			resetNavigationStack(with: AppCoordination.State.login)
		} else {
			resetNavigationStack(with: AppCoordination.State.bioMetricSetup)
		}
	}
	
	/// Handle the pincode validated action
	private func handlePinCodeValidated() {
		guard Current.secureUserSettings.userHasRemoteAuthentication else {
			resetNavigationStack(with: AppCoordination.State.login)
			return
		}
		showChildCoordinator = true
	}
	
	/// Handle the show Privacy statement action
	private func handleShowPrivacyStatement() {
	
		guard let privacyURL else { return }
		
		if browser.isDomainAllowed(privacyURL) {
			path.append(AppCoordination.State.privacyStatement)
		} else {
			browser.handleUnallowedDomain(privacyURL)
		}
	}
	
	/// handle the account recreate action
	private func handleRecreateAccount() {
		
		if rootStateForSheet != nil {
			rootStateForSheet = nil
			pathForSheet = NavigationStackBackport.NavigationPath()
		}
		// Wipe Account
		Current.wipePersistedData()
		
		rootState = .accountRemoved
	}
	
	private func restart() {
		
		resetNavigationStack(with: AppCoordination.State.introduction)
	}
	
	/// Reset the navigation stack with this new root  state
	/// - Parameter state: the new root state.
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
			case .splash:
				SplashView(viewModel: SplashViewModel(coordinator: self))
			
			case .updateRequired:
				UpdateRequiredView(viewModel: UpdateRequiredViewModel(coordinator: self))
				
			// Onboarding
				
			case .introduction:
				IntroductionView(viewModel: IntroductionViewModel(coordinator: self))
				
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
			
			case .accountRemoved:
				AccountRemovedView(viewModel: AccountRemovedViewModel(coordinator: self))
				
			// Remote Authentication
				
			case .login:
				LoginView(viewModel: LoginViewModel(coordinator: self))
				
			// Dashboard
				
			case .dashboard:
				DashboardCoordinatorView(coordinator: dashboardCoordinator)
			
			// Fallback
				
			case .none:
				EmptyView()
		}
	}
}
