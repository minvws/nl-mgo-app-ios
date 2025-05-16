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
	init(coordinator: (any Coordinator)?, remoteAuthenticationClient: RemoteAuthenticationClientProtocol?, urlOpener: URLOpenerProtocol = UIApplication.shared) {
		
		self.coordinator = coordinator
		self.remoteAuthenticationClient = remoteAuthenticationClient
		self.urlOpener = urlOpener
		self.state = .idle
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		
		if action == .loginWithDigiD {
			guard !Current.featureFlagManager.isDemo else {
				coordinator?.handle(Coordination.Action.loggedInWithDigiD)
				return
			}
			authenticate()
		}
	}
	
	private func authenticate() {
		
		guard state == .idle else { return }
		
		Task { @MainActor [remoteAuthenticationClient] in
			do {
				guard let remoteAuthenticationClient else { return }
				
				state = .loading
				
				let authUrl = try await remoteAuthenticationClient.getAuthenticationUrl(callbackUrl: Configuration().getOIDCCallback())
				guard let authenticationUrl = URL(string: authUrl.absoluteString.replacingOccurrences(of: "max:8006", with: "localhost:8006")) else {
					return
				}
				logDebug("authenticationUrl", authenticationUrl)
				state = .idle
				self.urlOpener.openUrlIfPossible(authenticationUrl)
			} catch {
				logError("Error fetching oidc start \(error)")
			}
		}
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
							style: .loginWithDigiDSpinner
						)
						.accessibilityIdentifier("login.loading")
						
					case .idle:
						CallToActionButton(
							"login.digid",
							icon: Image(ImageResource.RemoteAuthentication.digid),
							style: .loginWithDigiD
						) {
							viewModel.reduce(.loginWithDigiD)
						}
						.accessibilityIdentifier("login.digid")
				}
			}
			.padding(ViewTraits.Button.insets)
			
//			CallToActionButton(title: "Send deeplink") {
//				UIApplication.shared.open(URL(string: "mgo-dev://app/login?userinfo=TestContent")!)
//			}
//			.padding(ViewTraits.Button.insets)
		}
		.navigationBarHidden(false)
		.navigationBarBackButtonHidden()
		.background(theme.backgroundPrimary.ignoresSafeArea())
		.layoutForIPad()
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		LoginView(viewModel: LoginViewModel(coordinator: nil, remoteAuthenticationClient: nil)
		)
	}
}
