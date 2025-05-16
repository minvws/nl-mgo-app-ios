/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation
import RestrictedBrowser

/// The Coordination Actions the Settings Flow uses
extension Coordination.Action {
	
	static let lockApplication = Coordination.Action(identifier: "lockApplication")
	static let openUrl = Coordination.Action(identifier: "openUrl")
	static let showAboutTheApp = Coordination.Action(identifier: "showAboutTheApp")
	static let showAccessibility = Coordination.Action(identifier: "showAccessibility")
	static let showAccessibilityMoreInformation = Coordination.Action(identifier: "showAccessibilityMoreInformation")
	static let showAdvancedSettings = Coordination.Action(identifier: "showAdvancedSettings")
	static let showDisplaySettings = Coordination.Action(identifier: "showDisplaySettings")
	static let showOpenSourceLibraries = Coordination.Action(identifier: "showOpenSourceLibraries")
	static let showSafetyTips = Coordination.Action(identifier: "showSafetyTips")
	static let showSecuritySettings = Coordination.Action(identifier: "showSecuritySettings")
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
		case aboutAccessibility
		case aboutSafetyTips
		case aboutOpenSourceLibraries
		case browser(URL)
	}
}

class SettingsCoordinator: SettingsCoordinatorProtocol {
	
	/// The navigation path
	@Published var path = NavigationStackBackport.NavigationPath()
	
	/// The parent coordinator for routing
	private weak var parentCoordinator: (any DashboardCoordinatorProtocol)?
	
	/// the browser to open allowed domains in
	private var browser: RestrictedBrowser!
	
	/// the URL for the more information page
	private var moreInformationURL: URL? {
		
		switch Configuration().getRelease() {
			case .production:
				return URL(string: String(localized: "settings.accessibility.more_information_url.prod"))
			case .demo, .acceptance:
				return URL(string: String(localized: "settings.accessibility.more_information_url.acc"))
			case .test, .development:
				return URL(string: String(localized: "settings.accessibility.more_information_url.test"))
		}
	}
	
	/// the URL for the privacy page
	private var privacyURL: URL? {
		
		switch Configuration().getRelease() {
			case .production:
				return URL(string: String(localized: "proposition.link.prod"))
			case .demo, .acceptance:
				return URL(string: String(localized: "proposition.link.acc"))
			case .test, .development:
				return URL(string: String(localized: "proposition.link.test"))
		}
	}
	
	/// Create a Settings Coordinator
	/// - Parameter parentCoordinator: the presenting parent coordinator
	/// - Parameter browser: the browser for displaying urls
	init(
		parentCoordinator: (any DashboardCoordinatorProtocol)?,
		browser: RestrictedBrowser = RestrictedBrowser(allowedDomains: Configuration().getAllowedDomains(for: Configuration().getRelease()))
	) {
		self.parentCoordinator = parentCoordinator
		self.browser = browser
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Coordination.Action) {
		
		if action.identifier == Coordination.Action.openUrl.identifier {
			
			guard action.params.count == 1,
				  let urlString = action.params["urlString"] as? String,
				  let url = URL(string: urlString) else {
				logError("SettingsCoordinator Coordinator, missing params for \(action)")
				return
			}
			if browser.isDomainAllowed(url) {
				path.append(SettingsCoordination.State.browser(url))
			} else {
				browser.handleUnallowedDomain(url)
			}
			return
		}
		
		switch action {
			case .backButtonPressed:
				path.removeLast()
			
			case .lockApplication:
				Current.notificationCenter.post(name: .showLocalAuthentication, object: nil)
			
			case .resetApplication:
				parentCoordinator?.handle(.resetApplication)
			
			case .showAboutTheApp:
				path.append(SettingsCoordination.State.aboutTheApp)
			
			case .showAccessibility:
				path.append(SettingsCoordination.State.aboutAccessibility)
			
			case .showAccessibilityMoreInformation:
				handleUrl(moreInformationURL)
			
			case .showAdvancedSettings:
				path.append(SettingsCoordination.State.advancedSettings)
			
			case .showDisplaySettings:
				path.append(SettingsCoordination.State.displaySettings)
				
			case .showOpenSourceLibraries:
				path.append(SettingsCoordination.State.aboutOpenSourceLibraries)
			
			case .showPrivacyStatement:
				handleUrl(privacyURL)
			
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
	private func handleUrl(_ url: URL?) {
		
		guard let url else { return }
		
		if browser.isDomainAllowed(url) {
			path.append(SettingsCoordination.State.browser(url))
		} else {
			browser.handleUnallowedDomain(url)
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the SettingsCoordination State
	/// - Returns: A view for that state
	@ViewBuilder func view(for state: SettingsCoordination.State?) -> some View {
		
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
			
			case .browser(let url):
				InAppBrowserView(
					viewModel: InAppBrowserViewModel(
						url: url,
						browser: self.browser,
						title: nil,
						coordinator: self
					)
				)
			
			case .displaySettings:
				DisplaySettingsView(viewModel: BaseViewModel(coordinator: self))
			
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
