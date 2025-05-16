/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOUI

class LoginInfoViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case nextButttonPressed
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// Create the login info view model
	/// - Parameter coordinator: The coordinator
	init(coordinator: (any Coordinator)?) {
		
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		
		if action == .nextButttonPressed {
			coordinator?.handle(Coordination.Action.nextButtonPressedOnLoginInfo)
		}
	}
}

struct LoginInfoView: View {
	
	/// The view model
	@StateObject var viewModel: LoginInfoViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
		}
		enum General {
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			ImageContentView(
				icon: Image(ImageResource.Woman.womanWithPhoneCheck),
				heading: "login_info.heading",
				subHeading: "login_info.subheading",
				textAlignment: .leading,
				textSpacing: ViewTraits.General.spacing,
				titleStyle: .largeTitle,
				subHeadingForegroundColor: theme.contentPrimary
			)
			.padding(.horizontal, ViewTraits.General.spacing)
			
		} bottomView: {
			CallToActionButton("common.next") {
				viewModel.reduce(.nextButttonPressed)
			}
			.accessibilityIdentifier("common.next")
			.padding(ViewTraits.Button.insets)
		}
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden()
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		LoginInfoView(viewModel: LoginInfoViewModel(coordinator: nil)
		)
	}
}
