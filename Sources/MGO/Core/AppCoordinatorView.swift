/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct AppCoordinatorView<T: AppCoordinatorProtocol>: View {
	
	/// The coordinator for handling state
	@StateObject private var appCoordinator: T
	
	/// Closure used the handle inspection
	var didAppear: ((Self) -> Void)?
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Initializer
	/// - Parameter appCoordinator: An AppCoordinatorProtocol class
	init(appCoordinator: T) {
		self._appCoordinator = StateObject(wrappedValue: appCoordinator)
	}
	
	var body: some View {
		
		if appCoordinator.showChildCoordinator {
			appCoordinator.view(for: .dashboard)
				.inspectableFullScreenCover(
					isPresented: $appCoordinator.rootStateForSheet.presence(),
					content: {
						sheetContent(withCloseButton: false)
					}
				)
				.screenshotAlert()
		} else {
			
			NavigationStackBackport.NavigationStack(path: $appCoordinator.path) {
				
				appCoordinator.view(for: appCoordinator.rootState)
					.backport.navigationDestination(for: AppCoordination.State.self) { state in
						appCoordinator.view(for: state)
					}
				// Show inline title for iOS 15.
					.when(isIOS15) { view in
						view
							.navigationBarTitleDisplayMode(.inline)
					}
			}
			// not a sheet, but an inspectable sheet, so we can confirm this in a test.
			.inspectableSheet(
				isPresented: $appCoordinator.rootStateForSheet.presence(),
				onDismiss: {
					// Called when the sheet is closed by dragging.
					appCoordinator.handle(Coordination.Action.closeSheet)
				},
				content: {
					sheetContent(withCloseButton: appCoordinator.showCloseButtonForSheet(for: appCoordinator.rootStateForSheet))
						.backport.presentationContentInteraction(.scrolls)
						.backport.presentationDragIndicator(UIDevice.current.userInterfaceIdiom == .pad ? Visibility.hidden : Visibility.visible) // Hide on iPad
						
				}
			)
			.onAppear {
				// Make ourself available for inspection
				self.didAppear?(self)
			}
			.onOpenURL { deeplink in
				appCoordinator.handle(
					Coordination.Action(
						identifier: Coordination.Action.deeplink.identifier,
						params: ["deeplink": deeplink]
					)
				)
			}
			.screenshotAlert()
		}
	}
	
	@ViewBuilder func sheetContent(withCloseButton: Bool) -> some View {
		
		NavigationStackBackport.NavigationStack(path: $appCoordinator.pathForSheet) {
			appCoordinator.view(for: appCoordinator.rootStateForSheet)
				.backport.navigationDestination(for: AppCoordination.State.self) { state in
					appCoordinator.view(for: state)
						.navigationBarBackButtonHidden(true)
						.navigationBarHidden(false)
						.navigationBarTitleDisplayMode(.inline)
				}
				.when(withCloseButton) { view in
					view
						.withToolbarCloseButton(osVersionChecker.available(version: .iOS(.v26))) {
							appCoordinator.handle(Coordination.Action.closeSheet)
						}
				}
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
