/*
 *  Copyright (c) 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class AboutAccessibilityViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case moreInformationTapped
	}
	
	/// Create the accessibility ViewModel
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: AboutAccessibilityViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .moreInformationTapped:
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
				informationButton()
			}
			.listRowInsets(ViewTraits.General.inset)
			.padding(ViewTraits.General.padding)
		}
		.backportScrollContentBackground(.hidden)
		.backportVerticalContentMargins(ViewTraits.Navigation.padding)
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
