/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AboutTheAppViewModel: BaseViewModel {
	
	/// The current version of the application
	@Published var appVersion: String
	
	/// The current version of the shared core
	@Published var sharedCoreVersion: String?
	
	/// Show the shared core version dialog
	@Published var showSharedCoreVersionDialog: Bool = false
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case showSharedCoreVersion
		case showSafety
		case showOpenSource
		case showAccessibility
		case showPrivacy
	}
	
	/// Create the settings view model
	/// - Parameter coordinator: the app coordinator
	override init(coordinator: (any Coordinator)? = nil) {
		
		appVersion = "\(Current.appVersionSupplier.getCurrentVersion()) (\(Current.appVersionSupplier.getCurrentBuild()))"
		super.init(coordinator: coordinator)
		
		do {
			sharedCoreVersion = try FHIRParser().getVersion()
		} catch {
			logError("No shared core version found: \(error)")
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AboutTheAppViewModel.Action) {
		
		switch action {
			
			case .showSharedCoreVersion:
				if sharedCoreVersion != nil {
					showSharedCoreVersionDialog = true
				}
			
			case .showSafety:
				coordinator?.handle(Coordination.Action.showSafetyTips)
			
			case .showOpenSource:
				coordinator?.handle(Coordination.Action.showOpenSourceLibraries)
				
			case .showAccessibility:
				coordinator?.handle(Coordination.Action.showAccessibility)
			
			case .showPrivacy:
				coordinator?.handle(Coordination.Action.showPrivacyStatement)
		}
	}
}

struct AboutTheAppView: View {
	
	/// The View Model
	@StateObject var viewModel: AboutTheAppViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 24
		}
		enum General {
			static let padding: CGFloat = 16
			static let inset: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
		}
		enum Button {
			static let minimumHeight: CGFloat = 48
		}
		enum Logo {
			static let maxHeight: CGFloat = 150
		}
	}
	
	var body: some View {
		
		List {
			Section {
				header()
				versionRow()
				safetyRow()
				openSourceRow()
				accessibilityRow()
			}
			Section {
				privacy()
			}
		}
		.backportScrollContentBackground(.hidden)
		.backportContentMargins(ViewTraits.Navigation.padding)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("settings.about_this_app.heading")
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	@ViewBuilder private func header() -> some View {
		VStack(alignment: .leading, spacing: 0) {
			
			HStack {
				Spacer()
				
				Image(ImageResource.Settings.logo)
					.resizable()
					.scaledToFit()
					.accessibilityLabel(Text("settings.about_this_app.logo_accessibility"))
					.accessibilityIdentifier("settings.about_this_app.logo")
					.frame(maxHeight: ViewTraits.Logo.maxHeight)
				
				Spacer()
			}
			
			Text("common.app_name")
				.rijksoverheidStyle(font: .bold, style: .body)
				.foregroundStyle(theme.contentPrimary)
				.padding(ViewTraits.General.padding)
				.accessibilityIdentifier("common.app_name")
		}
		.listRowInsets(ViewTraits.General.inset)
	}
	
	/// Get the view for the version row
	/// - Returns: Button for the version row
	@ViewBuilder private func versionRow() -> some View {
		
		Button {
			viewModel.reduce(.showSharedCoreVersion)
		} label: {
			SettingsRowView(
				heading: "settings.about_this_app.version",
				subHeading: LocalizedStringKey(viewModel.appVersion),
				showChevron: false
			)
		}
		.accessibilityIdentifier("settings.about_this_app.version")
		.frame(
			maxWidth: .infinity,
			minHeight: ViewTraits.Button.minimumHeight
		)
		.listRowInsets(ViewTraits.General.inset)
		.alert("settings.about_this_app.version", isPresented: $viewModel.showSharedCoreVersionDialog) {
			Button(String(localized: "common.ok").uppercased(), role: .cancel) { /* no action available */ }
				.accessibilityIdentifier("common.ok")
		} message: {
			Text(viewModel.sharedCoreVersion ?? "")
		}
	}
	
	/// Get the view for the safety row
	/// - Returns: Button for the safety row
	@ViewBuilder private func safetyRow() -> some View {
		
		Button {
			viewModel.reduce(.showSafety)
		} label: {
			SettingsRowView(
				heading: "settings.about_this_app.safety"
			)
		}
		.accessibilityIdentifier("settings.about_this_app.safety")
		.frame(
			maxWidth: .infinity,
			minHeight: ViewTraits.Button.minimumHeight
		)
		.listRowInsets(ViewTraits.General.inset)
	}
	
	/// Get the view for the open source row
	/// - Returns: Button for the open source row
	@ViewBuilder private func openSourceRow() -> some View {
		
		Button {
			viewModel.reduce(.showOpenSource)
		} label: {
			SettingsRowView(
				heading: "settings.about_this_app.open_source"
			)
		}
		.accessibilityIdentifier("settings.about_this_app.open_source")
		.frame(
			maxWidth: .infinity,
			minHeight: ViewTraits.Button.minimumHeight
		)
		.listRowInsets(ViewTraits.General.inset)
	}
	
	/// Get the view for the accessibility row
	/// - Returns: Button for the accessibility row
	@ViewBuilder private func accessibilityRow() -> some View {
		
		Button {
			viewModel.reduce(.showAccessibility)
		} label: {
			SettingsRowView(
				heading: "settings.about_this_app.accessibility"
			)
		}
		.accessibilityIdentifier("settings.about_this_app.accessibility")
		.frame(
			maxWidth: .infinity,
			minHeight: ViewTraits.Button.minimumHeight
		)
		.listRowInsets(ViewTraits.General.inset)
	}

	@ViewBuilder private func privacy() -> some View {
		
		Button {
			viewModel.reduce(.showPrivacy)
		} label: {
			SettingsRowView(
				heading: "settings.about_this_app.privacy",
				showExternalLink: true
			)
		}
		.accessibilityIdentifier("settings.about_this_app.privacy")
		.frame(
			maxWidth: .infinity,
			minHeight: ViewTraits.Button.minimumHeight
		)
		.listRowInsets(ViewTraits.General.inset)
	}
	
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AboutTheAppView(viewModel: AboutTheAppViewModel(coordinator: nil))
	}
}
