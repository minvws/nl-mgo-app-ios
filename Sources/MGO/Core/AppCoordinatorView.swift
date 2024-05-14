/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct AppCoordinatorView<T: AppCoordinatorProtocol>: View {
	
	/// The coordinator for handling state
	@StateObject private var appCoordinator: T
	
	/// Closure used the handle inspection
	var didAppear: ((Self) -> Void)?
	
	/// Initialzier
	/// - Parameter appCoordinator: An AppCoordinatorProtocol class
	init(appCoordinator: T) {
		self._appCoordinator = StateObject(wrappedValue: appCoordinator)
	}
	
	var body: some View {
		if appCoordinator.showChildCoordinator {
			appCoordinator.view(for: .dashboard)
		} else {
			
			NavigationStackBackport.NavigationStack(path: $appCoordinator.path) {
				appCoordinator.view(for: .launch)
					.backport.navigationDestination(for: AppCoordination.State.self) { state in
						appCoordinator.view(for: state)
					}
					.navigationBarTitleDisplayMode(.inline)
			}
			// not a sheet, but an inspectable sheet, so we can confirm this in a test.
			.inspectableSheet(
				isPresented: $appCoordinator.rootStateForSheet.presence(),
				onDismiss: {
					// Called when the sheet is closed by dragging.
					appCoordinator.handle(AppCoordination.Action.sheetClosed)
				},
				content: {
					NavigationStackBackport.NavigationStack(path: $appCoordinator.pathForSheet) {
						appCoordinator.view(for: appCoordinator.rootStateForSheet)
							.backport.navigationDestination(for: AppCoordination.State.self) { state in
								appCoordinator.view(for: state)
							}
							.navigationBarBackButtonHidden(true)
							.navigationBarTitleDisplayMode(.inline)
							.toolbar {
								ToolbarItem(content: { closeButton() })
							}
					}
				}
			)
			.onAppear {
				// Make ourself availble for inspection
				self.didAppear?(self)
			}
		}
	}
	
	/// The close button
	/// - Returns: Button
	@ViewBuilder func closeButton() -> some View {
		
		Button(
			action: {
				appCoordinator.handle(AppCoordination.Action.sheetClosed)
			}, label: {
				Image(ImageResource.Icon.close)
					.resizable()
					.frame(width: 28, height: 28)
			}
		)
		.accessibilityLabel("general_close")
	}
}

#Preview {
	AppCoordinatorView<AppCoordinator>(
		appCoordinator: AppCoordinator(
			path: NavigationStackBackport.NavigationPath()
		)
	)
}
