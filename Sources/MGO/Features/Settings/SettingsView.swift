/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class SettingsViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	@Published var showResetButton: Bool = false
	@Published var showResetDialog: Bool = false
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case resetApplication
		case showResetDialog
		case automaticLocalization(Bool)
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		self.coordinator = coordinator
		
		let release = Configuration().getRelease()
		showResetButton = release != Release.production // Show only in Dev, Acc & Test
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SettingsViewModel.Action) {
		
		switch action {
			case .resetApplication:
				coordinator?.handle(Coordination.Action.resetApplication)
			case .showResetDialog:
				showResetDialog = true
			case let .automaticLocalization(automaticLocalization):
				Current.featureFlagManager.isAutomaticLocalizationEnabled = automaticLocalization
		}
	}
}

struct SettingsView: View {
	
	/// The View Model
	@StateObject var viewModel: SettingsViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Variable to change the automatic localization setting
	@State private var automaticLocalization: Bool = Current.featureFlagManager.isAutomaticLocalizationEnabled
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {
		
		VStack {
			List {
				Section {
					Toggle(isOn: $automaticLocalization) {
						Text("settings.featureflag.localization")
					}.toggleStyle(.switch)
					.tint(theme.actionPrimaryDefaultBackground)
				}
			}
			.onChange(of: automaticLocalization) { newValue in
				viewModel.reduce(.automaticLocalization(newValue))
			}
			
			if viewModel.showResetButton {
				CallToActionButton("Reset de app", style: .primaryNegative) {
					viewModel.reduce(.showResetDialog)
				}
				.padding(ViewTraits.Button.insets)
				.confirmationDialog(
					"Reset de app?",
					isPresented: $viewModel.showResetDialog) {
						Button("Reset", role: .destructive) {
							viewModel.reduce(.resetApplication)
						}
					} message: {
						Text(verbatim: "You cannot undo this action")
					}
			}
			
			Spacer()
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.navigationTitle("settings.heading")
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		SettingsView(viewModel: SettingsViewModel(coordinator: nil))
	}
}
