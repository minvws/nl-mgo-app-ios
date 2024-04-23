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
		case poc
		case search
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
			case .poc:
				coordinator?.handle(.fhirClient)
			case .search:
				coordinator?.handle(.searchHealthcareProviders)
		}
	}
}

struct DashboardView: View {
	
	/// The View Model
	@StateObject var viewModel: DashboardViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
	}
	
	var body: some View {
		ZStack {
			
			theme.backgroundPrimary
				.ignoresSafeArea()
			
			VStack {
				
				Text("app_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.accessibilityAddTraits(.isHeader)
					.multilineTextAlignment(.center)
					.padding(.bottom, ViewTraits.General.padding)
				
				CallToActionButton("dashboard_poc") {
					viewModel.reduce(.poc)
				}
				.padding(.bottom, ViewTraits.General.padding)

				CallToActionButton("dashboard_search_healthcareProviders") {
					viewModel.reduce(.search)
				}
				.padding(.bottom, ViewTraits.General.padding)
				
				Spacer()
			}
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.top, ViewTraits.Navigation.padding)
			
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
								.foregroundStyle(theme.notificationError)
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
