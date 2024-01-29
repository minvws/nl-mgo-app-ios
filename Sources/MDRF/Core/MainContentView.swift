/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzUI
import GifzFoundation

struct MainContentView: View {
	
	@StateObject private var appCoordinator: AppCoordinator
	
	init(appCoordinator: AppCoordinator) {
		self._appCoordinator = StateObject(wrappedValue: appCoordinator)
	}
	
	var body: some View {
		NavigationStackBackport.NavigationStack(path: $appCoordinator.path) {
			EmptyView()
				.backport.navigationDestination(for: AppCoordination.State.self) { state in
					switch state {
						case .launch:
							LaunchView(viewModel: LaunchViewModel(coordinator: appCoordinator))
						case .dashboard:
							DashboardView()
					}
				}
		}
		.onAppear {
			appCoordinator.start()
		}
	}
}

#Preview {
	MainContentView(
		appCoordinator: AppCoordinator(
			path: NavigationStackBackport.NavigationPath()
		)
	)
}
