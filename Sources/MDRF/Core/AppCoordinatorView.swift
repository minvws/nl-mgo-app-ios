/*
 * Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import GifzUI
import GifzFoundation

struct AppCoordinatorView<T: AppCoordinatorProtocol>: View {
	
	@StateObject private var appCoordinator: T
	var didAppear: ((Self) -> Void)? // 1.
	
	init(appCoordinator: T) {
		self._appCoordinator = StateObject(wrappedValue: appCoordinator)
	}
	
	var body: some View {
		NavigationStackBackport.NavigationStack(path: $appCoordinator.path) {
			EmptyView()
				.backport.navigationDestination(for: AppCoordination.State.self) { state in
					switch state {
						case .launch:
							LaunchView(viewModel: LaunchViewModel(coordinator: appCoordinator))
						case .appIntroduction:
							AppIntroductionView(viewModel: AppIntroductionViewModel(coordinator: appCoordinator))
						case .privacy:
							PrivacyView(viewModel: PrivacyViewModel(coordinator: appCoordinator))
						case .dashboard:
							DashboardView()
					}
				}
		}
		.inspectableSheet(
			isPresented: $appCoordinator.showSheet,
			onDismiss: {
				appCoordinator.handle(.dismissPrivacyStatementSheet)
			},
			content: {
				switch appCoordinator.sheetContentType {
					case .privacyStatement:
						PrivacyStatementView()
						.tag("privacyStatement")
					default:
						EmptyView()
						.logWarning("No content set for sheet in appCoordinatorView for \(String(describing: appCoordinator.sheetContentType))")
				}
			}
		)
		.onAppear {
			appCoordinator.start()
			self.didAppear?(self)
		}
	}
}

#Preview {
	AppCoordinatorView<AppCoordinator>(
		appCoordinator: AppCoordinator(
			path: NavigationStackBackport.NavigationPath()
		)
	)
}
