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
		case digid
		case accesscode
	}
	
	@Published var showAccessCodeButton: Bool
	
	/// The flow coordintator for routing
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
			case .digid:
				coordinator?.handle(.loginWithDigiD)
			case .accesscode:
				coordinator?.handle(.loginWithAccessCode)
		}
	}
}

struct RemoteAuthenticationView: View {
	
	/// The view model
	@StateObject var viewModel: RemoteAuthenticationViewModel
	
    var body: some View {
		ZStack {
			
			Color.Styleguide.background
				.ignoresSafeArea()
				.frame(maxWidth: .infinity, maxHeight: .infinity)
			
			VStack {
				
				Text(verbatim: "Placeholder Digid Keuze scherm")
				
				Button(action: {
					viewModel.reduce(.digid)
				}, label: {
					Text(verbatim: "inloggen DigiD")
				})
					.padding()
				
				if viewModel.showAccessCodeButton {
					
					Button(action: {
						viewModel.reduce(.accesscode)
					}, label: {
						Text(verbatim: "Doorgaan zonder nieuwe gegevens")
					})
						.padding()
				}
				
			}
		}
    }
}

#Preview {
	NavigationStackBackport.NavigationStack {
		RemoteAuthenticationView(viewModel: RemoteAuthenticationViewModel(coordinator: nil)
		)
	}
}
