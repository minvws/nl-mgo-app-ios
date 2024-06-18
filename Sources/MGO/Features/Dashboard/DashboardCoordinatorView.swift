/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

extension Coordination.Action {
	static let searchHealthcareProviders = Coordination.Action(identifier: "searchHealthcareProviders")
	static let showHealthcareProviderDetails = Coordination.Action(identifier: "showHealthcareProviderDetails")
	
	static let showProblems = Coordination.Action(identifier: "showProblems")
	static let showMedication = Coordination.Action(identifier: "showMedication")
	static let showLabResults = Coordination.Action(identifier: "showLabResults")
	static let removeHealthcareOrganization = Coordination.Action(identifier: "removeHealthcareOrganization")
}

protocol DashboardCoordinatorProtocol: Coordinator, ObservableObject {
	
	associatedtype Body: View
	
	/// The navigation path for the first tab
	var firstTabPath: NavigationStackBackport.NavigationPath { get set }

	/// The navigation path for the second tab
	var secondTabPath: NavigationStackBackport.NavigationPath { get set }
	
	/// The content type for the sheet
	var pathForSheet: NavigationStackBackport.NavigationPath { get set }
	
	/// The state for the root view of the sheet
	var rootStateForSheet: DashboardCoordination.State? { get set }
	
	/// Get a View for the State
	/// - Parameter state: the DashboardCoordination State
	/// - Returns: A view for that state
	func viewState(for: DashboardCoordination.State?) -> Body
}

enum DashboardCoordination {
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable {
		
		case aboutTheApp
		case overview
		
		// Search & Store Healthcare Provider flow
		case searchHealthcareProvider
		case searchHealthcareProviders(city: String, name: String)
		case storedHealthcareProviders
		
		// Details Flow
		case showHealthcareProviderDetails(healthcareProvider: HealthcareProvider)
		case showProblems(healthcareProvider: HealthcareProvider)
		case showMedication(healthcareProvider: HealthcareProvider)
		case showLabResults(healthcareProvider: HealthcareProvider)
		case removeHealthcareOrganization(healthcareOrganization: HealthcareProvider)
	}
}

class DashboardCoordinator: DashboardCoordinatorProtocol {
	
	/// The navigation path for the first tab
	@Published var firstTabPath = NavigationStackBackport.NavigationPath()

	/// The navigation path for the second tab
	@Published var secondTabPath = NavigationStackBackport.NavigationPath()

	/// The navigation path for the sheet.
	@Published var pathForSheet = NavigationStackBackport.NavigationPath()
	
	/// The root state for a sheet.
	@Published var rootStateForSheet: DashboardCoordination.State?
	
	/// The flow coordinator for routing
	private weak var parentCoordinator: (any AppCoordinatorProtocol)?
	
