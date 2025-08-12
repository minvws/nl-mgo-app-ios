/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import RestrictedBrowser

/// The Coordination Actions the Settings Flow uses
extension Coordination.Action {
	
	@MainActor static let lockApplication = Coordination.Action(identifier: "lockApplication")
	@MainActor static let openUrl = Coordination.Action(identifier: "openUrl")
	@MainActor static let showAboutTheApp = Coordination.Action(identifier: "showAboutTheApp")
	@MainActor static let showAccessibility = Coordination.Action(identifier: "showAccessibility")
	@MainActor static let showAdvancedSettings = Coordination.Action(identifier: "showAdvancedSettings")
	@MainActor static let showDisplaySettings = Coordination.Action(identifier: "showDisplaySettings")
	@MainActor static let showOpenSourceLibraries = Coordination.Action(identifier: "showOpenSourceLibraries")
	@MainActor static let showSafetyTips = Coordination.Action(identifier: "showSafetyTips")
	@MainActor static let showSecuritySettings = Coordination.Action(identifier: "showSecuritySettings")
}

protocol SettingsCoordinatorProtocol: Coordinator, ObservableObject {
	
	associatedtype Body: View
	
	/// The navigation path
	var path: NavigationStackBackport.NavigationPath { get set }
	
	/// The content type for the sheet
	var pathForSheet: NavigationStackBackport.NavigationPath { get set }
	
	/// The state for the root view of the sheet
	var rootStateForSheet: SettingsCoordination.State? { get set }
	
	/// Get a View for the State
	/// - Parameter state: the DashboardCoordination State
	/// - Returns: A view for that state
	@MainActor func view(for state: SettingsCoordination.State?) -> Body
}

struct SettingsCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable, Sendable {
		
		case settings
		case displaySettings
		case securitySettings
		case advancedSettings
		case aboutTheApp
		case aboutAccessibility
		case aboutSafetyTips
		case aboutOpenSourceLibraries
		case browser(URL, String?)
	}
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
	
	/// The navigation path
	@Published var path = NavigationStackBackport.NavigationPath()
	
	/// The navigation path for the sheet.
	@Published var pathForSheet = NavigationStackBackport.NavigationPath()
	
	/// The root state for a sheet.
	@Published var rootStateForSheet: SettingsCoordination.State?
	
	/// The parent coordinator for routing
	private weak var parentCoordinator: (any DashboardCoordinatorProtocol)?
	
	/// the browser to open allowed domains in
	private var browser: RestrictedBrowser!
	
	/// Dependency injectable Local authentication provider
	@Injected(\.localAuthenticationProvider) private var localAuthenticationProvider
	
	/// Dependency injectable Notification Center
	@Injected(\.notificationCenter) private var notificationCenter
	
	/// Create a Settings Coordinator
	/// - Parameter parentCoordinator: the presenting parent coordinator
	/// - Parameter browser: the browser for displaying urls
	@MainActor init(
		parentCoordinator: (any DashboardCoordinatorProtocol)?,
		browser: RestrictedBrowser = RestrictedBrowser(
			allowedDomains: Configuration().getAllowedDomains(for: Configuration().getRelease()),
			urlOpener: UIApplication.shared
		)
	) {
		self.parentCoordinator = parentCoordinator
		self.browser = browser
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	@MainActor func handle(_ action: Coordination.Action) {
		
		if action.identifier == Coordination.Action.openUrl.identifier {
			
			guard action.params.count == 1,
				  let urlString = action.params["urlString"] as? String,
				  let url = URL(string: urlString) else {
				logError("SettingsCoordinator Coordinator, missing params for \(action)")
				return
			}
			if browser.isDomainAllowed(url) {
				path.append(SettingsCoordination.State.browser(url, nil))
			} else {
				browser.handleUnallowedDomain(url)
			}
			return
		}
		
		switch action {
			
			case .closeSheet:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
			
			case .backButtonPressed:
				path.removeLast()
			
			case .lockApplication:
				notificationCenter.post(name: .showLocalAuthentication, object: nil)
			
			case .resetApplication:
				parentCoordinator?.handle(.resetApplication)
			
			case .showAboutTheApp:
				path.append(SettingsCoordination.State.aboutTheApp)
			
			case .showAccessibility:
				path.append(SettingsCoordination.State.aboutAccessibility)
			
			case .showAdvancedSettings:
				path.append(SettingsCoordination.State.advancedSettings)
			
			case .showDisplaySettings:
				path.append(SettingsCoordination.State.displaySettings)
				
			case .showOpenSourceLibraries:
				path.append(SettingsCoordination.State.aboutOpenSourceLibraries)
			
			case .showPrivacyStatement:
				handleUrl(LinkRepository.privacyURL, title: "privacy.heading")
			
			case .showSecuritySettings:
				path.append(SettingsCoordination.State.securitySettings)
			
			case .showSafetyTips:
				path.append(SettingsCoordination.State.aboutSafetyTips)
			
			default:
				logWarning("Settings Coordinator does not handle \(action)")
		}
	}
	
	/// Handle displaying urls
	/// - Parameter url: the url to show
	@MainActor private func handleUrl(_ url: URL?, title: String? = nil) {
		
		guard let url else { return }
		
		if browser.isDomainAllowed(url) {
			rootStateForSheet = SettingsCoordination.State.browser(url, title)
		} else {
			browser.handleUnallowedDomain(url)
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the SettingsCoordination State
	/// - Returns: A view for that state
	@MainActor @ViewBuilder func view(for state: SettingsCoordination.State?) -> some View {
		
		switch state {
			
			case .aboutTheApp:
				AboutTheAppView(
					viewModel: AboutTheAppViewModel(coordinator: self)
				)
			
			case .aboutAccessibility:
				AboutAccessibilityView(
					viewModel: AboutAccessibilityViewModel(coordinator: self)
				)
			
			case .aboutSafetyTips:
				AboutSafetyTipsView(
					viewModel: BaseViewModel(coordinator: self)
				)
			
			case .aboutOpenSourceLibraries:
				AboutOpenSourceLibrariesView(
					viewModel: AboutOpenSourceLibrariesViewModel(coordinator: self)
				)
			
			case .advancedSettings:
				AdvancedSettingsView(
					viewModel: AdvancedSettingsViewModel(coordinator: self)
				)
			
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
			
			case .displaySettings:
				DisplaySettingsView(viewModel: BaseViewModel(coordinator: self))
			
			case .securitySettings:
				SecuritySettingsView(
					viewModel: SecuritySettingsViewModel(
						coordinator: self,
						bioMetricType: self.localAuthenticationProvider.biometricType
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
