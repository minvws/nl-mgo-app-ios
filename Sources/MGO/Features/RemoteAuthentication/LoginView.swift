/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class LoginViewModel: ObservableObject {
	
	@Published var isEIDASenabled: Bool = false
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case loginWithDigiD
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// Initializer
	/// - Parameter coordinator: The coordinator
	init(coordinator: (any Coordinator)?) {
		
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		
		switch action {
			case .loginWithDigiD:
				coordinator?.handle(Coordination.Action.loggedInWithDigiD)
		}
	}
}

struct LoginView: View {
	
	/// The view model
	@StateObject var viewModel: LoginViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Color scheme (light, dark)
	@Environment(\.colorScheme) var colorScheme
	
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
				icon: Image(ImageResource.Woman.womanWithPhone),
				heading: "login.heading",
				subHeading: "login.subheading",
				textAlignment: .leading,
				textSpacing: ViewTraits.General.spacing,
				titleStyle: .largeTitle,
				subHeadingForegroundColor: theme.contentPrimary
			)
			
		} bottomView: {
			CallToActionButton(
				"login.digid",
				icon: Image(ImageResource.RemoteAuthentication.digid),
				style: .loginWithDigiD
			) {
				viewModel.reduce(.loginWithDigiD)
			}
			.accessibilityIdentifier("login.digid")
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
			LoginView(viewModel: LoginViewModel(coordinator: nil)
		)
	}
}
