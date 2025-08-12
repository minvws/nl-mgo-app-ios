/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
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
	
	/// Should we show the authentication modal?
	var showAuthenticationModal: Bool { get set }
	
	/// Should we show the child coordinator?
	var showChildCoordinator: Bool { get set }
	
	/// Get a View for the State
	/// - Parameter state: the AppCoordination State
	/// - Returns: A view for that state
	@MainActor func view(for: AppCoordination.State?) -> Body
	
	func showCloseButtonForSheet(for: AppCoordination.State?) -> Bool
}

extension Coordination.Action {
	
	// Launch
	@MainActor static let finishedSplash = Coordination.Action(identifier: "finishedSplash")
	@MainActor static let updateRequired = Coordination.Action(identifier: "updateRequired")
	@MainActor static let showAppStore = Coordination.Action(identifier: "showAppStore")
	
	// Onboarding
	@MainActor static let nextButtonPressedOnIntroduction = Coordination.Action(identifier: "nextButtonPressedOnIntroduction")
	@MainActor static let nextButtonPressedOnProposition = Coordination.Action(identifier: "nextButtonPressedOnProposition")
	@MainActor static let showPrivacyStatement = Coordination.Action(identifier: "showPrivacyStatement")
	
	// Local Authentication
	@MainActor static let pinCodeEntered = Coordination.Action(identifier: "pinCodeEntered")
	@MainActor static let pinCodeConfirmed = Coordination.Action(identifier: "pinCodeConfirmed")
	@MainActor static let didFinishLocalAuthentication = Coordination.Action(identifier: "didFinishLocalAuthentication")
	@MainActor static let pinCodeValidated = Coordination.Action(identifier: "pinCodeValidated")
	@MainActor static let pinCodeValidatedAfterLockout = Coordination.Action(identifier: "pinCodeValidatedAfterLockout")
	@MainActor static let forgotPinCode = Coordination.Action(identifier: "forgotPinCode")
	@MainActor static let dismissForgotPinCode = Coordination.Action(identifier: "dismissForgotPinCode")
	@MainActor static let recreateAccount = Coordination.Action(identifier: "recreateAccount")
	@MainActor static let restart = Coordination.Action(identifier: "restart")
	
	// Remote Authentication
	@MainActor static let loggedInWithDigiD = Coordination.Action(identifier: "loggedInWithDigiD")
	@MainActor static let deeplink = Coordination.Action(identifier: "deeplink")
	@MainActor static let nextButtonPressedOnLoginInfo = Coordination.Action(identifier: "nextButtonPressedOnLoginInfo")
	
	// Other
	@MainActor static let closeSheet = Coordination.Action(identifier: "closeSheet")
	@MainActor static let backButtonPressed = Coordination.Action(identifier: "backButtonPressed")
	@MainActor static let resetApplication = Coordination.Action(identifier: "resetApplication")
}

struct AppCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable, Sendable {
		case splash
		case updateRequired
		
		// Onboarding
		case introduction
		case proposition
		case browser(URL, String?)
		
		// Local Authentication
		case pinCodeEntry(backButtonVisible: Bool)
		case pinCodeConfirmation
		case pinCodeValidation(lockOut: Bool)
		case bioMetricSetup
		case forgotPinCode
		case accountRemoved
		
		// Remote Authentication
		case login
		case loginInfo
		
		// Automatic Localization
		case automaticLocalization
		
		// Manual Localization
		case manualLocalization
		case healthcareOrganizationSearchResults(city: String, name: String)
		
		// Dashboard
		case dashboard
	}
}
// swiftlint:disable type_body_length
final class AppCoordinator: AppCoordinatorProtocol {
	
	/// The navigation path
	@Published var path: NavigationStackBackport.NavigationPath
	
	/// The content type for the sheet
	@Published var pathForSheet: NavigationStackBackport.NavigationPath = NavigationStackBackport.NavigationPath()
	
	/// the root state for the sheet
	@Published var rootStateForSheet: AppCoordination.State?
	
	/// The state for the root view of the page
	@Published var rootState: AppCoordination.State
	
