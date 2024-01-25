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
				.backport.navigationDestination(for: AppCoordinator.State.self) { state in
					appCoordinator.view(for: state)
				}
		}
		.onAppear {
			appCoordinator.start()
		}
	}
}

#Preview {
	MainContentView(appCoordinator: AppCoordinator(path: NavigationStackBackport.NavigationPath()))
}
