/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AdvancedSettingsViewModel: BaseViewModel {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case automaticLocalization(Bool)
		case bypassPincode(Bool)
	}
	
	/// Dependency injectable Feature Flag Manager
	@Injected(\.featureFlagManager) private var featureFlagManager
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: AdvancedSettingsViewModel.Action) {
		
		if case .automaticLocalization(let automaticLocalization) = action {
			featureFlagManager.isAutomaticLocalizationEnabled = automaticLocalization
		} else if case .bypassPincode(let bypassPincode) = action {
			featureFlagManager.bypassPincode = bypassPincode
		}
	}
}

struct AdvancedSettingsView: View {
	
	/// The View Model
	@StateObject var viewModel: AdvancedSettingsViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Variable to change the automatic localization setting
	@State private var automaticLocalization: Bool = Container.shared.featureFlagManager().isAutomaticLocalizationEnabled
	
	/// Variable to change the bypass pincode setting
	@State private var bypassPincode: Bool = Container.shared.featureFlagManager().bypassPincode
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 24
		}
	}
	
	var body: some View {
		
		List {
			Section {
				automaticLocalizationToggleView()
				pincodeToggleView()
			}
		}
		.onChange(of: automaticLocalization) { newValue in
			viewModel.reduce(.automaticLocalization(newValue))
		}
		.onChange(of: bypassPincode) { newValue in
			viewModel.reduce(.bypassPincode(newValue))
		}
		.backport.scrollContentBackground(.hidden)
		.backport.contentMargins(ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationTitle("settings.advanced.heading")
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgrounds.primary.ignoresSafeArea())
	}
	
	/// The view for the toggle
	/// - Returns: toggle view
	@ViewBuilder private func automaticLocalizationToggleView() -> some View {
		
		Toggle(isOn: $automaticLocalization) {
			Text("settings.featureflag.localization")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.labels.primary)
		}
			.accessibilityIdentifier("settings.featureflag.localization")
			.toggleStyle(.switch)
			.tint(theme.actions.primary.background)
	}
	
	/// The view for the toggle
	/// - Returns: toggle view
	@ViewBuilder private func pincodeToggleView() -> some View {
		
		Toggle(isOn: $bypassPincode) {
			Text("settings.featureflag.pincode")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.labels.primary)
		}
			.accessibilityIdentifier("settings.featureflag.pincode")
			.toggleStyle(.switch)
			.tint(theme.actions.primary.background)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AdvancedSettingsView(viewModel: AdvancedSettingsViewModel(coordinator: nil))
	}
}
