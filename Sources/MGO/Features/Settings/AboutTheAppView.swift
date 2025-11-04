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
	@Published var hcimCoreVersion: String?
	
	/// Show the shared core version dialog
	@Published var showHCIMCoreVersionDialog: Bool = false
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case showHCIMCoreVersion
		case showSafety
		case showOpenSource
		case showAccessibility
		case showPrivacy
	}
	
	/// Create the settings view model
	/// - Parameter coordinator: the app coordinator
	override init(coordinator: (any Coordinator)? = nil) {
		
		appVersion = "\(Container.shared.appVersionSupplier().getCurrentVersion()) (\(Container.shared.appVersionSupplier().getCurrentBuild()))"
		super.init(coordinator: coordinator)
		
		do {
			hcimCoreVersion = try HCIMParser().getVersion()
		} catch {
			logError("No shared core version found: \(error)")
		}
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: AboutTheAppViewModel.Action) {
		
		switch action {
			
			case .showHCIMCoreVersion:
				if hcimCoreVersion != nil {
					showHCIMCoreVersionDialog = true
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
	
	/// The horizontal size classes (to determine the layout)
	@Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
	
	@State private var contentSize: CGSize = .zero
	
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
			static let minimumHeight: CGFloat = 50
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
		.backport.scrollContentBackground(.hidden)
		.backport.contentMargins(ViewTraits.Navigation.padding)
		.environment(\.defaultMinListHeaderHeight, ViewTraits.General.padding / 2)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.navigationBarTitleDisplayMode(.inline)
		.navigationTitle("settings.about_this_app.heading")
		.background(theme.backgrounds.primary.ignoresSafeArea())
	}
	
	@ViewBuilder private func header() -> some View {
		VStack(alignment: .leading, spacing: 0) {
			HStack(alignment: .top) {
				Spacer()
				
				Image(
					horizontalSizeClass == .regular ? ImageResource.Settings.Rijkslint.basis : ImageResource.Settings.Rijkslint.compact
				)
				.accessibilityLabel(Text("settings.about_this_app.logo_accessibility"))
				.accessibilityIdentifier("settings.about_this_app.logo")
				.frame(maxWidth: max(0, contentSize.width - 32))
				
				Spacer()
			}
			.frame(maxWidth: .infinity, alignment: .top)
			
			Text("common.app_name")
				.typography(.bodyMedium, isBold: true)
				.foregroundStyle(theme.labels.primary)
				.fixedSize(horizontal: false, vertical: true)
				.accessibilityIdentifier("common.app_name")
				.frame(maxWidth: .infinity, alignment: .leading)
				.padding(.top, -16)
		}
		.padding(.top, -16)
		.listRowInsets(ViewTraits.General.inset)
		.readSize($contentSize)
		.logInfo("$contentSize", contentSize)
	}
	
	/// Get the view for the version row
	/// - Returns: Button for the version row
	@ViewBuilder private func versionRow() -> some View {
		
		Button {
			viewModel.reduce(.showHCIMCoreVersion)
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
		.alert("settings.about_this_app.version", isPresented: $viewModel.showHCIMCoreVersionDialog) {
			Button(String(localized: "common.ok").uppercased(), role: .cancel) { /* no action available */ }
				.accessibilityIdentifier("common.ok")
		} message: {
			Text(viewModel.hcimCoreVersion ?? "")
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
	
	/// Show the privacy statement row
	/// - Returns: Button for the privacy statement
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
