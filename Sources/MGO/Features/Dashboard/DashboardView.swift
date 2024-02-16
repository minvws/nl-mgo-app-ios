/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class DashboardViewModel: ObservableObject {
	
	/// The app coordintator for routing
	weak var coordinator: (any AppCoordinatorProtocol)?
	
	@Published var showResetButton: Bool = false
	@Published var showResetDialog: Bool = false
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case reset
		case showResetDialog
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any AppCoordinatorProtocol)? = nil) {
		self.coordinator = coordinator
		
		let release = Configuration().getRelease()
		logInfo("We are in \(release) mode")
		showResetButton = release != .production
		
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: DashboardViewModel.Action) {
		
		switch action {
			case .reset:
//				coordinator?.handle(AppCoordination.Action.reset)
				break
			case .showResetDialog:
				showResetDialog = true
		}
	}
}

struct DashboardView: View {
	
	/// The View Model
	@StateObject var viewModel: DashboardViewModel
	
	var body: some View {
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
			
			VStack {
				
				Text("app_title")
					.rijksoverheidStyle(font: .bold, style: .largeTitle)
					.accessibilityAddTraits(.isHeader)
					.multilineTextAlignment(.center)
				
				Text(verbatim: "That's all folks!")
					.rijksoverheidStyle(font: .regular, style: .body)
			}
		}
		.navigationBarBackButtonHidden()
		
		.confirmationDialog(
			"Are you sure?",
			isPresented: $viewModel.showResetDialog) {
				Button("Reset", role: .destructive) {
					viewModel.reduce(.reset)
				}
			} message: {
				Text(verbatim: "You cannot undo this action")
			}
		
		.toolbar {
			ToolbarItem(id: "reset", placement: .destructiveAction) {
				
				Button(
					action: {
						viewModel.reduce(.showResetDialog)
					}, label: {
						Image(systemName: "exclamationmark.triangle.fill")
							.foregroundStyle(.red)
					}
				)
			}
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		DashboardView(viewModel: DashboardViewModel(coordinator: nil))
	}
}
