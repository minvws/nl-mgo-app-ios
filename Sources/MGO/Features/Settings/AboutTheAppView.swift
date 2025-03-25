/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AboutTheAppViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// The current version of the application
	@Published var version: String
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case showVersion
		case showSafety
		case showOpenSource
		case showAccessibility
	}
	
	/// Create the settings view model
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		self.coordinator = coordinator
		
		version = "\(Current.appVersionSupplier.getCurrentVersion()) (\(Current.appVersionSupplier.getCurrentBuild()))"
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AboutTheAppViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(Coordination.Action.backButtonPressed)
			
			case .showVersion:
				break
			
			case .showSafety:
				break
			
			case .showOpenSource:
				break
				
			case .showAccessibility:
				break
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
				header()
				versionRow()
				safetyRow()
				openSourceRow()
				accessibilityRow()
			}
		}
		.backportScrollContentBackground(.hidden)
		.backportVerticalContentMargins(ViewTraits.Navigation.padding)
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
				Spacer()
			}
			
			Text("common.app_name")
				.rijksoverheidStyle(font: .bold, style: .body)
				.foregroundStyle(theme.contentPrimary)
				.padding(ViewTraits.General.padding)
		}
		.listRowInsets(ViewTraits.General.inset)
	}
	
	/// Get the view for the version row
	/// - Returns: Button for the version row
	@ViewBuilder private func versionRow() -> some View {
		
		Button {
			viewModel.reduce(.showVersion)
		} label: {
			SettingsRowView(
				heading: "settings.about_this_app.version",
				subHeading: LocalizedStringKey(viewModel.version),
				showChevron: false
			)
		}
		.frame(
			maxWidth: .infinity,
			minHeight: ViewTraits.Button.minimumHeight
		)
		.listRowInsets(ViewTraits.General.inset)
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