	/// Show the full screen authentication modal?
	@Published var showAuthenticationModal: Bool = false
	
	/// Should we show the child coordinator instead of ourself?
	@Published var showChildCoordinator = false
	
	/// the browser to open allowed domains in
	private var browser: RestrictedBrowser!
	
	/// Token for the observatory 
	private var observerToken: Observatory.ObserverToken?
	
	/// Are we forced into update required mode?
	private var updateRequired: Bool = false
	
	/// The coordinator for all dashboard activities
	private var dashboardCoordinator: DashboardCoordinator!
	
	/// Client for remote authentication
	private let remoteAuthenticationClient: RemoteAuthenticationClientProtocol? = {
		
		if let username = Bundle.main.infoDictionary?["MGO_BASIC_AUTH_USERNAME"] as? String,
		   let password = Bundle.main.infoDictionary?["MGO_BASIC_AUTH_PASSWORD"] as? String {
			
			return RemoteAuthenticationClient(
				serverUrl: Configuration().urlForOIDC(),
				username: username,
				password: password
			)
		}
		return RemoteAuthenticationClient(
			serverUrl: Configuration().urlForOIDC()
		)
	}()
	
	/// Dependency injectable Local authentication provider
	@Injected(\.localAuthenticationProvider) private var localAuthenticationProvider
	
	/// Dependency injectable Secure User Settings
	@Injected(\.secureUserSettings) private var secureUserSettings
	
	/// Dependency injectable Feature Flag Manager
	@Injected(\.featureFlagManager) private var featureFlagManager
	
	/// Dependency injectable Localization Service Client
	@Injected(\.localisationServiceClient) private var localisationServiceClient
	
	/// Create an AppCoordinator
	/// - Parameter path: Navigation Path
	/// - Parameter browser: the browser for displaying urls
	@MainActor init(
		path: NavigationStackBackport.NavigationPath,
		browser: RestrictedBrowser = RestrictedBrowser(
			allowedDomains: Configuration().getAllowedDomains(for: Configuration().getRelease()),
			urlOpener: UIApplication.shared
		)
	) {
		self.path = path
		self.browser = browser
		self.rootState = .splash
		self.dashboardCoordinator = DashboardCoordinator(parentCoordinator: self)
		registerObservers()
	}
	
	@MainActor private func registerObservers() {
		
		// Listen to changes in the remote configuration
		self.observerToken = Current.remoteConfigurationRepository.observatory.append { @MainActor [weak self] remoteConfiguration in
			self?.handleRemoteConfigChanges(remoteConfiguration: remoteConfiguration)
		}
		
		// Listen for authentication notification
		Current.notificationCenter.addObserver(
			self,
			selector: #selector(showLocalAuthentication),
			name: .showLocalAuthentication,
			object: nil
		)
	}
	
	@MainActor @objc private func showLocalAuthentication() {
		
		if showChildCoordinator {
			showAuthenticationModal = true
			rootStateForSheet = .pinCodeValidation(lockOut: true)
		} else {
			logInfo("Not through onboarding, not showing authentication modal")
		}
	}
	
	deinit {
		// Remove as observer
		observerToken.map(Current.remoteConfigurationRepository.observatory.remove)
	}
	
	@MainActor internal func handleRemoteConfigChanges(remoteConfiguration: RemoteConfig) {
		// Updated configuration
		
		let minimumVersion = remoteConfiguration.iosMinimumVersion.semanticVersion()
		let currentVersion = Container.shared.appVersionSupplier().getCurrentVersion().semanticVersion()
		
		logDebug("AppCoordinator: Updated config, we are \(currentVersion), minimum is \(minimumVersion)")
		
		if minimumVersion.compare(currentVersion, options: .numeric) == .orderedDescending {
			self.handle(.updateRequired)
		} else {
			updateRequired = false
		}
	}
	
