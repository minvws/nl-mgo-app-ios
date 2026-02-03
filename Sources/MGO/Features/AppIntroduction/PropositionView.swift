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
			static let bottom: CGFloat = 24
		}
		enum Items {
			static let bottom: CGFloat = 16
		}
	}
	
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
				
				Text("proposition.subheading")
					.accessibilityIdentifier("proposition.subheading")
					.typography(.bodyMedium)
					.padding(.bottom, ViewTraits.General.bottom)
					.foregroundStyle(theme.labels.primary)
					.tint(theme.actions.ghost.text)
					.frame(maxWidth: .infinity, alignment: .topLeading)
				
				VStack(spacing: ViewTraits.Items.bottom) {
					PrivacyShieldView(
						"proposition.statement.heading_1",
						subHeading: "proposition.statement.subheading_1",
						shieldType: .secure
					)
						.accessibilityIdentifier("proposition.statement_1")

					PrivacyShieldView(
						"proposition.statement.heading_2",
						subHeading: "proposition.statement.subheading_2",
						shieldType: .personal
					)
					.accessibilityIdentifier("proposition.statement_2")
					
					PrivacyShieldView(
						"proposition.statement.heading_3",
						subHeading: "proposition.statement.subheading_3",
						shieldType: .storage
					)
					.accessibilityIdentifier("proposition.statement_3")
					
					PrivacyShieldView(
						"proposition.statement.heading_4",
						subHeading: "proposition.statement.subheading_4",
						shieldType: .control
					)
					.accessibilityIdentifier("proposition.statement_4")
				}
				
				Spacer()
			}
			.padding(.horizontal, ViewTraits.General.padding)
			.padding(.top, ViewTraits.Navigation.padding)
		} bottomView: {

			VStack(spacing: ViewTraits.General.padding) {
				
				let rounded = osVersionChecker.available(version: .iOS(.v26))
				
				CallToActionButton(
					"proposition.open_privacy.button",
					style: .tonal(rounded: rounded)
				) {
					viewModel.reduce(.privacyLinkClicked)
				}
				.accessibilityIdentifier("proposition.open_privacy.button")
				
				CallToActionButton(
					"common.next",
					style: .solid(
						rounded: rounded,
						narrow: false
					)
				) {
					viewModel.reduce(.nextButttonPressed)
				}
				.accessibilityIdentifier("common.next")
			}
			.padding(ViewTraits.General.padding)
		}
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		PropositionView(viewModel: PropositionViewModel())
	}
}
