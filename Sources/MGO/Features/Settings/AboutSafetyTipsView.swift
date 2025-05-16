/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

struct AboutSafetyTipsView: View {
	
	/// The View Model
	@StateObject var viewModel: BaseViewModel
	
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
				viewForSafetyTip(
					heading: "settings.about_this_app_safety.security_phone.heading",
					subheading: "settings.about_this_app_safety.security_phone.subheading"
				)
				viewForSafetyTip(
					heading: "settings.about_this_app_safety.phone_yourself.heading",
					subheading: "settings.about_this_app_safety.phone_yourself.subheading"
				)
				viewForSafetyTip(
					heading: "settings.about_this_app_safety.install_updates.heading",
					subheading: "settings.about_this_app_safety.install_updates.subheading"
				)
				viewForSafetyTip(
					heading: "settings.about_this_app_safety.safe_apps.heading",
					subheading: "settings.about_this_app_safety.safe_apps.subheading"
				)
				viewForSafetyTip(
					heading: "settings.about_this_app_safety.public_wifi.heading",
					subheading: "settings.about_this_app_safety.public_wifi.subheading"
				)
				viewForSafetyTip(
					heading: "settings.about_this_app_safety.permissions.heading",
					subheading: "settings.about_this_app_safety.permissions.subheading"
				)

			} header: {
				header()
			}
			.listRowInsets(ViewTraits.General.inset)
		}
		.backportScrollContentBackground(.hidden)
		.backportContentMargins(ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationTitle("settings.about_this_app.safety")
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// Get the header for the list
	/// - Returns: the list header
	@ViewBuilder private func header() -> some View {
		
		Text("settings.about_this_app.safety.subheading")
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(theme.contentPrimary)
			.textCase(nil)
			.padding(.top, ViewTraits.Navigation.padding)
			.when(isIOS16OrOlder) { view in
				view
					.padding(.bottom, ViewTraits.Navigation.padding)
			}
			.accessibilityIdentifier("settings.about_this_app.safety.subheading")
	}
	
	/// Create a row for the safety tips
	/// - Parameters:
	///   - heading: the heading of the safety tip
	///   - subheading: the body of the safety tip
	/// - Returns: View with the safety tip
	@ViewBuilder private func viewForSafetyTip(heading: LocalizedStringKey, subheading: LocalizedStringKey) -> some View {
		
		VStack(alignment: .leading, spacing: ViewTraits.Row.spacing) {
			Text(heading)
				.rijksoverheidStyle(font: .bold, style: .body)
				.foregroundStyle(theme.contentPrimary)
				.accessibilityAddTraits(.isHeader)
				.accessibilityIdentifier(heading.stringKey)
			
			Text(subheading)
				.rijksoverheidStyle(font: .regular, style: .body)
				.foregroundStyle(theme.contentPrimary)
				.accessibilityIdentifier(subheading.stringKey)
		}
		.padding(ViewTraits.General.padding)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AboutSafetyTipsView(viewModel: BaseViewModel(coordinator: nil))
	}
}