	/// Handle any Coordination Action
	/// - Parameter action: Coordination Action
	@MainActor func handle(_ action: Coordination.Action) {

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
		
		guard !handleDeeplink(action) else { return }
		guard !handleOnboarding(action) else { return }
		guard !handleLocalAuthentication(action) else { return }
		guard !handleRemoteAuthentication(action) else { return }
		guard !handleManualLocalization(action) else { return }
		guard !handleAutomaticLocalization(action) else { return }
		
		switch action.identifier {
			
			// General
				
			case Coordination.Action.closeSheet.identifier,
				Coordination.Action.dismissForgotPinCode.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				
				if !showAuthenticationModal {
					rootStateForSheet = nil
				}
				
			case Coordination.Action.backButtonPressed.identifier:
				guard !path.isEmpty else { return }
				path.removeLast()
				
			case Coordination.Action.resetApplication.identifier:
				// Clear everything
				showChildCoordinator = false
				Current.wipePersistedData()
				Container.shared.wipePersistedData()
				path.removeLast(path.count)
				self.rootState = .splash
			
			default:
				logWarning("AppCoordinator does not handle \(action)")
		}
	}
	
	/// Handle the onboarding flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	@MainActor private func handleOnboarding(_ action: Coordination.Action) -> Bool {
		
