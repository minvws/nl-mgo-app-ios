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
		case resetApplication
		case showResetDialog
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any AppCoordinatorProtocol)? = nil) {
		self.coordinator = coordinator
		
		let release = Configuration().getRelease()
		showResetButton = release != Release.production // Show only in Dev, Acc & Test
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: DashboardViewModel.Action) {
		
		switch action {
			case .resetApplication:
				coordinator?.handle(AppCoordination.Action.resetApplication)
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
			"Reset the application?",
			isPresented: $viewModel.showResetDialog) {
				Button("Reset the application?", role: .destructive) {
					viewModel.reduce(.resetApplication)
				}
			} message: {
				Text(verbatim: "You cannot undo this action")
			}
		
		.toolbar {
			ToolbarItem(id: "reset", placement: .destructiveAction) {
				if viewModel.showResetButton {
					Button(
						action: {
							viewModel.reduce(.showResetDialog)
						}, label: {
							Image(systemName: "exclamationmark.triangle")
								.foregroundStyle(Color.Styleguide.Basic.rubyRed)
						}
					)
				}
			}
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		DashboardView(viewModel: DashboardViewModel(coordinator: nil))
	}
}
