/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

protocol Coordinator {
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Any)
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
	
	/// A list of all the action an app coordinator can do
	enum Action: Equatable {
		
		// Healthcare Provider flow
//		case search(city: String, name: String)
//		case backToSearchHealthcareProvider
//		case storeHealthcareProvider
//		case finishedSearchingHealthcareProviders
		case searchHealthcareProviders
		
		// Other
		case sheetClosed
		case backButtonPressed
		case resetApplication
	}
	
	/// A list of all the view states the app coordinator can show
	enum State: Equatable, Hashable, Codable {
		
		case aboutTheApp
		case overview
		
//		// Healthcare Provider flow
		case searchHealthcareProvider
//		case searchHealthcareProviders(city: String, name: String)
//		case storedHealthcareProviders
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
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(parentCoordinator: (any AppCoordinatorProtocol)?) {
		self.parentCoordinator = parentCoordinator
	}
	
	/// Handle any incoming action from any of the view models
	/// - Parameter action: any Action
	func handle(_ action: Any) {
		if let castedAction = action as? DashboardCoordination.Action {
			switch castedAction {
				case .searchHealthcareProviders:
					rootStateForSheet = DashboardCoordination.State.searchHealthcareProvider
				
				case .sheetClosed:
					pathForSheet = NavigationStackBackport.NavigationPath()
					rootStateForSheet = nil
					
				case .backButtonPressed:
					guard !firstTabPath.isEmpty else { return }
					firstTabPath.removeLast()
				
				case .resetApplication:
					parentCoordinator?.handle(AppCoordination.Action.resetApplication)
			}
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
				SearchView(viewModel: SearchViewModel(coordinator: nil)).isPresentedAsSheet(true)
			
			default:
				EmptyView()
		}
	}
}

struct DashboardCoordinatorView<T: DashboardCoordinatorProtocol>: View {
	
	/// The coordinator for handling state
	@StateObject private var coordinator: T
	
	/// Initialzier
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
						HStack {
							Text("tab_overview")
								.rijksoverheidStyle(font: .regular, style: .body)
							Image(ImageResource.Tab.overview)
						}
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
						HStack {
							Text("tab_about")
								.rijksoverheidStyle(font: .regular, style: .body)
							Image(ImageResource.Tab.about)
						}
					}
				}
				.backportToolbarBackground()
			}
			.foregroundColor(theme.iconsPrimary)
			.accentColor(theme.actionTertiaryDefault)
			.navigationBarBackButtonHidden()
			.inspectableSheet(
				isPresented: $coordinator.rootStateForSheet.presence(),
				onDismiss: {
					// Called when the sheet is closed by dragging.
					coordinator.handle(DashboardCoordination.Action.sheetClosed)
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
