/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

struct HealthcareCoordinatorView<T: HealthcareCoordinatorProtocol>: View {
	
	/// The coordinator for handling state
	@StateObject private var coordinator: T
	
	/// Create a Healthcare Coordination View
	/// - Parameter appCoordinator: An HealthcareCoordinatorProtocol class
	init(coordinator: T) {
		self._coordinator = StateObject(wrappedValue: coordinator)
	}
	
	var body: some View {
		
		NavigationStackBackport.NavigationStack(path: $coordinator.path) {
			
			coordinator.viewState(for: coordinator.rootState)
				.backport.navigationDestination(for: HealthcareCoordination.State.self) { state in
					coordinator.viewState(for: state)
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
				NavigationStackBackport.NavigationStack(path: $coordinator.pathForSheet) {
					
					coordinator.viewState(for: coordinator.rootStateForSheet)
						.backport.navigationDestination(for: HealthcareCoordination.State.self) { state in
							coordinator.viewState(for: state)
						}
						.navigationBarBackButtonHidden(true)
						.navigationBarTitleDisplayMode(.inline)
				}
			}
		)
	}
}

#Preview {
	HealthcareCoordinatorView(
		coordinator: HealthcareCoordinator(
			parentCoordinator: nil,
			rootState: .showHealthCategories
		)
	)
}
