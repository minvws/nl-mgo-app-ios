/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

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
	@MainActor func reduce(_ action: PropositionViewModel.Action) {
		
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
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
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
	
	private let privacyLink = "/privacystatement"
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(spacing: 0) {
				
				Text("proposition.heading")
					.typography(.headingExtraLarge)
					.foregroundStyle(theme.labels.primary)
					.padding(.bottom, ViewTraits.General.padding)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
					.accessibilityIdentifier("proposition.heading")
				
				VStack(spacing: 0) {
					let privacyIntro = String(localized: "proposition.subheading")
					let elements = privacyIntro.components(separatedBy: "[%@](privacyverklaring)")
					if elements.count == 2 {
						Text(elements[0]) +
						Text("[privacyverklaring](/privacystatement)").underline() +
						Text(elements[1])
					} else {
						EmptyView()
					}
				}
				.accessibilityIdentifier("proposition.subheading")
				.onTapGesture {
					// Only called in VoiceOVer on iOS 15/16
					if let url = URL(string: privacyLink) {
						_ = handleURL(url)
					}
				}
				.environment(\.openURL, OpenURLAction(handler: handleURL))
				.typography(.bodyMedium)
				.padding(.bottom, ViewTraits.General.padding)
				.foregroundStyle(theme.labels.primary)
				.tint(theme.actions.ghost.text)
				.frame(maxWidth: .infinity, alignment: .topLeading)
				
				VStack(spacing: ViewTraits.Items.bottom) {
					PrivacyShieldView("proposition.statement_1", shieldType: .encrypted)
						.accessibilityIdentifier("proposition.statement_1")
					PrivacyShieldView("proposition.statement_2", shieldType: .safety)
						.accessibilityIdentifier("proposition.statement_2")
					PrivacyShieldView("proposition.statement_3", shieldType: .checked)
						.accessibilityIdentifier("proposition.statement_3")
					PrivacyShieldView("proposition.statement_4", shieldType: .cross)
						.accessibilityIdentifier("proposition.statement_4")
				}
				
				Spacer()
			}
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.top, ViewTraits.Navigation.padding)
		} bottomView: {
			
			CallToActionButton(
				"common.next",
				style: .solid(
					rounded: osVersionChecker.available(version: .iOS(.v26)),
					narrow: false
				)
			) {
				viewModel.reduce(.nextButttonPressed)
			}
			.accessibilityIdentifier("common.next")
			.padding(ViewTraits.General.padding)
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	private func handleURL(_ url: URL) -> OpenURLAction.Result {
		guard url.absoluteString.lowercased() == privacyLink else {
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
