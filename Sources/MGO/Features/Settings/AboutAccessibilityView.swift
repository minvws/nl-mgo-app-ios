/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AboutAccessibilityViewModel: BaseViewModel {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case moreInformationTapped
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AboutAccessibilityViewModel.Action) {
		
		if action == .moreInformationTapped {
			coordinator?.handle(.showAccessibilityMoreInformation)
		}
	}
}

struct AboutAccessibilityView: View {
	
	/// The View Model
	@StateObject var viewModel: AboutAccessibilityViewModel
	
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
	}
	
	var body: some View {
		
		List {
			Section {
				
				subheading()
				// informationButton() // Disabled until link is clear.
			}
			.listRowInsets(ViewTraits.General.inset)
			.padding(ViewTraits.General.padding)
		}
		.backportScrollContentBackground(.hidden)
		.backportContentMargins(ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden()
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationTitle("settings.accessibility.heading")
		.navigationBarTitleDisplayMode(.inline)
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// Get the sub heading
	/// - Returns: the sub heading view
	@ViewBuilder private func subheading() -> some View {
		
		Text("settings.accessibility.subheading")
			.rijksoverheidStyle(font: .regular, style: .body)
			.foregroundStyle(theme.contentPrimary)
			.accessibilityIdentifier("settings.accessibility.subheading")
	}
	
	/// The more information button
	/// - Returns: the button for more information
	@ViewBuilder private func informationButton() -> some View {
		
		Button {
			viewModel.reduce(.moreInformationTapped)
		} label: {
			HStack(spacing: ViewTraits.General.padding) {
				
				Text("settings.accessibility.more_information")
					.rijksoverheidStyle(font: .regular, style: .body)
					.foregroundStyle(theme.interactionTertiaryDefaultText)
				
				Spacer()
				
				Image(ImageResource.Settings.arrowOutward)
					.tint(theme.symbolSecondary)
			}
		}
		.accessibilityIdentifier("settings.accessibility.more_information")
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		AboutAccessibilityView(viewModel: AboutAccessibilityViewModel(coordinator: nil))
	}
}
