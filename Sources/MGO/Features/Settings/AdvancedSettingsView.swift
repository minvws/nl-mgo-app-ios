/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AdvancedSettingsViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case automaticLocalization(Bool)
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AdvancedSettingsViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case let .automaticLocalization(automaticLocalization):
				Current.featureFlagManager.isAutomaticLocalizationEnabled = automaticLocalization
		}
	}
}

struct AdvancedSettingsView: View {
	
	/// The View Model
	@StateObject var viewModel: AdvancedSettingsViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Variable to change the automatic localization setting
	@State private var automaticLocalization: Bool = Current.featureFlagManager.isAutomaticLocalizationEnabled
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 24
		}
	}
	
	var body: some View {
		
		List {
			Section {
				toggleView()
			}
		}
		.onChange(of: automaticLocalization) { newValue in
			viewModel.reduce(.automaticLocalization(newValue))
		}
		.backportScrollContentBackground(.hidden)
		.backportVerticalContentMargins(ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationTitle("settings.advanced.heading")
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// The view for the toggle
	/// - Returns: toggle view
	@ViewBuilder private func toggleView() -> some View {
		
		Toggle(isOn: $automaticLocalization) {
			Text("settings.featureflag.localization")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
		}
			.toggleStyle(.switch)
			.tint(theme.interactionPrimaryDefaultBackground)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AdvancedSettingsView(viewModel: AdvancedSettingsViewModel(coordinator: nil))
	}
}
