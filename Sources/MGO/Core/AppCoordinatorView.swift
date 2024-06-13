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
	
	/// Initializer
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
					appCoordinator.handle(Coordination.Action.closeSheet)
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
								ToolbarItem(content: { CloseButton {
									appCoordinator.handle(Coordination.Action.closeSheet)
								}})
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
}

//#Preview {
//	AppCoordinatorView<AppCoordinator>(
//		appCoordinator: AppCoordinator(
//			path: NavigationStackBackport.NavigationPath()
//		)
//	)
//}
#Preview {
	
	VStack {
		ToastView(Toast(title: "Title", subtitle: "Text", type: .info))
		ToastView(Toast(title: "Title", subtitle: "Text", type: .warning))
		ToastView(Toast(title: "Title", subtitle: "Text", type: .error))
		ToastView(Toast(title: "Title", subtitle: "Text", type: .success))
	}.padding(.horizontal, 16)
}
