/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AdvancedSettingsViewModel: BaseViewModel {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case bypassRemoteAuthentication(Bool)
	}
	
	/// Dependency injectable Feature Flag Manager
	@Injected(\.featureFlagManager) private var featureFlagManager
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: AdvancedSettingsViewModel.Action) {

		if case .bypassRemoteAuthentication(let bypassRemoteAuthentication) = action {
			featureFlagManager.bypassRemoteAuthentication = bypassRemoteAuthentication
		}
	}
}

struct AdvancedSettingsView: View {
	
	/// The View Model
	@StateObject var viewModel: AdvancedSettingsViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Variable to change the bypass Remote Authentication setting
	@State private var bypassRemoteAuthentication: Bool = Container.shared.featureFlagManager().bypassRemoteAuthentication
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 24
		}
	}
	
	var body: some View {

		List {
			Section {
				remoteAuthToggleView()
			}
		}
		.onChange(of: bypassRemoteAuthentication) { newValue in
			viewModel.reduce(.bypassRemoteAuthentication(newValue))
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
	@ViewBuilder private func remoteAuthToggleView() -> some View {
		
		Toggle(isOn: $bypassRemoteAuthentication) {
			Text("settings.featureflag.remote_auth")
				.typography(.bodyMedium)
				.foregroundStyle(theme.labels.primary)
		}
			.accessibilityIdentifier("settings.featureflag.remote_auth")
			.toggleStyle(.switch)
			.tint(theme.actions.solid.background)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AdvancedSettingsView(viewModel: AdvancedSettingsViewModel(coordinator: nil))
	}
}
