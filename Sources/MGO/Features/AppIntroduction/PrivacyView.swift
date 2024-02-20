/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class PrivacyViewModel: ObservableObject {
	
	/// The app coordintator for routing
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
	func reduce(_ action: PrivacyViewModel.Action) {
		
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

struct PrivacyView: View {
	
	/// The View Model
	@StateObject var viewModel: PrivacyViewModel
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum CloseButton {
			static let insets = EdgeInsets( top: 14, leading: 0, bottom: 14, trailing: 14
			)
		}
		enum PrivacyStatement {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
		}
	}
	
	var body: some View {
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			ScrollViewWithFixedBottom {
				
				VStack {
					
					Text("privacy_title")
						.rijksoverheidStyle(font: .bold, style: .title2)
						.foregroundColor(Color.Styleguide.black)
						.padding(.bottom, ViewTraits.General.padding)
						.frame(maxWidth: .infinity, alignment: .topLeading)
						.accessibilityAddTraits(.isHeader)
					
					Group {
						let privacyIntro = String(localized: "privacy_intro")
						let statement = String(localized: "privacy_statement")
						let elements = privacyIntro.components(separatedBy: "%@")
						if elements.count == 2 {
							Text(elements[0]) +
							Text("**[\(statement)](/privacystatement)**").underline() +
							Text(elements[1])
						} else {
							EmptyView()
						}
					}
						.rijksoverheidStyle(font: .regular, style: .body)
						.padding(.bottom, ViewTraits.General.padding)
						.foregroundColor(Color.Styleguide.black)
						.tint(colorScheme == .light ? Color.Styleguide.Blue.link : Color.Styleguide.Blue.skyBlueTint1)
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
						PrivacyShieldView("privacy_item_1", shieldType: .encrypted)
						PrivacyShieldView("privacy_item_2", shieldType: .safety)
						PrivacyShieldView("privacy_item_3", shieldType: .checked)
						PrivacyShieldView("privacy_item_4", shieldType: .cross)
					}
					
					Spacer()
				}
				.padding(.horizontal, ViewTraits.General.padding)
			} bottomView: {
				
				Button(
					action: {
						viewModel.reduce(.nextButttonPressed)
					},
					label: {
						SkyBlueButton("onboarding_action")
					}
				)
				.padding(ViewTraits.General.padding)
			}
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.navigationBarTitleDisplayMode(.inline)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		PrivacyView(viewModel: PrivacyViewModel())
	}
}