		switch action.identifier {
			// Onboarding
			
			case Coordination.Action.finishedSplash.identifier:
				handleStartup()
				return true
				
			case Coordination.Action.updateRequired.identifier:
				updateRequired = true
				resetNavigationStack(with: .updateRequired)
				return true
				
			case Coordination.Action.nextButtonPressedOnIntroduction.identifier:
				path.append(AppCoordination.State.proposition)
				return true
				
			case Coordination.Action.nextButtonPressedOnProposition.identifier:
				path.append(AppCoordination.State.pinCodeEntry(backButtonVisible: true))
				return true
				
			case Coordination.Action.showPrivacyStatement.identifier:
				handleUrl(LinkRepository.privacyURL, title: "privacy.heading")
				return true
				
			default:
				return false
		}
	}
	
	/// Handle the local authentication flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	private func handleLocalAuthentication(_ action: Coordination.Action) -> Bool {
		
		switch action.identifier {
			// Local Authentication
				
			case Coordination.Action.pinCodeEntered.identifier:
				path.append(AppCoordination.State.pinCodeConfirmation)
				return true
				
			case Coordination.Action.pinCodeConfirmed.identifier:
				handlePinCodeConfirmed()
				return true
				
			case Coordination.Action.pinCodeValidated.identifier:
				handlePinCodeValidated()
				return true
			
			case Coordination.Action.pinCodeValidatedAfterLockout.identifier:
				handlePinCodeValidatedAfterLockout()
				return true
			
			case Coordination.Action.didFinishLocalAuthentication.identifier:
				resetNavigationStack(with: AppCoordination.State.login)
				return true
			
			case Coordination.Action.forgotPinCode.identifier:
				if showAuthenticationModal {
					pathForSheet.append(AppCoordination.State.forgotPinCode)
				} else {
					rootStateForSheet = AppCoordination.State.forgotPinCode
				}
				return true
				
			case Coordination.Action.recreateAccount.identifier:
				handleRecreateAccount()
				return true
			
			case Coordination.Action.restart.identifier:
				restart()
				return true
				
			default:
				return false
		}
	}
	
	/// Handle the remote authentication flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	@MainActor private func handleRemoteAuthentication(_ action: Coordination.Action) -> Bool {
		
		switch action.identifier {
			// Remote Authentication
				
			case Coordination.Action.loggedInWithDigiD.identifier:
				secureUserSettings.userHasRemoteAuthentication = true
			
				resetNavigationStack(with: AppCoordination.State.loginInfo)
				return true
			
			case Coordination.Action.nextButtonPressedOnLoginInfo.identifier:
			
				if featureFlagManager.isAutomaticLocalizationEnabled {
					resetNavigationStack(with: AppCoordination.State.automaticLocalization)
				} else {
					resetNavigationStack(with: AppCoordination.State.manualLocalization)
				}
				return true
			
			default:
				return false
		}
	}

	/// Handle the deeplink flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	@MainActor private func handleDeeplink(_ action: Coordination.Action) -> Bool {
		
		if action.identifier == Coordination.Action.deeplink.identifier {
			if action.params.count == 1,
			   let deeplinkUrl = action.params["deeplink"] as? URL {
				if let deepLink = DeepLinkFactory().create(deeplinkUrl) {
					consume(deepLink)
				}
			} else {
				logError("App Coordinator, missing params for \(action)")
			}
			return true
		}
		return false
	}
	
	/// Handle the automatic localization flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	@MainActor private func handleAutomaticLocalization(_ action: Coordination.Action) -> Bool {
		
		if action.identifier == Coordination.Action.finishedSearchingHealthcareOrganizations.identifier {
			showChildCoordinator = true
			return true
		}
		return false
	}
	
	/// Handle the manual localization flow action from any of the view models
	/// - Parameter action: any Action
	/// - Returns: True if the action is consumed
	@MainActor private func handleManualLocalization(_ action: Coordination.Action) -> Bool {
		
		if action.identifier == Coordination.Action.showHealthcareOrganizationSearchResults.identifier {
			if action.params.count == 2,
			   let city = action.params["city"] as? String,
			   let name = action.params["name"] as? String {
				path.append(AppCoordination.State.healthcareOrganizationSearchResults(city: city, name: name))
			} else {
				logError("Dashboard Coordinator, missing params for \(action)")
			}
			return true
		}
		if action.identifier == Coordination.Action.backToAddHealthcareOrganization.identifier {
			path.removeLast()
			return true
		}
		
		return false
	}
	
	/// Handle the complex startup logic
	@MainActor private func handleStartup() {
		
		if secureUserSettings.pinCode == nil {
			// User must set an pin code, but show introduction first.
			resetNavigationStack(with: AppCoordination.State.introduction)
		} else if featureFlagManager.bypassPincode && Configuration().getRelease() == .development {
			// Bypass the pin code screen
			showChildCoordinator = true
		} else {
			// Repeat login, user must authenticate with pin code
			resetNavigationStack(with: AppCoordination.State.pinCodeValidation(lockOut: false))
		}
	}
	
	/// Handle the pin code confirmed action
	private func handlePinCodeConfirmed() {
		
		if localAuthenticationProvider.biometricType() == .none {
			resetNavigationStack(with: AppCoordination.State.login)
		} else {
			resetNavigationStack(with: AppCoordination.State.bioMetricSetup)
		}
	}
	
	/// Handle the pincode validated action
	private func handlePinCodeValidated() {
		
		guard secureUserSettings.userHasRemoteAuthentication else {
			resetNavigationStack(with: AppCoordination.State.login)
			return
		}
		showChildCoordinator = true
	}
	
	/// Handle the pincode validated action after lockout
	private func handlePinCodeValidatedAfterLockout() {
		
		showAuthenticationModal = false
		rootStateForSheet = nil
		pathForSheet = NavigationStackBackport.NavigationPath()
		secureUserSettings.enteredBackground = nil
	}
	
	/// Handle displaying urls
	/// - Parameter url: the url to show
	/// - Parameter title: the title of the page
	@MainActor private func handleUrl(_ url: URL?, title: String? = nil) {
		
		guard let url else { return }
		
		if browser.isDomainAllowed(url) {
			rootStateForSheet = AppCoordination.State.browser(url, title)
		} else {
			browser.handleUnallowedDomain(url)
		}
	}
	
	/// handle the account recreate action
	private func handleRecreateAccount() {
		
		pathForSheet = NavigationStackBackport.NavigationPath()

		// Wipe Account
		Current.wipePersistedData()
		Container.shared.wipePersistedData()
		
		if showAuthenticationModal {
			showChildCoordinator = false
			showAuthenticationModal = false
			rootStateForSheet = nil
			resetNavigationStack(with: AppCoordination.State.accountRemoved)
		} else {
			// Show account removed in a sheet
			rootStateForSheet = .accountRemoved
			resetNavigationStack(with: AppCoordination.State.pinCodeEntry(backButtonVisible: false))
		}
	}
	
	private func restart() {
		
		rootStateForSheet = nil
		pathForSheet = NavigationStackBackport.NavigationPath()
		showChildCoordinator = false
		resetNavigationStack(with: AppCoordination.State.pinCodeEntry(backButtonVisible: false))
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
	
	/// Consume a deeplink
	/// - Parameter deeplink: the deeplink
	/// - Returns: true if the coordinator has consumed the deeplink
	@MainActor public func consume(_ deeplink: DeepLink) {
		
		switch deeplink {
			case .digidCallback(let userinfo):
				logInfo("Consume digidCallback with userinfo", userinfo)
				secureUserSettings.userHasRemoteAuthentication = true
				if featureFlagManager.isAutomaticLocalizationEnabled {
					resetNavigationStack(with: AppCoordination.State.automaticLocalization)
				} else {
					resetNavigationStack(with: AppCoordination.State.manualLocalization)
				}
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the AppCoordination State
	/// - Returns: A view for that state
	@ViewBuilder @MainActor func view(for state: AppCoordination.State?) -> some View {
		
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
			
			case .browser(let url, let title):
				InAppBrowserView(
					viewModel: InAppBrowserViewModel(
						url: url,
						browser: self.browser,
						title: LocalizedStringKey(stringLiteral: title ?? ""),
						coordinator: self,
						closeAction: .closeSheet
					)
				)
			
			// Local Authentication
				
			case let .pinCodeEntry(backButtonVisible):
				PinCodeView(
					viewModel: PinCodeViewModel(
						coordinator: self,
						mode: .creation,
						backButtonVisible: backButtonVisible,
						bioMetricType: self.localAuthenticationProvider.biometricType
					)
				)
				
			case .pinCodeConfirmation:
				PinCodeView(
					viewModel: PinCodeViewModel(
						coordinator: self,
						mode: .confirmation,
						bioMetricType: self.localAuthenticationProvider.biometricType
					)
				)
				
			case let .pinCodeValidation(lockOut):
				PinCodeView(
					viewModel: PinCodeViewModel(
						coordinator: self,
						mode: .validation(lockOut: lockOut),
						bioMetricType: self.localAuthenticationProvider.biometricType
					)
				)
				
			case .bioMetricSetup:
				BioMetricSetupView(
					viewModel: BioMetricSetupViewModel(
						coordinator: self,
						bioMetricType: self.localAuthenticationProvider.biometricType
					)
				)
				
			case .forgotPinCode:
				ForgotPinCodeView(viewModel: ForgotPinCodeViewModel(coordinator: self))
			
			case .accountRemoved:
				AccountRemovedView(viewModel: AccountRemovedViewModel(coordinator: self))
				
			// Remote Authentication
				
			case .login:
				LoginView(
					viewModel: LoginViewModel(
						coordinator: self,
						remoteAuthenticationClient: self.remoteAuthenticationClient
					)
				)
				
			case .loginInfo:
				LoginInfoView(viewModel: LoginInfoViewModel(coordinator: self))
				
			// Automatic Localization
			
			case .automaticLocalization:
				OrganizationListAutomaticView(
					viewModel: OrganizationListAutomaticViewModel(
						coordinator: self,
						localisationServiceClient: self.localisationServiceClient,
						preselectAllOrganizations: true
					)
				)
			
			// Manual Localization
			case .manualLocalization:
				AddOrganizationView(viewModel: AddOrganizationViewModel(coordinator: self))
			
			case let .healthcareOrganizationSearchResults(city, name):
				OrganizationListManualView(
					viewModel: OrganizationListManualViewModel(
						coordinator: self,
						city: city,
						name: name,
						localisationServiceClient: self.localisationServiceClient
					)
				)
			
			// Dashboard
				
			case .dashboard:
				DashboardCoordinatorView(coordinator: dashboardCoordinator)
			
			// Fallback
				
			case .none:
				EmptyView()
		}
	}
	
	/// Should we show a close button for this sheet
	/// - Parameter state: the state
	/// - Returns: True if we should show a close button
	func showCloseButtonForSheet(for state: AppCoordination.State?) -> Bool {
		
		if case .browser = state {
			return false
		}
		return true
	}
}
// swiftlint: enable type_body_length
