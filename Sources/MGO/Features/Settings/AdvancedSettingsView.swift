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
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AdvancedSettingsViewModel.Action) {
		
		if case .automaticLocalization(let automaticLocalization) = action {
			Current.featureFlagManager.isAutomaticLocalizationEnabled = automaticLocalization
		} else if case .bypassPincode(let bypassPincode) = action {
			Current.featureFlagManager.bypassPincode = bypassPincode
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
	
	/// Variable to change the bypass pincode setting
	@State private var bypassPincode: Bool = Current.featureFlagManager.bypassPincode
	
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
		.backportScrollContentBackground(.hidden)
		.backportContentMargins(ViewTraits.Navigation.padding)
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
	@ViewBuilder private func automaticLocalizationToggleView() -> some View {
		
		Toggle(isOn: $automaticLocalization) {
			Text("settings.featureflag.localization")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
		}
			.accessibilityIdentifier("settings.featureflag.localization")
			.toggleStyle(.switch)
			.tint(theme.interactionPrimaryDefaultBackground)
	}
	
	/// The view for the toggle
	/// - Returns: toggle view
	@ViewBuilder private func pincodeToggleView() -> some View {
		
		Toggle(isOn: $bypassPincode) {
			Text("settings.featureflag.pincode")
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
		}
			.accessibilityIdentifier("settings.featureflag.pincode")
			.toggleStyle(.switch)
			.tint(theme.interactionPrimaryDefaultBackground)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AdvancedSettingsView(viewModel: AdvancedSettingsViewModel(coordinator: nil))
	}
}
