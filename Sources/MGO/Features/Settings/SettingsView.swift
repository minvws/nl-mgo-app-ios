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
	@Published var showAutomaticLocalizationOption: Bool = false
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case resetApplication
		case showResetDialog
		case automaticLocalization(Bool)
		case cancelDialog
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		self.coordinator = coordinator
		
		let release = Configuration().getRelease()
		showResetButton = release != Release.production // Show only in Dev, Acc & Test
		showAutomaticLocalizationOption = !Current.featureFlagManager.isDemo
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SettingsViewModel.Action) {
		
		switch action {
			case .resetApplication:
				coordinator?.handle(Coordination.Action.resetApplication)
			case .showResetDialog:
				showResetDialog = true
			case .cancelDialog:
				showResetDialog = false
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
			if viewModel.showAutomaticLocalizationOption {
				List {
					Section {
						Toggle(isOn: $automaticLocalization) {
							Text("settings.featureflag.localization")
						}.toggleStyle(.switch)
							.tint(theme.interactionPrimaryDefaultBackground)
					}
				}
				.onChange(of: automaticLocalization) { newValue in
					viewModel.reduce(.automaticLocalization(newValue))
				}
			} else {
				Spacer()
			}
		}
		.when(viewModel.showResetButton) { view in
			view
				.safeAreaInset(edge: VerticalEdge.bottom) {
					CallToActionButton("settings.reset_app.button", style: .primaryCritical) {
						viewModel.reduce(.showResetDialog)
					}
					.padding(ViewTraits.Button.insets)
				}
		}
		.alert(
			"settings.reset_app.dialog.heading",
			isPresented: $viewModel.showResetDialog) {
				Button("common.no", role: .cancel) { viewModel.reduce(.cancelDialog) }
					.accessibilityIdentifier("common.no")
				Button("common.yes", role: .destructive) { viewModel.reduce(.resetApplication) }
					.accessibilityIdentifier("common.yes")
			} message: {
				Text("settings.reset_app.dialog.subheading")
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