	/// Initializer
	/// - Parameter coordinator: the coordinator
	init(parentCoordinator: (any AppCoordinatorProtocol)?) {
		self.parentCoordinator = parentCoordinator
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Coordination.Action) {
		
		switch action.identifier {
			
			// Healthcare Provider Search Flow
			
			case Coordination.Action.searchHealthcareProviders.identifier:
				rootStateForSheet = DashboardCoordination.State.searchHealthcareProvider
				
			case Coordination.Action.search.identifier:
				if action.params.count == 2,
					let city = action.params["city"] as? String,
					let name = action.params["name"] as? String {
					pathForSheet.append(DashboardCoordination.State.searchHealthcareProviders(city: city, name: name))
				} else {
					logError("Dashboard Coordinator, missing params for \(action)")
				}
					
			case Coordination.Action.storeHealthcareProvider.identifier:
				pathForSheet.append(DashboardCoordination.State.storedHealthcareProviders)
			
			case Coordination.Action.backToSearchHealthcareProvider.identifier:
				pathForSheet.removeLast(pathForSheet.count)
			
			case Coordination.Action.finishedSearchingHealthcareProviders.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
			
			// Healthcare Provider Details
			
			case Coordination.Action.showHealthcareProviderDetails.identifier:
				if action.params.count == 1,
				   let healthcareProvider = action.params["healthcareProvider"] as? HealthcareProvider {
					firstTabPath.append(DashboardCoordination.State.showHealthcareProviderDetails(healthcareProvider: healthcareProvider))
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
			
			case Coordination.Action.showProblems.identifier:
				if action.params.count == 1,
				   let healthcareProvider = action.params["healthcareProvider"] as? HealthcareProvider {
					firstTabPath.append(DashboardCoordination.State.showProblems(healthcareProvider: healthcareProvider))
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
			
			case Coordination.Action.showMedication.identifier:
				if action.params.count == 1,
				   let healthcareProvider = action.params["healthcareProvider"] as? HealthcareProvider {
					firstTabPath.append(DashboardCoordination.State.showMedication(healthcareProvider: healthcareProvider))
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}
	
			case Coordination.Action.showLabResults.identifier:
				if action.params.count == 1,
				   let healthcareProvider = action.params["healthcareProvider"] as? HealthcareProvider {
					firstTabPath.append(DashboardCoordination.State.showLabResults(healthcareProvider: healthcareProvider))
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}

			case Coordination.Action.removeHealthcareOrganization.identifier:
				if action.params.count == 1,
				   let healthcareOrganization = action.params["healthcareOrganization"] as? HealthcareProvider {
				
					rootStateForSheet = DashboardCoordination.State.removeHealthcareOrganization(healthcareOrganization: healthcareOrganization)
					
				} else {
					logError("DashboardCoordinator Coordinator, missing params for \(action)")
				}

			// General
			
			case Coordination.Action.closeSheet.identifier:
				pathForSheet = NavigationStackBackport.NavigationPath()
				rootStateForSheet = nil
					
			case Coordination.Action.backButtonPressed.identifier:
				if !pathForSheet.isEmpty {
					pathForSheet.removeLast()
				} else {
					guard !firstTabPath.isEmpty else { return }
					firstTabPath.removeLast()
				}
					
			case Coordination.Action.resetApplication.identifier:
				parentCoordinator?.handle(Coordination.Action.resetApplication)
				
			default:
				// Unhandled
				logWarning("Dashboard Coordinator does not handle \(action)")
		}
	}
	
	/// Get a View for the State
	/// - Parameter state: the DashboardCoordination State
	/// - Returns: A view for that state
	@ViewBuilder func viewState(for state: DashboardCoordination.State?) -> some View {
		
		switch state {
			
			// Initial states
			case .aboutTheApp:
				AboutTheAppView(viewModel: AboutTheAppViewModel(coordinator: self))
			
			case .overview:
				OverviewView(viewModel: OverviewViewModel(coordinator: self)).isPresentedAsSheet(false)
			
			// Healthcare Provider Flow
			case .searchHealthcareProvider:
				SearchView(viewModel: SearchViewModel(coordinator: self)).isPresentedAsSheet(true)
			
			case let .searchHealthcareProviders(city, name):
				SearchResultsView(viewModel: SearchResultsViewModel(coordinator: self, city: city, name: name, localisationServiceClient: LocalisationServiceClient())).isPresentedAsSheet(true)
			
			case .storedHealthcareProviders:
				StoredHealthcareProvidersView(viewModel: StoredHealthcareProvidersViewModel(coordinator: self)).isPresentedAsSheet(true)
			
			case let .showHealthcareProviderDetails(healthcareProvider):
				HealthcareProviderView(viewModel: HealthcareProviderViewModel(coordinator: self, healthcareProvider: healthcareProvider))
			
			case let .removeHealthcareOrganization(healthcareOrganization):
				RemoveHealthcareOrganizationView(viewModel: RemoveHealthcareOrganizationViewModel(coordinator: self, healthcareOrganization: healthcareOrganization)).isPresentedAsSheet(true)
			
			case let .showProblems(healthcareProvider):
				ProblemsListView(
					viewModel: ProblemsListViewModel(
						coordinator: self,
						healthcareProvider: healthcareProvider
					)
				)
				
			case let .showMedication(healthcareProvider):
				MedicationListView(
					viewModel: MedicationListViewModel(
						coordinator: self,
						healthcareProvider: healthcareProvider
					)
				)
				
			case let .showLabResults(healthcareProvider):
				LabResultsListView(
					viewModel: LabResultsListViewModel(
						coordinator: self,
						healthcareProvider: healthcareProvider
					)
				)
			
			default:
				EmptyView()
		}
	}
}

struct DashboardCoordinatorView<T: DashboardCoordinatorProtocol>: View {
	
	/// The coordinator for handling state
	@StateObject private var coordinator: T
	
	/// Initializer
	/// - Parameter appCoordinator: An DashboardCoordinatorProtocol class
	init(coordinator: T) {
		self._coordinator = StateObject(wrappedValue: coordinator)
	}
	
	// The Theme
	@Environment(\.theme) var theme
	
	var body: some View {
		
			TabView {
				
				Group {
					// First Tab, Overview
					NavigationStackBackport.NavigationStack(path: $coordinator.firstTabPath) {
						coordinator.viewState(for: .overview)
							.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
								coordinator.viewState(for: state)
							}
							.navigationBarTitleDisplayMode(.inline)
					}
					.tabItem {
						Image(ImageResource.Tab.overview)
						Text("tab_overview")
							.rijksoverheidStyle(font: .regular, style: .body)
					}
					
					// Second Tab, About
					NavigationStackBackport.NavigationStack(path: $coordinator.secondTabPath) {
						coordinator.viewState(for: .aboutTheApp)
							.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
								coordinator.viewState(for: state)
							}
							.navigationBarTitleDisplayMode(.inline)
					}
					.tabItem {
						Image(ImageResource.Tab.about)
						Text("tab_about")
							.rijksoverheidStyle(font: .regular, style: .body)
					}
				}
			}
			.onAppear(perform: {
				// Brute force styling
				let tabBarAppearance = UITabBarAppearance()
				tabBarAppearance.shadowColor = UIColor(theme.linesTertiary)
				tabBarAppearance.backgroundColor = UIColor(theme.backgroundSecondary)
				
				for appearance in [tabBarAppearance.stackedLayoutAppearance, tabBarAppearance.compactInlineLayoutAppearance] {
					appearance.selected.iconColor = UIColor(theme.actionTertiaryDefault)
					appearance.selected.titleTextAttributes = [.foregroundColor: UIColor(theme.actionTertiaryDefault)]
					appearance.normal.titleTextAttributes = [.foregroundColor: UIColor(theme.iconsPrimary)]
					appearance.normal.iconColor = UIColor(theme.iconsPrimary)
				}
				
				// Apply
				UITabBar.appearance().standardAppearance = tabBarAppearance
				UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance

			})
			.navigationBarHidden(true)
			.navigationBarBackButtonHidden()
			.inspectableSheet(
				isPresented: $coordinator.rootStateForSheet.presence(),
				onDismiss: {
					// Called when the sheet is closed by dragging.
					coordinator.handle(Coordination.Action.closeSheet)
				},
				content: {
					NavigationStackBackport.NavigationStack(path: $coordinator.pathForSheet) {
						coordinator.viewState(for: coordinator.rootStateForSheet)
							.backport.navigationDestination(for: DashboardCoordination.State.self) { state in
								coordinator.viewState(for: state)
							}
							.navigationBarBackButtonHidden(true)
							.navigationBarTitleDisplayMode(.inline)
					}
				}
			)
	}
}

#Preview {
	DashboardCoordinatorView(coordinator: DashboardCoordinator(parentCoordinator: nil))
}
