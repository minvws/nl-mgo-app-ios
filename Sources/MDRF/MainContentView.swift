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
	
	init(path: NavigationStackBackport.NavigationPath) {
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
}

struct MainContentView: View {
	
	@StateObject private var appCoordinator = AppCoordinator(path: NavigationStackBackport.NavigationPath())
	
	var body: some View {
		NavigationStackBackport.NavigationStack(path: $appCoordinator.path) {
			EmptyView()
				.backport.navigationDestination(for: AppCoordinator.State.self) { route in
					
					switch route {
						case .launch:
							LaunchView(viewModel: LaunchViewModel())
						case .dashboard:
							DashboardView()
						default:
							let _ = logWarning("View not implemented for \(route)")
							EmptyView()
					}
				}
		}
		.onAppear {
			appCoordinator.start()
		}
		.environmentObject(appCoordinator)
	}
}

#Preview {
	MainContentView()
}
