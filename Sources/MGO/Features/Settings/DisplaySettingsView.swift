/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct DisplaySettingsView: View {
	
	/// The View Model
	@StateObject var viewModel: BaseViewModel
	
	/// The application appearance for light / dark / system mode
	@AppStorage("AppAppearance") private var selectedAppearance: AppAppearance = .system
	
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
		enum Icon {
			static let size: CGFloat = 24
		}
	}
	
	/// Should we adjust the layout for iPad (i.e., are we running on an iPad)?
	private var shouldLayoutForiPad: Bool { return UIDevice.current.userInterfaceIdiom == .pad }
	
	var body: some View {
		
		List {
			Section {
				displayModeOption("settings.display.system.heading", appearance: .system)
					.accessibilityIdentifier("settings.display.system")
				displayModeOption("settings.display.light", appearance: .light)
					.accessibilityIdentifier("settings.display.light")
				displayModeOption("settings.display.dark", appearance: .dark)
					.accessibilityIdentifier("settings.display.dark")
				
			} footer: {
				Text(shouldLayoutForiPad ? "settings.display.footer_ipad" : "settings.display.footer")
					.rijksoverheidStyle(font: .regular, style: .callout)
					.foregroundStyle(theme.contentSecondary)
			}
		}
		.backportScrollContentBackground(.hidden)
		.backportContentMargins(ViewTraits.Navigation.padding, edges: .top)
		.navigationTitle("settings.display.heading")
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton("settings.heading") {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarHidden(false)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// Build a button for a display mode option
	/// - Parameters:
	///   - title: the title of the button
	///   - appearance: the appearance to select
	/// - Returns: View to select a display mode option
	@ViewBuilder private func displayModeOption(_ title: LocalizedStringKey, appearance: AppAppearance) -> some View {
		
		Button {
			selectedAppearance = appearance
		} label: {
			HStack(spacing: 0) {
				
				Text(title)
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.contentPrimary)
					.frame(minHeight: ViewTraits.Icon.size)
				
				if selectedAppearance == appearance {
				
					Spacer()
					
					Image(ImageResource.Settings.check)
						.tint(theme.interactionTertiaryDefaultText)
						.frame(
							width: ViewTraits.Icon.size,
							height: ViewTraits.Icon.size,
							alignment: .center
						)
				}
			}
			.padding(ViewTraits.General.padding)
		}
		.listRowInsets(ViewTraits.General.inset)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		DisplaySettingsView(viewModel: BaseViewModel(coordinator: nil))
	}
}
