/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct SettingsCoordinatorView<T: SettingsCoordinatorProtocol>: View {
	
	/// The coordinator for handling state
	@StateObject private var coordinator: T
	
	/// Initializer
	/// - Parameter appCoordinator: An SettingsCoordinatorProtocol class
	init(coordinator: T) {
		self._coordinator = StateObject(wrappedValue: coordinator)
	}
	
	// The Theme
	@Environment(\.theme) var theme
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	var body: some View {
		
		NavigationStackBackport.NavigationStack(path: $coordinator.path) {
			
			coordinator.view(for: .settings)
				.backport.navigationDestination(for: SettingsCoordination.State.self) { state in
					coordinator.view(for: state)
				}
			// Show inline title for iOS 15.
				.when(isIOS15) { view in
					view
						.navigationBarTitleDisplayMode(.inline)
				}
		}
		.navigationBarHidden(true)
		.navigationBarBackButtonHidden()
		.inspectableSheet(
			isPresented: $coordinator.rootStateForSheet.presence(),
			onDismiss: {
				// Called when the sheet is closed by dragging.
				coordinator.handle(Coordination.Action.closeSheet)
			},
			content: {
				sheetContent()
			}
		)
	}
	
	/// The content for the sheet
	/// - Returns: sheet content
	@ViewBuilder private func sheetContent() -> some View {
		NavigationStackBackport.NavigationStack(path: $coordinator.pathForSheet) {
			
			coordinator.view(for: coordinator.rootStateForSheet)
				.backport.navigationDestination(for: SettingsCoordination.State.self) { state in
					coordinator.view(for: state)
				}
				.navigationBarBackButtonHidden(true)
				.navigationBarTitleDisplayMode(.inline)
				.backportPresentationContentInteraction(.scrolls)
				.backportPresentationDragIndicator(Visibility.visible)
		}
	}
}

#Preview {
	SettingsCoordinatorView(coordinator: SettingsCoordinator(parentCoordinator: nil))
}
