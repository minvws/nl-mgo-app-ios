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
		case displaySettings
		case securitySettings
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
			
			case .displaySettings:
				coordinator?.handle(Coordination.Action.showDisplaySettings)
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
	
	/// Variable to change the automatic localization setting
	@State private var automaticLocalization: Bool = Current.featureFlagManager.isAutomaticLocalizationEnabled
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
			static let inset: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
		}
		enum Icon {
			static let size: CGFloat = 24.0
			static let padding: CGFloat = 16.0
			static let cornerRadius: CGFloat = 6.0
		}
		enum Chevron {
			static let size: CGFloat = 24.0
		}
	}
	
	var body: some View {
		
		VStack {
			List {
				Section {
					
					displaySetting()
					
					if Current.localAuthenticationProvider.biometricType() != .none {
						securitySetting()
					}
					
//					if viewModel.showAutomaticLocalizationOption {
//						Toggle(isOn: $automaticLocalization) {
//							Text("settings.featureflag.localization")
//						}.toggleStyle(.switch)
//							.tint(theme.interactionPrimaryDefaultBackground)
//					}
				}
//				.onChange(of: automaticLocalization) { newValue in
//					viewModel.reduce(.automaticLocalization(newValue))
//				}
				
			}
			.backportScrollContentBackground(.hidden)
			.backportListSectionSpacing(32)
			.backportVerticalContentMargins(0)
		}
//		.when(viewModel.showResetButton) { view in
//			view
//				.safeAreaInset(edge: VerticalEdge.bottom) {
//					CallToActionButton("settings.reset_app.button", style: .primaryCritical) {
//						viewModel.reduce(.showResetDialog)
//					}
//					.padding(ViewTraits.Button.insets)
//				}
//		}
//		.alert(
//			"settings.reset_app.dialog.heading",
//			isPresented: $viewModel.showResetDialog) {
//				Button("common.no", role: .cancel) { viewModel.reduce(.cancelDialog) }
//					.accessibilityIdentifier("common.no")
//				Button("common.yes", role: .destructive) { viewModel.reduce(.resetApplication) }
//					.accessibilityIdentifier("common.yes")
//			} message: {
//				Text("settings.reset_app.dialog.subheading")
//			}

		.navigationTitle("settings.heading")
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// Create a row for the settings view
	/// - Parameters:
	///   - icon: the icon to display
	///   - iconBackground: the background for the icon
	///   - heading: the heading for the row
	///   - subHeading: the subheading for the row
	/// - Returns: View for a settings row
	@ViewBuilder private func settingsRow(
		icon: Image,
		iconBackground: Color,
		heading: LocalizedStringKey,
		subHeading: LocalizedStringKey? = nil
	) -> some View {
		HStack(spacing: 0) {
			
			icon
				.foregroundStyle(theme.backgroundSecondary)
				.frame(width: ViewTraits.Icon.size, height: ViewTraits.Icon.size, alignment: .center)
				.background(iconBackground)
				.cornerRadius(ViewTraits.Icon.cornerRadius)
				.padding(.trailing, ViewTraits.Icon.padding)
			
			Text(heading)
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
				.frame(minHeight: ViewTraits.Icon.size)
			
			Spacer()
			if let subHeading {
				Text(subHeading)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentSecondary)
					.frame(minHeight: ViewTraits.Icon.size)
			}
			
			Image(ImageResource.Overview.chevronRight)
				.foregroundStyle(theme.symbolPrimary)
				.frame(width: ViewTraits.Chevron.size, height: ViewTraits.Chevron.size, alignment: .center)
				.accessibilityHidden(true)
		}
		.padding(ViewTraits.General.padding)
	}
	
	/// Get the view for the display settings option
	/// - Returns: Button for the display settings
	@ViewBuilder private func displaySetting() -> some View {
		
		Button {
			viewModel.reduce(.displaySettings)
		} label: {
			settingsRow(
				icon: Image(ImageResource.Settings.display),
				iconBackground: theme.procedures,
				heading: "settings.display.heading",
				subHeading: selectedAppearance.key
			)
		}
		.listRowInsets(ViewTraits.General.inset)
	}
	
	/// Get the view for the security settings option
	/// - Returns: Button for the security settings
	@ViewBuilder private func securitySetting() -> some View {
		
		Button {
			viewModel.reduce(.securitySettings)
		} label: {
			settingsRow(
				icon: Image(ImageResource.Settings.lock),
				iconBackground: theme.rijksLint,
				heading: "settings.security.heading"
			)
		}
		.listRowInsets(ViewTraits.General.inset)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		SettingsView(viewModel: SettingsViewModel(coordinator: nil))
	}
}
