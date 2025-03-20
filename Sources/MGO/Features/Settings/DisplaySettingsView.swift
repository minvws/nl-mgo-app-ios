/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

struct DisplaySettingsView: View {
	
	@AppStorage("AppAppearance") private var selectedAppearance: AppAppearance = .system
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
			static let inset: EdgeInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
		}
		enum Icon {
			static let size: CGFloat = 24
		}
	}
	
	var body: some View {
		
		VStack {
			List {
				Section {
					displayModeOption("Systeem", appearance: .system)
						.accessibilityIdentifier("System")
					displayModeOption("Licht", appearance: .light)
						.accessibilityIdentifier("Light")
					displayModeOption("Donker", appearance: .dark)
						.accessibilityIdentifier("Dark")
				}
				footer: {
					Text("“Systeem” volgt de instellingen van je telefoon.")
						.rijksoverheidStyle(font: .regular, style: .callout)
						.foregroundStyle(theme.contentSecondary)
				}
			}
			.backportScrollContentBackground(.hidden)
		}
		.navigationTitle("Weergave")
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
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
					
					Image(ImageResource.Icon.check)
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
		DisplaySettingsView()
	}
}
