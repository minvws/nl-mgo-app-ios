/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI
import MGOFoundation

class IntroductionViewModel: ObservableObject {
	
	/// The app coordinator for routing
	weak var coordinator: (any Coordinator)?
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case nextButttonPressed
	}
	
	/// Intitializer
	/// - Parameter coordinator: the app coordinator
	init(coordinator: (any Coordinator)?) {
		self.coordinator = coordinator

	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor func reduce(_ action: IntroductionViewModel.Action) {
		switch action {
			case .nextButttonPressed:
				coordinator?.handle(Coordination.Action.nextButtonPressedOnIntroduction)
		}
	}
}

struct IntroductionView: View {
	
	/// The view model
	@StateObject var viewModel: IntroductionViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Boolean to determine if the header image should be shown (hidden in landscape)
	@State var showImage = true
	
	/// helper to calculate the size of the view
	@State private var contentSize: CGSize = .zero
	
	/// The size classes
	@Environment(\.verticalSizeClass) var verticalSizeClass: UserInterfaceSizeClass?
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic numbers
	private struct ViewTraits {
		enum General {
			static let padding: CGFloat = 16
		}
		enum Icon {
			static let maxWidth: Double = 0.63
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			ImageContentView(
				icon: Image(ImageResource.Placeholder.onboarding),
				heading: "introduction.heading",
				subHeading: "introduction.subheading",
				configuration: ImageContentView.Configuration(
					textAlignment: .leading,
					textSpacing: ViewTraits.General.padding,
					titleStyle: .headingExtraLarge,
					subHeadingForegroundColor: theme.labels.primary,
					order: .contentFirst,
					maxWidthPercentage: ViewTraits.Icon.maxWidth,
					hideIconInLandscape: false
				)
			)
			.padding(.horizontal, ViewTraits.General.padding)
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
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden()
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		IntroductionView(viewModel: IntroductionViewModel(coordinator: nil))
	}
}
