/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import RestrictedBrowser

/// View model responsible for managing the state and actions of the login screen.
class LoginViewModel: ObservableObject {
	
	/// Represents the current UI state of the login view.
	struct LoginState {
		/// The mode that determines which variant of the login screen is shown.
		var mode: LoginViewMode
		/// Whether an authentication request is currently in progress.
		var isLoading: Bool
	}
	
	/// Determines which variant of the login screen is presented to the user.
	enum LoginViewMode {
		/// The user is logging in for the first time.
		case firstTime
		/// The user has logged in before.
		case repeatVisitor
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case loginWithDigiD
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	/// The remote authentication client
	private var remoteAuthenticationClient: RemoteAuthenticationClientProtocol?
	
	/// Helper to open urls
	private var urlOpener: URLOpenerProtocol
	
	/// What mode are we running in?
	private var mode: LoginViewMode
	
	/// The state of the view
	@Published var state: LoginViewModel.LoginState
	
	/// Create a Login ViewModel
	/// - Parameter coordinator: The flow coordinator used for routing after a successful login.
	/// - Parameter mode: The login mode, determining which screen variant is shown.
	/// - Parameter remoteAuthenticationClient: The client used to fetch the authentication URL.
	/// - Parameter urlOpener: The helper used to open the authentication URL in a browser.
	@MainActor init(
		coordinator: (any Coordinator)?,
		mode: LoginViewMode,
		remoteAuthenticationClient: RemoteAuthenticationClientProtocol?,
		urlOpener: URLOpenerProtocol = UIApplication.shared
	) {
		
		self.coordinator = coordinator
		self.mode = mode
		self.remoteAuthenticationClient = remoteAuthenticationClient
		self.urlOpener = urlOpener
		self.state = LoginState(mode: mode, isLoading: false)
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor public func reduce(_ action: Action) {
		
		if action == .loginWithDigiD {
			_Concurrency.Task(priority: .userInitiated) {
				await authenticate()
			}
		}
	}
	
	/// Fetch the authentication url and open it.
	@MainActor
	private func authenticate() async {
		
		guard state.isLoading == false else { return }
		self.setState(LoginState(mode: self.mode, isLoading: true))
		guard let remoteAuthenticationClient else { return }
		do {
			let authenticationUrl = try await remoteAuthenticationClient.getAuthenticationUrl(callbackUrl: Configuration().getOIDCCallback())
			logVerbose("LoginView - authenticationUrl", authenticationUrl)
			self.urlOpener.openUrlIfPossible(authenticationUrl)
		} catch {
			logError("Error fetching oidc start \(error)")
		}
		self.setState(LoginState(mode: self.mode, isLoading: false))
	}
	
	/// Set the state (to be called from async methods)
	@MainActor func setState(_ newState: LoginState) {
		self.state = newState
	}
}

/// The login screen, allowing users to authenticate via DigiD.
/// Displays a heading, sub-heading and illustration that adapt based on whether the user
/// is logging in for the first time or is a returning visitor.
struct LoginView: View {
	
	/// The view model
	@StateObject var viewModel: LoginViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Dependency injectable OS Version Checker
	@Injected(\.osVersionChecker) private var osVersionChecker
	
	/// Magic Numbers
	private struct ViewTraits {
		
		enum Button {
			static let insets = EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
			static let cornerRadius: CGFloat = 12
			static let roundedRadius: CGFloat = 1000
			static let minimumHeight: CGFloat = 50
			static let opacity: Double = 0.75
		}
		enum Icon {
			static let opacity: Double = 0.50
		}
		enum Image {
			static let maxWidthFirstTime: Double = 0.9
			static let maxWidthRepearVisitor: Double = 0.63
		}
		
		enum General {
			static let spacing: CGFloat = 16
		}
		
		enum ButtonTitle {
			static let insets = EdgeInsets(top: 16, leading: 24, bottom: 16, trailing: 24)
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			ImageContentView(
				icon: Image(
					viewModel.state.mode == .firstTime ? ImageResource.RemoteAuthentication.passport : ImageResource.Placeholder.onboarding
				),
				heading: "login.heading",
				subHeading: "login.subheading",
				configuration: ImageContentView.Configuration(
					textAlignment: .leading,
					textSpacing: ViewTraits.General.spacing,
					titleStyle: .headingExtraLarge,
					subHeadingForegroundColor: theme.labels.primary,
					order: .contentFirst,
					maxWidthPercentage: viewModel.state.mode == .firstTime ? ViewTraits.Image.maxWidthFirstTime : ViewTraits.Image.maxWidthRepearVisitor,
					hideIconInLandscape: false,
					headingAsNavigationTitle: true
				)
			)
			.padding(.horizontal, ViewTraits.General.spacing)
			
		} bottomView: {
			VStack {
				
				if viewModel.state.isLoading {
					CallToActionButton(
						"login.loading",
						style: .solidLeadingSpinner(rounded: osVersionChecker.available(version: .iOS(.v26)))
					)
					.accessibilityIdentifier("login.loading")
				} else {
					digidButton()
				}
			}
			.padding(ViewTraits.Button.insets)
		}
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden()
		.background(theme.backgrounds.primary.ignoresSafeArea())
		.layoutForIPad()
	}
	
	/// Whether the user is currently pressing (but has not yet released) the DigiD button.
	@State private var onHover = false
	
	/// The button to use DigiD for authentication
	/// - Returns: the button
	@ViewBuilder private func digidButton() -> some View {
		
		HStack {
			Spacer()
			
			Image(ImageResource.RemoteAuthentication.digid)
				.opacity(onHover ? ViewTraits.Icon.opacity : 1)
			
			Text("login.digid")
				.typography(.bodyMedium, with: .bold)
			
			Spacer()
		}
		.foregroundColor(theme.actions.solid.text.opacity(onHover ? ViewTraits.Button.opacity : 1))
		.tint(theme.actions.solid.text)
		.padding(ViewTraits.ButtonTitle.insets)
		.frame(maxWidth: .infinity, minHeight: ViewTraits.Button.minimumHeight, alignment: .center)
		.background(theme.actions.solid.background.opacity(onHover ? ViewTraits.Button.opacity : 1))
		.cornerRadius(osVersionChecker.available(version: .iOS(.v26)) ? ViewTraits.Button.roundedRadius : ViewTraits.Button.cornerRadius)
		.accessibilityAddTraits(.isButton)
		.accessibilityIdentifier("login.digid")
		._onButtonGesture { pressed in
			self.onHover = pressed
		} perform: {
			viewModel.reduce(.loginWithDigiD)
		}
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		LoginView(
			viewModel: LoginViewModel(
				coordinator: nil,
				mode: .firstTime,
				remoteAuthenticationClient: nil
			)
		)
	}
}
