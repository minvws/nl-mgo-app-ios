/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AboutSafetyTipsViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
	}
	
	/// Create the accessibility ViewModel
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AboutSafetyTipsViewModel.Action) {
		
		if action == .backButtonPressed {
			coordinator?.handle(.backButtonPressed)
		}
	}
}

struct AboutSafetyTipsView: View {
	
	/// The View Model
	@StateObject var viewModel: AboutSafetyTipsViewModel
	
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
		enum Row {
			static let spacing: CGFloat = 4
		}
	}
	
	var body: some View {
		
		List {
			Section {
				row(
					heading: "settings.about_this_app_safety.security_phone.heading",
					subheading: "settings.about_this_app_safety.security_phone.subheading"
				)
				row(
					heading: "settings.about_this_app_safety.install_updates.heading",
					subheading: "settings.about_this_app_safety.install_updates.subheading"
				)
				row(
					heading: "settings.about_this_app_safety.public_wifi.heading",
					subheading: "settings.about_this_app_safety.public_wifi.subheading"
				)
				row(
					heading: "settings.about_this_app_safety.permissions.heading",
					subheading: "settings.about_this_app_safety.permissions.subheading"
				)
				row(
					heading: "settings.about_this_app_safety.safe_apps.heading",
					subheading: "settings.about_this_app_safety.safe_apps.subheading"
				)
				row(
					heading: "settings.about_this_app_safety.phone_yourself.heading",
					subheading: "settings.about_this_app_safety.phone_yourself.subheading"
				)
			} header: {
				Text("settings.about_this_app.safety.subheading")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.textCase(nil)
					.padding(.top, ViewTraits.Navigation.padding)
			}
			.listRowInsets(ViewTraits.General.inset)
		}
		.backportScrollContentBackground(.hidden)
		.backportVerticalContentMargins(ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationTitle("settings.about_this_app.safety")
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	@ViewBuilder private func row(heading: LocalizedStringKey, subheading: LocalizedStringKey) -> some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.Row.spacing) {
			Text(heading)
				.rijksoverheidStyle(font: .bold, style: .body)
				.foregroundStyle(theme.contentPrimary)
			
			Text(subheading)
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
		}
		.padding(ViewTraits.General.padding)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AboutSafetyTipsView(viewModel: AboutSafetyTipsViewModel(coordinator: nil))
	}
}
