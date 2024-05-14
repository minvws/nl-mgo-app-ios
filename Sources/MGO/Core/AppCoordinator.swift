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

enum AppCoordination {
	
	/// A list of all the action an app coordinator can do
	enum Action: Equatable {
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
		case dismissForgotAccessCode
		case recreateAccount
		
		// Remote Authentication
		case loginWithDigiD
		case loginWithAccessCode
		
		// Healthcare Provider flow
		case search(city: String, name: String)
		case backToSearchHealthcareProvider
		case storeHealthcareProvider
		case finishedSearchingHealthcareProviders
		case searchHealthcareProvidersInSheet
		
		// Dashboard
		case fhirClient
		case searchHealthcareProviders
		
		// Other
		case sheetClosed
		case backButtonPressed
		case resetApplication
	}
	
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
		
		// POC
		case fhirClient
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
	
	func handle(_ action: Any) {
		if let castedAction = action as? AppCoordination.Action {
			switch castedAction {
				// Onboarding
				
				case .finishedLoading:
					
					if !Current.secureUserSettings.userHasSeenAppIntroduction {
						// Only show the appIntroduction once
						path.append(AppCoordination.State.appIntroduction)
					} else if Current.secureUserSettings.accessCode == nil {
						path.append(AppCoordination.State.accessCodeEntry)
						
					} else {
						path.append(AppCoordination.State.accessCodeValidation)
					}
				case .nextButtonPressedOnAppIntroduction:
					path.append(AppCoordination.State.privacyOverview)
					
				case .nextButtonPressedOnPrivacyOverview:
					// Mark AppIntroduction Flow as seen.
					Current.secureUserSettings.userHasSeenAppIntroduction = true
					path.append(AppCoordination.State.accessCodeEntry)
					
				case .showPrivacyStatement:
					
					guard let privacyURL else { return }
					
					if browser.isDomainAllowed(privacyURL) {
						path.append(AppCoordination.State.privacyStatement)
					} else {
						browser.handleUnallowedDomain(privacyURL)
					}
					
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
					showChildCoordinator = true
					//				path.append(AppCoordination.State.dashboard)
					
				case .didFinishLocalAuthentication:
					path.append(AppCoordination.State.remoteAuthentication)
					
				case .forgotAccessCode:
					rootStateForSheet = AppCoordination.State.forgotAccessCode
					
				case .recreateAccount:
					if rootStateForSheet != nil {
						rootStateForSheet = nil
						pathForSheet = NavigationStackBackport.NavigationPath()
					}
					// Wipe Account
					Current.wipePersistedData()
					Current.secureUserSettings.userHasSeenAppIntroduction = true
					path = NavigationStackBackport.NavigationPath([AppCoordination.State.accessCodeEntry])
					
					// Remote Authentication
					
				case .loginWithDigiD:
					
					Current.secureUserSettings.userHasRemoteAuthentication = true
					path.append(AppCoordination.State.searchHealthcareProvider)
					
				case .loginWithAccessCode:
					path.append(AppCoordination.State.accessCodeValidation)
					
					// Healthcare Provider flow
				case let .search(city, name):
					path.append(AppCoordination.State.searchHealthcareProviders(city: city, name: name))
					
				case .backToSearchHealthcareProvider:
					navigateTo(state: .searchHealthcareProvider)
					
				case .finishedSearchingHealthcareProviders:
					showChildCoordinator = true
					//				navigateTo(state: .dashboard)
					
				case .searchHealthcareProvidersInSheet:
					rootStateForSheet = AppCoordination.State.searchHealthcareProvider
					
					// Dashboard
					
				case .fhirClient:
					path.append(AppCoordination.State.fhirClient)
					
				case .searchHealthcareProviders:
					path.append(AppCoordination.State.searchHealthcareProvider)
					
				case .storeHealthcareProvider:
					path.append(AppCoordination.State.storedHealthcareProviders)
					
					// General
					
				case .sheetClosed, .dismissForgotAccessCode:
					
					pathForSheet = NavigationStackBackport.NavigationPath()
					rootStateForSheet = nil
					
				case .backButtonPressed:
					guard !path.isEmpty else { return }
					path.removeLast()
					
				case .resetApplication:
					// Clear everything
					showChildCoordinator = false
					Current.wipePersistedData()
					path.removeLast(path.count)
					Current.notificationCenter.post(name: .resetApplication, object: nil)
			}
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
				
				// POC
				
			case .fhirClient:
				PatientView(viewModel: PatientViewModel(coordinator: self))
				
				// Fallback
				
			case .none:
				EmptyView()
		}
	}
}
