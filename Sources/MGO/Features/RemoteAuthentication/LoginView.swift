/*
 *  SPDX-FileCopyrightText: 2025 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI
import RestrictedBrowser

class LoginViewModel: ObservableObject {
	
	enum State {
		case loading
		case idle
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case loginWithDigiD
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any Coordinator)?
	
	private var remoteAuthenticationClient: RemoteAuthenticationClientProtocol?
	
	/// Helper to open urls
	private var urlOpener: URLOpenerProtocol
	
	/// The state of the view
	@Published var state: LoginViewModel.State
	
	/// Create a Login ViewModel
	/// - Parameter coordinator: The coordinator
	/// - Parameter urlOpener: The helper to open hyperlinks
	@MainActor init(
		coordinator: (any Coordinator)?,
		remoteAuthenticationClient: RemoteAuthenticationClientProtocol?,
		urlOpener: URLOpenerProtocol = UIApplication.shared
	) {
		
		self.coordinator = coordinator
		self.remoteAuthenticationClient = remoteAuthenticationClient
		self.urlOpener = urlOpener
		self.state = .idle
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	@MainActor public func reduce(_ action: Action) {
		
		if action == .loginWithDigiD {
			guard !Container.shared.featureFlagManager().isDemo else {
				coordinator?.handle(Coordination.Action.loggedInWithDigiD)
				return
			}
			_Concurrency.Task(priority: .userInitiated) {
				await authenticate()
			}
		}
	}
	
	/// Fetch the authentication url and open it.
	@MainActor
	private func authenticate() async {
		
		guard state == .idle else { return }
		self.setState(.loading)
		guard let remoteAuthenticationClient else { return }
		do {
			let authenticationUrl = try await remoteAuthenticationClient.getAuthenticationUrl(callbackUrl: Configuration().getOIDCCallback())
			logDebug("authenticationUrl", authenticationUrl)
			self.urlOpener.openUrlIfPossible(authenticationUrl)
		} catch {
			logError("Error fetching oidc start \(error)")
		}
		self.setState(.idle)
	}
	
	/// Set the state (to be called from async methods)
	@MainActor func setState(_ newState: State) {
		self.state = newState
	}
}

struct LoginView: View {
	
	/// The view model
	@StateObject var viewModel: LoginViewModel
	
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
				icon: Image(ImageResource.Woman.womanWithPhone),
				heading: "login.heading",
				subHeading: "login.subheading",
				textAlignment: .leading,
				textSpacing: ViewTraits.General.spacing,
				titleStyle: .largeTitle,
				subHeadingForegroundColor: theme.contentPrimary
			)
			.padding(.horizontal, ViewTraits.General.spacing)
			
		} bottomView: {
			VStack {
				switch viewModel.state {
					case .loading:
						CallToActionButton(
							"login.loading",
							style: .primaryWithLeadingSpinner
						)
						.accessibilityIdentifier("login.loading")
						
					case .idle:
						CallToActionButton(
							"login.digid",
							icon: Image(ImageResource.RemoteAuthentication.digid),
							style: .primaryWithLeadingIcon
						) {
							viewModel.reduce(.loginWithDigiD)
						}
						.accessibilityIdentifier("login.digid")
				}
			}
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
		LoginView(
			viewModel: LoginViewModel(
				coordinator: nil,
				remoteAuthenticationClient: nil
			)
		)
	}
}
