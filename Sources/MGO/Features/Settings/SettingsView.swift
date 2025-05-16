/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class SettingsViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// Should we show the advanced settings button
	@Published var showAdvancedButton: Bool = false
	
	/// Should we show the security settings button
	@Published var showSecurityButton: Bool = false
	
	/// Should we show the reset dialog
	@Published var showResetDialog: Bool = false
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case aboutTheApp
		case advancedSettings
		case cancelDialog
		case displaySettings
		case lockApplication
		case resetApplication
		case securitySettings
		case showResetDialog
	}
	
	/// Create the settings view model
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		self.coordinator = coordinator
		
		let release = Configuration().getRelease()
		showAdvancedButton = release == Release.development // Show only in Dev
		
		// Show only when we have biometrics
		showSecurityButton = Current.localAuthenticationProvider.biometricType() != .none
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: SettingsViewModel.Action) {
		
		switch action {
			case .aboutTheApp:
				coordinator?.handle(Coordination.Action.showAboutTheApp)
			
			case .advancedSettings:
				coordinator?.handle(Coordination.Action.showAdvancedSettings)
			
			case .cancelDialog:
				showResetDialog = false
			
			case .displaySettings:
				coordinator?.handle(Coordination.Action.showDisplaySettings)
			
			case .lockApplication:
				coordinator?.handle(Coordination.Action.lockApplication)
			
			case .resetApplication:
				coordinator?.handle(Coordination.Action.resetApplication)
			
			case .showResetDialog:
				showResetDialog = true
			
			case .securitySettings:
				coordinator?.handle(Coordination.Action.showSecuritySettings)
		}
	}
}

struct SettingsView: View {
	
	/// The View Model
	@StateObject var viewModel: SettingsViewModel
	
	/// The application appearance for light / dark / system mode
	@AppStorage("AppAppearance") private var selectedAppearance: AppAppearance = .system
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
			static let inset: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
		}
		enum Button {
			static let minimumHeight: CGFloat = 48
		}
	}
	
	var body: some View {
		
		List {
			Section {
				
				displaySettings()
				
				if viewModel.showSecurityButton {
					securitySettings()
				}
			}
			if viewModel.showAdvancedButton {
				advancedSettings()
			}
			aboutTheApp()
			logout()
			reset()
		}
	
		.backportScrollContentBackground(.hidden)
		.backportContentMargins(ViewTraits.Navigation.padding)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		.navigationTitle("settings.heading")
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// Get the view for the display settings option
	/// - Returns: Button for the display settings
	@ViewBuilder private func displaySettings() -> some View {
		
		Button {
			viewModel.reduce(.displaySettings)
		} label: {
			SettingsRowView(
				icon: Image(ImageResource.Settings.display),
				iconBackground: theme.procedures,
				heading: "settings.display.heading",
				subHeading: selectedAppearance.key
			)
		}
		.accessibilityIdentifier("settings.display")
		.listRowInsets(ViewTraits.General.inset)
	}
	
	/// Get the view for the security settings option
	/// - Returns: Button for the security settings
	@ViewBuilder private func securitySettings() -> some View {
		
		Button {
			viewModel.reduce(.securitySettings)
		} label: {
			SettingsRowView(
				icon: Image(ImageResource.Settings.lock),
				iconBackground: theme.rijksLint,
				heading: "settings.security.heading"
			)
		}
		.accessibilityIdentifier("settings.security")
		.listRowInsets(ViewTraits.General.inset)
	}
	
	/// Get the view for the advanced settings option
	/// - Returns: Button for the advanced settings
	@ViewBuilder private func advancedSettings() -> some View {
		
		Section {
			Button {
				viewModel.reduce(.advancedSettings)
			} label: {
				SettingsRowView(
					icon: Image(ImageResource.Settings.advanced),
					iconBackground: theme.vitals,
					heading: "settings.advanced.heading"
				)
			}
			.accessibilityIdentifier("settings.advanced")
			.listRowInsets(ViewTraits.General.inset)
		} footer: {
			Text("settings.advanced.subheading")
				.rijksoverheidStyle(font: .regular, style: .callout)
				.foregroundStyle(theme.contentSecondary)
		}
	}
	
	/// Get the view for the about the app option
	/// - Returns: Button for the about the app option
	@ViewBuilder private func aboutTheApp() -> some View {
		
		Section {
			Button {
				viewModel.reduce(.aboutTheApp)
			} label: {
				SettingsRowView(
					heading: "settings.about_this_app.heading"
				)
			}
			.accessibilityIdentifier("settings.about_this_app")
			.listRowInsets(ViewTraits.General.inset)
		}
	}
	
	/// Get the view for the logout option
	/// - Returns: Button for the logout option
	@ViewBuilder private func logout() -> some View {
		
		Section {
			Button {
				viewModel.reduce(.lockApplication)
			} label: {
				Text("settings.log_out.heading")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.interactionTertiaryDefaultText)
					.frame(
						maxWidth: .infinity,
						minHeight: ViewTraits.Button.minimumHeight,
						alignment: .center
					)
			}
			.accessibilityIdentifier("settings.log_out")
			.listRowInsets(ViewTraits.General.inset)
		} footer: {
			Text("settings.log_out.subheading")
				.rijksoverheidStyle(font: .regular, style: .callout)
				.foregroundStyle(theme.contentSecondary)
		}
	}
	
	/// Get the view for the reset option
	/// - Returns: Button for the rest option
	@ViewBuilder private func reset() -> some View {
		
		Section {
			Button {
				viewModel.reduce(.showResetDialog)
			} label: {
				Text("settings.reset_app.heading")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.sentimentCritical)
					.frame(
						maxWidth: .infinity,
						minHeight: ViewTraits.Button.minimumHeight,
						alignment: .center
					)
			}
			.accessibilityIdentifier("settings.reset_app")
			.listRowInsets(ViewTraits.General.inset)
		} footer: {
			Text("settings.reset_app.subheading")
				.rijksoverheidStyle(font: .regular, style: .callout)
				.foregroundStyle(theme.contentSecondary)
		}
		.alert(
			"settings.reset_app.dialog.heading",
			isPresented: $viewModel.showResetDialog) {
				Button("common.cancel", role: .cancel) { viewModel.reduce(.cancelDialog) }
					.accessibilityIdentifier("common.cancel")
				Button("settings.reset_app.dialog.action", role: .destructive) { viewModel.reduce(.resetApplication) }
					.accessibilityIdentifier("settings.reset_app.dialog.action")
			} message: {
				Text("settings.reset_app.dialog.subheading")
			}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		SettingsView(viewModel: SettingsViewModel(coordinator: nil))
	}
}
