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
		case appIntroduction
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
		
		// Healthcare Provider flow
		case searchHealthcareProvider
		case searchHealthcareProviders(city: String, name: String)
		case storedHealthcareProviders
		
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
	
	/// Should we show the child coordinator instead of ourself?
	@Published var showChildCoordinator = false
	
	/// the browser to open allowed domains in
	private var browser = RestrictedBrowser(allowedDomains: Configuration().getAllowedDomains())
	
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
				path.append(AppCoordination.State.accessCodeEntry)
				
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
				path.append(AppCoordination.State.remoteAuthentication)
				
			case Coordination.Action.forgotAccessCode.identifier:
				rootStateForSheet = AppCoordination.State.forgotAccessCode
				
			case Coordination.Action.recreateAccount.identifier:
				if rootStateForSheet != nil {
					rootStateForSheet = nil
					pathForSheet = NavigationStackBackport.NavigationPath()
				}
				// Wipe Account
				Current.wipePersistedData()
				Current.secureUserSettings.userHasSeenAppIntroduction = true
				path = NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeEntry])
				
				// Remote Authentication
				
			case Coordination.Action.loggedInWithDigiD.identifier:
				
				Current.secureUserSettings.userHasRemoteAuthentication = true
				showChildCoordinator = true
				
			// Healthcare Provider flow
			
			case Coordination.Action.search.identifier:
				if action.params.count == 2,
				   let city = action.params["city"] as? String,
				   let name = action.params["name"] as? String {
					path.append(AppCoordination.State.searchHealthcareProviders(city: city, name: name))
				} else {
					logError("AppCoordinator Coordinator, missing params for \(action)")
				}
				
			case Coordination.Action.backToSearchHealthcareProvider.identifier:
				navigateTo(state: .searchHealthcareProvider)
				
			case Coordination.Action.finishedSearchingHealthcareProviders.identifier:
				showChildCoordinator = true
				
			case Coordination.Action.storeHealthcareProvider.identifier:
				path.append(AppCoordination.State.storedHealthcareProviders)
				
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
			path.append(AppCoordination.State.appIntroduction)
		} else if Current.secureUserSettings.accessCode == nil {
			// User must set an access code
			path.append(AppCoordination.State.accessCodeEntry)
		} else {
			// Repeat login, user must authenticate with access code
			path.append(AppCoordination.State.accessCodeValidation)
		}
	}
	
//	/// Handle the access code validated state
//	private func handleAccessCodeValidated() {
//		
////		if !Current.secureUserSettings.userHasAddedHealthcareProvider {
////			// User must add at least once a healthcare provider
////			path.append(AppCoordination.State.searchHealthcareProvider)
////		} else {
//			showChildCoordinator = true
////		}
//	}
	
	/// Handle the access code confirmed state
	private func handleAccessCodeConfirmed() {
		
		if Current.localAuthenticationProvider.biometricType() == .none {
			path.append(AppCoordination.State.remoteAuthentication)
		} else {
			path.append(AppCoordination.State.bioMetricSetup)
		}
	}
	
	/// Navigate back to the state if present in the stack, else append to the stack
	/// - Parameter state: the desired state
	private func navigateTo(state: AppCoordination.State) {
		
		if let index = path.indexOf(state) {
			let elementsToBeRemoved = path.count - index - 1
			logDebug("AppCoordinator navigateTo \(state) - index: \(index), count: \(path.count), toBeRemoved: \(elementsToBeRemoved)")
			if elementsToBeRemoved >= 0 {
				path.removeLast(elementsToBeRemoved)
				return
			}
		}
		path.append(state)
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
				
			// Healthcare Provider flow
				
			case .searchHealthcareProvider:
				SearchView(viewModel: SearchViewModel(coordinator: self))
				
			case let .searchHealthcareProviders(city, name):
				SearchResultsView(viewModel: SearchResultsViewModel(coordinator: self, city: city, name: name, localisationServiceClient: self.localisationServiceClient))
				
			case .storedHealthcareProviders:
				StoredHealthcareProvidersView(viewModel: StoredHealthcareProvidersViewModel(coordinator: self))
				
			// Fallback
				
			case .none:
				EmptyView()
		}
	}
}
