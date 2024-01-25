/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzUI
import GifzFoundation

final class AppCoordinator: ObservableObject {
	
	enum State {
		case launch
		case dashboard
	}
	
	enum Action {
		case finishedLoading
	}
	
	@Published var path: NavigationStackBackport.NavigationPath
	
	public init(path: NavigationStackBackport.NavigationPath) {
		self.path = path
	}
	
	func start() {
		path.append(State.launch)
	}
	
	func handle(_ action: Action) {
		if action == .finishedLoading {
			path.append(State.dashboard)
		}
	}
	
	@ViewBuilder
	func view(for state: State) -> some View {
		
		switch state {
			case .launch:
				LaunchView(viewModel: LaunchViewModel(coordinator: self))
			case .dashboard:
				DashboardView()
			default:
				EmptyView()
					.logWarning("View not implemented for \(state)")
		}
	}
}
