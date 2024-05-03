/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class PrivacyOverviewViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case privacyLinkClicked
		case nextButttonPressed
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any AppCoordinatorProtocol)? = nil) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: PrivacyOverviewViewModel.Action) {
		
		switch action {
			case .privacyLinkClicked:
				coordinator?.handle(AppCoordination.Action.showPrivacyStatement)
			case .nextButttonPressed:
				coordinator?.handle(.nextButtonPressedOnPrivacyOverview)
			case .backButtonPressed:
				coordinator?.handle(AppCoordination.Action.backButtonPressed)
		}
	}
}

struct PrivacyOverviewView: View {
	
	/// The View Model
	@StateObject var viewModel: PrivacyOverviewViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum Items {
			static let bottom: CGFloat = 24
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(spacing: 0) {
				
				Text("privacyoverview_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.foregroundStyle(theme.contentPrimary)
					.padding(.bottom, ViewTraits.General.padding)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				Group {
					let privacyIntro = String(localized: "privacyoverview_intro")
					let statement = String(localized: "privacy_statement")
					let elements = privacyIntro.components(separatedBy: "%@")
					if elements.count == 2 {
						Text(elements[0]) +
						Text("[\(statement)](/privacystatement)").underline() +
						Text(elements[1])
					} else {
						EmptyView()
					}
				}
				.rijksoverheidStyle(font: .regular, style: .body)
				.padding(.bottom, ViewTraits.General.padding)
				.foregroundStyle(theme.contentPrimary)
				.tint(theme.actionTertiaryDefault)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.environment(\.openURL, OpenURLAction { url in
					// Catch the click on the privacy link
					guard url.absoluteString.lowercased() == "/privacystatement" else {
						return .discarded
					}
					viewModel.reduce(.privacyLinkClicked)
					return .handled
				})
				.accessibilityIdentifier("introduction text")
				
				Group {
					PrivacyShieldView("privacyoverview_item_1", shieldType: .encrypted)
					PrivacyShieldView("privacyoverview_item_2", shieldType: .safety)
					PrivacyShieldView("privacyoverview_item_3", shieldType: .checked)
					PrivacyShieldView("privacyoverview_item_4", shieldType: .cross)
				}
				.padding(.bottom, ViewTraits.Items.bottom)
				
				Spacer()
			}
			.padding(.horizontal, ViewTraits.General.padding)
		} bottomView: {
			
			CallToActionButton("onboarding_action") {
				viewModel.reduce(.nextButttonPressed)
			}
			.padding(ViewTraits.General.padding)
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		PrivacyOverviewView(viewModel: PrivacyOverviewViewModel())
	}
}
