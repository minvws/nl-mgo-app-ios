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
	
	/// Dependency injectable Secure User Settings
	@Injected(\.secureUserSettings) private var secureUserSettings
	
	/// Dependency injectable Feature Flag Manager
	@Injected(\.featureFlagManager) private var featureFlagManager
	
	/// Dependency injectable Localization Service Client
	@Injected(\.localisationServiceClient) private var localisationServiceClient
	
	/// Dependency injectable Remote Configuration Repository
	@Injected(\.remoteConfigurationRepository) private var remoteConfigurationRepository
	
	/// Dependency injectable Notification Center
	@Injected(\.notificationCenter) private var notificationCenter
	
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
		self.observerToken = remoteConfigurationRepository.observatory.append { [weak self] remoteConfiguration in
			Task { @MainActor in
				self?.handleRemoteConfigChanges(remoteConfiguration: remoteConfiguration)
			}
		}
	}
	
	deinit {
		// Remove as observer
		observerToken.map(remoteConfigurationRepository.observatory.remove)
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
			#warning("Rool, 03/06/2024: The appstore url needs to be updated (MGO-548)")
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
		guard !handleRemoteAuthentication(action) else { return }
		guard !handleManualLocalization(action) else { return }
		guard !handleAutomaticLocalization(action) else { return }
		
		switch action.identifier {
			
			// General
				
			case Coordination.Action.closeSheet.identifier:
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
				path.append(AppCoordination.State.login)
				return true
				
			case Coordination.Action.showPrivacyStatement.identifier:
				handleUrl(LinkRepository.privacyURL, title: "privacy.heading")
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
			
				resetNavigationStack(with: AppCoordination.State.loginInfo)
				return true
			
			case Coordination.Action.nextButtonPressedOnLoginInfo.identifier:
			
				if featureFlagManager.isAutomaticLocalizationEnabled || featureFlagManager.isDemo {
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
		
		if secureUserSettings.firstTimeVisitor {
			// User must login with DigiD, but show introduction first.
			resetNavigationStack(with: AppCoordination.State.introduction)
		} else if featureFlagManager.bypassRemoteAuthentication && Configuration().getRelease() == .development {
			// Bypass the login screen
			showChildCoordinator = true
		} else {
			// Repeat login, user must authenticate with DigiD
			resetNavigationStack(with: AppCoordination.State.login)
		}
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
	
	/// Reset the navigation stack with this new root  state
	/// - Parameter state: the new root state.
	@MainActor private func resetNavigationStack(with state: AppCoordination.State) {
		// Ensure mutations to @Published properties happen on the main thread
		let performReset = {
			var transaction = Transaction()
			transaction.disablesAnimations = true
			withTransaction(transaction) {
				self.path.removeLast(self.path.count)
				self.rootState = state
			}
		}

		if Thread.isMainThread {
			performReset()
		} else {
			DispatchQueue.main.async {
				performReset()
			}
		}
	}
	
	/// Consume a deeplink
	/// - Parameter deeplink: the deeplink
	/// - Returns: true if the coordinator has consumed the deeplink
	@MainActor public func consume(_ deeplink: DeepLink) {
		
		switch deeplink {
			case .digidCallback(let userinfo):
				logInfo("Consume digidCallback with userinfo", userinfo)
				
				guard secureUserSettings.firstTimeVisitor else {
					showChildCoordinator = true
					return
				}
				
				secureUserSettings.firstTimeVisitor = false
				
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
			
			// Remote Authentication
				
			case .login:
				LoginView(
					viewModel: LoginViewModel(
						coordinator: self,
						mode: self.secureUserSettings.firstTimeVisitor ? .firstTime : .repeatVisitor,
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
//				AddOrganizationView(
//					viewModel: AddOrganizationViewModel(coordinator: self)
//				)
//				.isPresentedAsSheet(false)
				
				SearchOrganizationView(
					viewModel: SearchOrganizationViewModel(
						coordinator: self,
						firstVisitor: true
					)
				)
				.isPresentedAsSheet(false)
			
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
