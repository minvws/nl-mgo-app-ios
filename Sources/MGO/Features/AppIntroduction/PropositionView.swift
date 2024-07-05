/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class PropositionViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case privacyLinkClicked
		case nextButttonPressed
		case backButtonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)? = nil) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: PropositionViewModel.Action) {
		
		switch action {
			case .privacyLinkClicked:
				coordinator?.handle(Coordination.Action.showPrivacyStatement)
			case .nextButttonPressed:
				coordinator?.handle(Coordination.Action.nextButtonPressedOnProposition)
			case .backButtonPressed:
				coordinator?.handle(Coordination.Action.backButtonPressed)
		}
	}
}

struct PropositionView: View {
	
	/// The View Model
	@StateObject var viewModel: PropositionViewModel
	
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
				.onTapGesture {
					// Only called in VoiceOVer on iOS 15/16
					if let url = URL(string: "/privacystatement") {
						_ = handleURL(url)
					}
				}
				.environment(\.openURL, OpenURLAction(handler: handleURL))
				.rijksoverheidStyle(font: .regular, style: .body)
				.padding(.bottom, ViewTraits.General.padding)
				.foregroundStyle(theme.contentPrimary)
				.tint(theme.actionTertiaryDefault)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				.accessibilityIdentifier("introduction text")
				.tag("privacylink")
				
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
			
			CallToActionButton("common.next") {
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
		.layoutForIPad()
	}
	
	func handleURL(_ url: URL) -> OpenURLAction.Result {
		guard url.absoluteString.lowercased() == "/privacystatement" else {
			return .discarded
		}
		viewModel.reduce(.privacyLinkClicked)
		return .handled
		}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		PropositionView(viewModel: PropositionViewModel())
	}
}
