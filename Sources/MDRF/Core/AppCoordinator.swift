/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzUI
import GifzFoundation

//protocol AppCoordinatorProtocol: ObservableObject {
//	
//	var path: NavigationStackBackport.NavigationPath { get set }
//	
//	func handle(_ action: AppCoordination.Action)
//	func startCoordinator()
//}

enum AppCoordination {
	enum Action {
		case finishedLoading
	}
	
	enum State: Codable {
		case launch
		case dashboard
	}
}

final class AppCoordinator: ObservableObject {

	@Published var path: NavigationStackBackport.NavigationPath
	
	init(path: NavigationStackBackport.NavigationPath) {
		self.path = path
	}
	
	/// Start the coordinator
	func startCoordinator() {
		path.append(AppCoordination.State.launch)
	}
	
	/// Handle an action
	/// - Parameter action: an action, i.e. finishedLoading
	func handle(_ action: AppCoordination.Action) {
		if action == .finishedLoading {
			path.append(AppCoordination.State.dashboard)
		}
	}
	
	@ViewBuilder
	func view(for state: AppCoordination.State) -> some View {
		switch state {
			case .launch:
				LaunchView(viewModel: LaunchViewModel(coordinator: self))
			case .dashboard:
				DashboardView()
		}
	}
}
