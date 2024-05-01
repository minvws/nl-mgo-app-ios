/*
 *  Copyright (c) 2024 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
 *  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
 *
 *  SPDX-License-Identifier: EUPL-1.2
 */

import MGOFoundation
import MGOUI

class StoredHealthcareProvidersViewModel: ObservableObject {
	
	/// All posible states of the box
	enum State {
		case empty
	}
	
	/// A list of all the actions this viewModel can handle
	enum Action {
		case backButtonPressed
		case store
		case remove
		case backToSearch
		case done
	}
	
	/// The flow coordinator for routing
	private weak var coordinator: (any AppCoordinatorProtocol)?
	
	@Published var state: State = .empty
	
	/// Initialzier
	/// - Parameter coordinator: the coordinator
	init(coordinator: (any AppCoordinatorProtocol)?) {
		self.coordinator = coordinator
	}
	
	/// Handle any action
	/// - Parameter action: the action to be handled
	func reduce(_ action: StoredHealthcareProvidersViewModel.Action) {
		
		switch action {
			case .backButtonPressed:
				coordinator?.handle(.backButtonPressed)
			case .store:
				#warning("todo store")
			case .remove:
				#warning("todo remove")
			case .backToSearch:
				Current.notificationCenter.post(name: .clearSearch, object: nil)
				coordinator?.handle(.backToSearchHealthcareProvider)
			case .done:
				coordinator?.handle(.finishedSearchingHealthcareProviders)
		}
	}
}

struct StoredHealthcareProvidersView: View {
	
	/// The view model
	@StateObject var viewModel: StoredHealthcareProvidersViewModel
	
	/// The Theme
	@Environment(\.theme) var theme
	
	/// Magic numbers
	private struct ViewTraits {
		enum Button {
			static let insets = EdgeInsets(top: 0, leading: 16, bottom: 16, trailing: 16)
			static let spacing: CGFloat = 16
		}
		enum Content {
			static let spacing: CGFloat = 16
		}
		enum General {
			static let padding: CGFloat = 16
		}
		enum Navigation {
			static let padding: CGFloat = 8
		}
	}
	
	var body: some View {
		
		ScrollViewWithFixedBottom {
			
			VStack(alignment: .leading, spacing: ViewTraits.Content.spacing) {
				
				Text("storedhp_title")
					.rijksoverheidStyle(font: .bold, style: .title)
					.frame(maxWidth: .infinity, alignment: .topLeading)
					.accessibilityAddTraits(.isHeader)
				
				switch viewModel.state {
				case .empty :
					Text("storedhp_body_empty")
						.rijksoverheidStyle(font: .regular, style: .body)
						.frame(maxWidth: .infinity, alignment: .topLeading)
					
				}
				
//				Text("storedhp_body")
//					.rijksoverheidStyle(font: .regular, style: .body)
//					.frame(maxWidth: .infinity, alignment: .topLeading)
			}
			.padding(.horizontal, ViewTraits.General.padding)
			
		} bottomView: {
			VStack(spacing: ViewTraits.Button.spacing) {
				
				CallToActionButton("storedhp_action_again", style: .secondary) {
					viewModel.reduce(.backToSearch)
				}
				
				CallToActionButton("storedhp_action_done") {
					viewModel.reduce(.done)
				}
			}
			.padding(ViewTraits.Button.insets)
		}
		.padding(.top, ViewTraits.Navigation.padding)
		.navigationBarBackButtonHidden(true)
		.navigationBarItems(leading: BackButton {
			viewModel.reduce(.backButtonPressed)
		})
		.background(theme.backgroundPrimary.ignoresSafeArea())
	}
}

#Preview {
	NavigationView {
		StoredHealthcareProvidersView(viewModel: StoredHealthcareProvidersViewModel(coordinator: nil))
	}
}
