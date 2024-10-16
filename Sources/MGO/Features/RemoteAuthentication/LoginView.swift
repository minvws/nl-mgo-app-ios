/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class LoginViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case loginWithDigiD
		case loginWithEIDAS
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
			case .loginWithDigiD, .loginWithEIDAS:
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
	
	@State private var isScrolling: Bool = false
	
	/// Magic Numbers
	private struct ViewTraits {
		enum Navigation {
			static let padding: CGFloat = 8
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum Button {
			static let top: CGFloat = 8
			static let spacing: CGFloat = 16
		}
	}
	
	var body: some View {
		
		ScrollView {
			
			VStack(spacing: ViewTraits.General.padding) {
				
				Text("login.subheading")
					.rijksoverheidStyle(font: .regular, style: .body)
					.accessibilityIdentifier("login.subheading")
					.foregroundStyle(theme.contentPrimary)
					.frame(maxWidth: .infinity, alignment: .topLeading)
				
				VStack(spacing: ViewTraits.Button.spacing, content: {
					
					DisclosureWithImageButton(
						title: "login.digid",
						image: ImageResource.RemoteAuthentication.digid,
						showImageBorder: colorScheme == .dark) {
							viewModel.reduce(.loginWithDigiD)
						}
						.accessibilityIdentifier("login.digid")
					
					DisclosureWithImageButton(
						title: "login.european",
						image: ImageResource.RemoteAuthentication.eidas) {
							viewModel.reduce(.loginWithEIDAS)
						}
						.accessibilityIdentifier("login.european")
				})
				.padding(.top, ViewTraits.Button.top)
			}
			.padding(.horizontal, ViewTraits.General.padding)
		}
		.backportOnScrollPhaseChanged($isScrolling)
		.preference(key: IsScrollingPreferenceKey.self, value: [isScrolling])
		.navigationBarBackButtonHidden(true)
		.navigationBarHidden(false)
		.navigationTitle("login.heading")
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
