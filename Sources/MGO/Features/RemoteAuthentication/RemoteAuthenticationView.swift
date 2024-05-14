/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class RemoteAuthenticationViewModel: ObservableObject {
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case loginWithDigiD
		case loginWithAccessCode
	}
	
	@Published var showAccessCodeButton: Bool
	
	/// The flow coordinator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	/// Initializer
	/// - Parameter coordinator: The coordinator
	init(coordinator: (any AppCoordinatorProtocol)?) {
		
		self.coordinator = coordinator
		showAccessCodeButton = Current.secureUserSettings.userHasRemoteAuthentication
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	public func reduce(_ action: Action) {
		
		switch action {
			case .loginWithDigiD:
				coordinator?.handle(Coordination.Action.loginWithDigiD)
			case .loginWithAccessCode:
				coordinator?.handle(Coordination.Action.loginWithAccessCode)
		}
	}
}

struct RemoteAuthenticationView: View {
	
	/// The view model
	@StateObject var viewModel: RemoteAuthenticationViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
    var body: some View {
		ZStack {
			
			theme.backgroundPrimary
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			VStack {
				
				Text(verbatim: "Placeholder Digid Keuze scherm")
				
				if viewModel.showAccessCodeButton {
					Text(verbatim: "Welkom terug")
				} else {
					Text(verbatim: "Bewijs wie je bent")
				}
				
				Button(action: {
					viewModel.reduce(.loginWithDigiD)
				}, label: {
					Text(verbatim: "inloggen DigiD")
				})
					.padding()
				
				if viewModel.showAccessCodeButton {
					
					Button(action: {
						viewModel.reduce(.loginWithAccessCode)
					}, label: {
						Text(verbatim: "Doorgaan zonder nieuwe gegevens")
					})
						.padding()
				}
				
			}
		}
		.navigationBarTitleDisplayMode(.inline)
		.navigationBarBackButtonHidden(true)
	}
}

#Preview {
	NavigationStackBackport.NavigationStack {
		RemoteAuthenticationView(viewModel: RemoteAuthenticationViewModel(coordinator: nil)
		)
	}
}
